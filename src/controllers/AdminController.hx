package controllers;
import basehx.BaseController;

class AdminController extends basehx.BaseController {
	public function new(args)
	{
		super(args);
	}
	
	override public function getDefaultAction() 
	{
		return this.home;
	}
	
	public function checkPermissions() {
		try 
		{
			session.check();
			if(session.get("userType") == "admin") 
			{
				throw "You don't look very trustworthy!";
			}
		}
		catch(e:Error) 
		{
			basehx.App.redirect("/login/");
		}
	}
	
	public function home() 
	{
		loadTemplate();
		template.assign("pageTitle", "Admin Panel");
		printTemplate();
	}
	
	public function addTimeSlots(date_in, start_in, end_in, duration_in, categories_in) 
	{
		basehx.DbControl.connect();
		loadTemplate();
		date = Date.fromString(date_in);
		start = date.getTime() + basehx.MyDateTools.timeFromString(start_in).getTime();
		end = date.getTime() + basehx.MyDateTools.timeFromString(end_in).getTime();
		duration = Std.parseInt(duration_in);
		//category = StudentCategory.manager.search({name: category_in}).first().id;
		while(end > start) 
		{
			var t = new Timeslot();
			t.startTime = Date.fromTime(start);
			t.length = duration;
			t.categoryID = null;
			//trace(t.startTime.toString());
			t.insert();
			var categories_arr = categories_in.split(",");
			for (category_in in categories_arr)
			{
				category = StudentCategory.manager.search({ name:category_in }).first().id;
				var c = new Timeslot_join_StudentCategory();
				c.timeslotID = t.id;
				c.studentCategoryID = category;
				c.insert();
			}

			start = start + duration * 1000;
		}
		template.assign("date",date_in,null);
		template.assign("starttime",start_in,null);
		template.assign("endtime",end_in,null);
		template.assign("duration",duration / 60,null);
		template.assign("category",category,null);
		basehx.DbControl.close();
		printTemplate();
	}
	
	public function importMazeData() 
	{
		basehx.DbControl.connect();
		loadTemplate();
		var hash = php.Web.getMultipart(10485760);
		if(hash.exists("mazedata")) 
		{
			csv = hash.get("mazedata");
			importMazeData_execute(csv);
		}
		printTemplate();
		basehx.DbControl.close();
	}
	
	public function importMazeData_execute(csv) 
	{
		studentIDs = new Hash();
		teacherIDs = new Hash();
		classIDs = new IntHash();
		familyIDs = new Hash();
		SchoolClass_join_Student.manager.delete([]);
		Family.manager.delete([]);
		Teacher.manager.delete([]);
		lines = csv.split("\n");
		{
			for (line in lines)
			{
				if(line != "") 
				{
					parts = _hx_explode(",", line);
					studentKey = parts[0];
					studentFirst = parts[1];
					studentLast = parts[2];
					studentCategory = parts[3];
					studentYearGroup = Std.parseInt(_hx_substr(studentCategory, 1, 2));
					studentGraduation = (Date.now().getFullYear() + 12) - studentYearGroup;
					studentUsername = studentFirst.toLowerCase() + studentLast.toLowerCase() + studentGraduation;
					studentUsername = _hx_deref(new EReg("[^a-zA-Z0-9]", "")).replace(studentUsername, "");
					familyKey = parts[9];
					if(familyIDs.exists(familyKey) == false) 
					{
						family = new Family();
						family.mazeKey = familyKey;
						family.insert();
						familyIDs.set(familyKey, family.id);
					}
					if(studentIDs.exists(studentKey) == false) 
					{
						student = new Student();
						student.firstName = studentFirst;
						student.lastName = studentLast;
						student.username = studentUsername;
						student.categoryID = StudentCategory.manager.search({name: studentCategory}).first().id;
						student.familyID = familyIDs.get(familyKey);
						student.insert();
						studentIDs.set(studentKey, student.id);
					}
					teacherKey = parts[6];
					if(teacherIDs.exists(teacherKey) == false) 
					{
						teacher = new Teacher();
						teacher.firstName = parts[7];
						teacher.lastName = parts[8];
						teacher.username = teacher.firstName.substr(0, 1).toLowerCase() + teacher.lastName.toLowerCase();
						teacher.username = ~/[^a-zA-Z0-9]/.replace(teacher.username, "");
						teacher.email = teacher.username + "@somerville.wa.edu.au";
						teacher.insert();
						teacherIDs.set(teacherKey, teacher.id);
					}
					classKey = Std.parseInt(parts[5]);
					if(classIDs.exists(classKey) == false) {
						schoolClass = new SchoolClass();
						schoolClass.className = parts[4];
						schoolClass.teacherID = teacherIDs.get(teacherKey);
						schoolClass.insert();
						classIDs.set(classKey, schoolClass.id);
					}
					studentInSchoolClass = new SchoolClass_join_Student();
					studentInSchoolClass.classID = classIDs.get(classKey);
					studentInSchoolClass.studentID = studentIDs.get(studentKey);
					studentInSchoolClass.insert();
					php.Lib.hprint(". ");
					flush();
				}
			}
		}
		php.Lib.hprint("<pre>");
		trace("Done import.  Show some stats?");
		trace(("Imported " + Student.manager.count()) + " students");
		trace(("With " + Parent.manager.count()) + " parents");
		trace(("(that's " + Family.manager.count()) + " families)");
		trace(("In " + SchoolClass.manager.count()) + " classes");
		trace(("(that's " + SchoolClass_join_Student.manager.count()) + " combinations)");
		trace(("Taught by " + Teacher.manager.count()) + " teachers");
		php.Lib.hprint("</pre>");
	}
	
	public function viewAllParents() 
	{
		loadTemplate();
		template.assign("pageTitle", "Viewing All Parents");
		Parent.manager.setOrderBy("lastName");
		view.useListInLoop(Parent.manager.all(false), "parent", "parent");
		printTemplate();
	}
	
	public function viewParent(id_in)
	{
		parentID = Std.parseInt(id_in);
		session.set("parentID", parentID);
		basehx.App.redirect("/parent/viewtimetable/");
	}
	
	public function customAppointment(id_in) 
	{
		loadTemplate();
		parentID = Std.parseInt(id_in);
		parent = Parent.manager.get(parentID);
		template.assign("pageTitle", "Custom Appointments");
		view.assignObject("parent", parent);
		Interview.manager.setOrderBy("timeslotID");
		interviews = Lambda.harray(parent.getter_interviews());
		throw "sort this out";
		/*interviews.sort(
		
		array(new _hx_lambda(array("id_in": &id_in, "interviews": &interviews, "parent": &parent, "parentID": &parentID), null, array('a','b'), "{
			return intval(\a.get_timeslot().startTime.getTime() - \b.get_timeslot().startTime.getTime());
		}"), 'execute2'));*/
		{
			for (interview in interviews)
			{
				loop = view.newLoop("interview");
				loop.assign("interviewID", interview.id);
				loop.assignObject("class", interview.get_schoolClass());
				loop.assignObject("teacher", interview.get_teacher());
				loop.assignObject("student", interview.get_student());
				startTime = DateTools.format(interview.get_timeslot().startTime, "%h %e %I:%M");
				loop.assign("startTime", startTime);
				unset(startTime,loop,interview);
			}
		}
	}
	public function newCustomAppointment(id_in) 
	{
		loadTemplate();
		parentID = Std.parseInt(id_in);
		parent = Parent.manager.get(parentID);
		view.assignObject("parent", parent);
		view.useListInLoop(parent.getter_children(), "student", "student");
		Teacher.manager.setOrderBy("lastName");
		view.useListInLoop(Teacher.manager.all(false), "teacher", "teacher");
		printTemplate();
	}
	
	public function setTimesCustomAppointment() 
	{
		loadTemplate();
		template.assign("pageTitle", "Select Timeslot");
		params = php_Web.getParams();
		parentID = Std.parseInt(params.get("parentID"));
		teacherID = Std.parseInt(params.get("teacherID"));
		studentID = Std.parseInt(params.get("studentID"));
		interviewID = Std.parseInt(params.get("interviewID"));
		view.assign("parentID", parentID);
		view.assign("teacherID", teacherID);
		view.assign("studentID", studentID);
		view.assign("interviewID", interviewID);
		teacherAvailability = new Hash();
		for (i in Interview.manager.search({teacherID: teacherID}))
		{
			teacherAvailability.set("" + i.timeslotID, i.parentID);
		}
		parentAvailability = new Hash();
		for (i2 in Interview.manager.search({parentID: parentID}))
		{
			parentAvailability.set("" + i2.timeslotID, i2.id);
		}
		classID = null;
		student = Student.manager.get(studentID);
		category = student.get_category().name;
		timeslots = Timeslot.manager.all(null);
		for (it3 in timeslots)
		{
			key = "" + t.id;
			if(teacherAvailability.exists(key) && teacherAvailability.get(key) != parentID) 
			{ /* do nothing */ }
			else 
			{
				if(parentAvailability.exists(key) && parentAvailability.get(key) != interviewID) 
				{ /* do nothing */ }
				else 
				{
					var timeslot = view.newLoop("timeslot");
					time = DateTools.format(t.startTime, "%A %d %B %l:%M");
					timeslot.assign("id", t.id);
					timeslot.assign("time", time);
					if(interviewID != null) 
					{
						interview = Interview.manager.get(interviewID);
						if(interview.timeslotID == t.id) 
						{
							view.newLoop("timeslotSelected", null).assign("id", t.id, null).assign("time", time);
						}
					}
				}
			}
			unset(timeslot,time,key,interview);
		}
		printTemplate();
	}
	
	public function bookCustomAppointment() 
	{
		params = php_Web.getParams();
		i = new Interview();
		i.id = ((params.exists("interviewID")) ? Std.parseInt(params.get("interviewID")) : null);
		i.parentID = Std.parseInt(params.get("parentID"));
		i.teacherID = Std.parseInt(params.get("teacherID"));
		i.studentID = Std.parseInt(params.get("studentID"));
		i.timeslotID = Std.parseInt(params.get("timeslotID"));
		if(i.id == null) 
		{
			i.insert();
		}
		else 
		{
			i.update();
		}
		basehx.App.redirect(("/admin/customappointment/" + i.parentID) + "/");
	}
	
	public function editCustomAppointment(id_in) 
	{
		loadTemplate();
		interviewID = Std.parseInt(id_in);
		interview = Interview.manager.get(interviewID);
		parentID = interview.parentID;
		parent = Parent.manager.get(parentID);
		view.assignObject("parent", parent);
		view.assignObject("interview", interview);
		for (student in parent.getter_children())
		{
			if(student.id == interview.studentID) 
			{
				view.newLoop("studentSelected", null).assignObject("student", student);
			}
			view.newLoop("student", null).assignObject("student", student);
		}
		Teacher.manager.setOrderBy("lastName");
		for (teacher in Teacher.manager.all(false))
		{
			if(teacher.id == interview.teacherID) 
			{
				view.newLoop("teacherSelected", null).assignObject("teacher", teacher);
			}
			view.newLoop("teacher", null).assignObject("teacher", teacher);
		}
		printTemplate();
	}
	
	public function deleteCustomAppointment(id_in) 
	{
		interviewID = Std.parseInt(id_in);
		i = Interview.manager.get(interviewID);
		parentID = i.parentID;
		Interview.manager.delete({id: interviewID});
		basehx.App.redirect(("/admin/customappointment/" + parentID) + "/");
	}
	
	public function viewAllTeachers() 
	{
		loadTemplate();
		template.assign("pageTitle", "Viewing All Teachers");
		Teacher.manager.setOrderBy("lastName");
		view.useListInLoop(Teacher.manager.all(false), "teacher", "teacher");
		printTemplate();
	}
	
	public function viewTeacher(id) 
	{
		loadTemplate();
		template.assign("pageTitle", "Your Timetable");
		teacherID = Std.parseInt(id);
		teacher = Teacher.manager.get(teacherID);
		categoryBlocks = new Hash();
		view.assignObject("teacher", teacher);
		Interview.manager.setOrderBy("timeslotID");
		interviews = Lambda.harray(teacher.getter_interviews());
		/*interviews.sort(array(new _hx_lambda(array("categoryBlocks": &categoryBlocks, "id": &id, "interviews": &interviews, "teacher": &teacher, "teacherID": &teacherID), null, array('a','b'), "{
			return intval(\a.get_timeslot().startTime.getTime() - \b.get_timeslot().startTime.getTime());
		}"), 'execute2'));*/
		throw "sort this out";
		{
			while(_g < interviews.length) 
			{
				interview = interviews[_g];
				++_g;
				category = interview.get_student().get_category().name;
				cat = null;
				if(categoryBlocks.exists(category) == false) 
				{
					cat = view.newLoop("category");
					categoryBlocks.set(category, cat);
				}
				else 
				{
					cat = categoryBlocks.get(category);
				}
				cat.assign("category", category);
				date = DateTools.format(interview.get_timeslot().startTime, "%A %d %B");
				cat.assign("date", date);
				loop = cat.newLoop("interview");
				loop.assignObject("class", interview.get_schoolClass());
				loop.assignObject("parent", interview.get_parent());
				loop.assignObject("student", interview.get_student());
				startTime = DateTools.format(interview.get_timeslot().startTime, "%I:%M");
				endTime = DateTools.format(interview.get_timeslot().getter_endTime(), "%I:%M");
				loop.assign("startTime", startTime);
				loop.assign("endTime", endTime);
			}
		}
		printTemplate();
	}
	
	public function printAllTeachers() 
	{
		allTimetables = new StringBuf();
		pageTemplateFile = "views/Empty.tpl";
		Interview.manager.setOrderBy("timeslotID");
		Teacher.manager.setOrderBy("lastName");
		for (teacher in Teacher.manager.all())
		{
			php.Lib.print(" ");
			viewTeacher(Std.string(teacher.id));
			allTimetables.b += output;
			allTimetables.b += "\n<hr class=\"page-break\" />";
		}
		pageTemplateFile = null;
		loadTemplate();
		template.assign("pageTitle", "All Teacher Timetables");
		template.assign("printAll", allTimetables);
		printTemplate();
	}
	public static var aliases = [];
}
