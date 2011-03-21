package controllers;
import basehx.BaseController;
import basehx.util.Error;
import basehx.tpl.HxTpl;
import models.Teacher;
import models.Student;
import models.Parent;
import models.Family;
import models.SchoolClass;
import models.StudentCategory;
import models.Timeslot;
import models.Interview;
import models.SchoolClass_join_Student;
import models.Timeslot_join_StudentCategory;

class AdminController extends basehx.BaseController {
	public function new(args)
	{
		super(args);
	}
	
	override public function getDefaultAction() 
	{
		return this.home;
	}
	
	override public function checkPermissions() {
		try 
		{
			session.check();
			if(session.get("userType") != "admin") 
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
	
	private function timeFromString(str_in:String):Date
	{
		return Date.fromString("1970-01-01 " + str_in);
	}
	
	public function addTimeSlots(date_in, start_in, end_in, duration_in, categories_in:String) 
	{
		basehx.DbControl.connect();
		loadTemplate();
		var date = Date.fromString(date_in);
		var start = date.getTime() + timeFromString(start_in).getTime();
		var end = date.getTime() + timeFromString(end_in).getTime();
		var duration = Std.parseInt(duration_in);
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
				var category = StudentCategory.manager.search({ name:category_in }).first().id;
				var c = new Timeslot_join_StudentCategory();
				c.timeslotID = t.id;
				c.studentCategoryID = category;
				c.insert();
			}

			start = start + duration * 1000;
		}
		template.assign("date",date_in);
		template.assign("starttime",start_in);
		template.assign("endtime",end_in);
		template.assign("duration",duration / 60);
		template.assign("category",categories_in);
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
			var csv = hash.get("mazedata");
			importMazeData_execute(csv);
		}
		printTemplate();
		basehx.DbControl.close();
	}
	
	public function importMazeData_execute(csv:String) 
	{
		var studentIDs = new Hash();
		var teacherIDs = new Hash();
		var classIDs = new IntHash();
		var familyIDs = new Hash();
		SchoolClass_join_Student.manager.delete([]);
		Family.manager.delete([]);
		Teacher.manager.delete([]);
		var lines = csv.split("\n");
		for (line in lines)
		{
			if(line != "") 
			{
				var parts = line.split(",");
				var studentKey = parts[0];
				var studentFirst = parts[1];
				var studentLast = parts[2];
				var studentCategory = parts[3];
				var studentYearGroup = Std.parseInt(studentCategory.substr(1, 2));
				var studentGraduation = (Date.now().getFullYear() + 12) - studentYearGroup;
				var studentUsername = studentFirst.toLowerCase() + studentLast.toLowerCase() + studentGraduation;
				var studentUsername = ~/[^a-zA-Z0-9]/.replace(studentUsername, "");
				var familyKey = parts[9];
				if(familyIDs.exists(familyKey) == false) 
				{
					var family = new Family();
					family.mazeKey = familyKey;
					family.insert();
					familyIDs.set(familyKey, family.id);
				}
				if(studentIDs.exists(studentKey) == false) 
				{
					var student = new Student();
					student.firstName = studentFirst;
					student.lastName = studentLast;
					student.username = studentUsername;
					student.categoryID = StudentCategory.manager.search({name: studentCategory}).first().id;
					student.familyID = familyIDs.get(familyKey);
					student.insert();
					studentIDs.set(studentKey, student.id);
				}
				var teacherKey = parts[6];
				if(teacherIDs.exists(teacherKey) == false) 
				{
					var teacher = new Teacher();
					teacher.firstName = parts[7];
					teacher.lastName = parts[8];
					teacher.username = teacher.firstName.substr(0, 1).toLowerCase() + teacher.lastName.toLowerCase();
					teacher.username = ~/[^a-zA-Z0-9]/.replace(teacher.username, "");
					teacher.email = teacher.username + "@somerville.wa.edu.au";
					teacher.insert();
					teacherIDs.set(teacherKey, teacher.id);
				}
				var classKey = Std.parseInt(parts[5]);
				if(classIDs.exists(classKey) == false) {
					var schoolClass = new SchoolClass();
					schoolClass.className = parts[4];
					schoolClass.teacherID = teacherIDs.get(teacherKey);
					schoolClass.insert();
					classIDs.set(classKey, schoolClass.id);
				}
				var studentInSchoolClass = new SchoolClass_join_Student();
				studentInSchoolClass.classID = classIDs.get(classKey);
				studentInSchoolClass.studentID = studentIDs.get(studentKey);
				studentInSchoolClass.insert();
				php.Lib.print(". ");
				untyped __call__("flush");
			}
		}
		php.Lib.print("<pre>");
		trace("Done import.  Show some stats?");
		trace(("Imported " + Student.manager.count()) + " students");
		trace(("With " + Parent.manager.count()) + " parents");
		trace(("(that's " + Family.manager.count()) + " families)");
		trace(("In " + SchoolClass.manager.count()) + " classes");
		trace(("(that's " + SchoolClass_join_Student.manager.count()) + " combinations)");
		trace(("Taught by " + Teacher.manager.count()) + " teachers");
		php.Lib.print("</pre>");
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
		var parentID = Std.parseInt(id_in);
		session.set("parentID", parentID);
		basehx.App.redirect("/parent/viewtimetable/");
	}
	
	public function customAppointment(id_in) 
	{
		loadTemplate();
		var parentID = Std.parseInt(id_in);
		var parent = Parent.manager.get(parentID);
		template.assign("pageTitle", "Custom Appointments");
		view.assignObject("parent", parent);
		Interview.manager.setOrderBy("timeslotID");
		var interviews = Lambda.array(parent.interviews);
		interviews.sort(function (a,b) {
			return Std.int(a.timeslot.startTime.getTime() - b.timeslot.startTime.getTime());
		});
		
		
		
		for (interview in interviews)
		{
			var loop = view.newLoop("interview");
			loop.assign("interviewID", interview.id);
			loop.assignObject("class", interview.schoolClass);
			loop.assignObject("teacher", interview.teacher);
			loop.assignObject("student", interview.student);
			var startTime = DateTools.format(interview.timeslot.startTime, "%h %e %I:%M");
			loop.assign("startTime", startTime);
		}
		printTemplate();
	}
	public function newCustomAppointment(id_in) 
	{
		loadTemplate();
		var parentID = Std.parseInt(id_in);
		var parent = Parent.manager.get(parentID);
		view.assignObject("parent", parent);
		view.useListInLoop(parent.children, "student", "student");
		Teacher.manager.setOrderBy("lastName");
		view.useListInLoop(Teacher.manager.all(false), "teacher", "teacher");
		printTemplate();
	}
	
	public function setTimesCustomAppointment() 
	{
		loadTemplate();
		template.assign("pageTitle", "Select Timeslot");
		var params = php.Web.getParams();
		var parentID = Std.parseInt(params.get("parentID"));
		var teacherID = Std.parseInt(params.get("teacherID"));
		var studentID = Std.parseInt(params.get("studentID"));
		var interviewID = Std.parseInt(params.get("interviewID"));
		view.assign("parentID", parentID);
		view.assign("teacherID", teacherID);
		view.assign("studentID", studentID);
		view.assign("interviewID", interviewID);
		var teacherAvailability = new Hash();
		for (i in Interview.manager.search({teacherID: teacherID}))
		{
			teacherAvailability.set("" + i.timeslotID, i.parentID);
		}
		var parentAvailability = new Hash();
		for (i2 in Interview.manager.search({parentID: parentID}))
		{
			parentAvailability.set("" + i2.timeslotID, i2.id);
		}
		var classID:Int;
		var student = Student.manager.get(studentID);
		var category = student.category.name;
		var timeslots = Timeslot.manager.all(null);
		for (t in timeslots)
		{
			var key = "" + t.id;
			if(teacherAvailability.exists(key) && teacherAvailability.get(key) != parentID) 
			{ /* do nothing */ }
			else 
			{
				if(parentAvailability.exists(key) && parentAvailability.get(key) != interviewID) 
				{ /* do nothing */ }
				else 
				{
					var timeslot = view.newLoop("timeslot");
					var time = DateTools.format(t.startTime, "%A %d %B %l:%M");
					timeslot.assign("id", t.id);
					timeslot.assign("time", time);
					if(interviewID != null) 
					{
						var interview = Interview.manager.get(interviewID);
						if(interview.timeslotID == t.id) 
						{
							view.newLoop("timeslotSelected").assign("id", t.id).assign("time", time);
						}
					}
				}
			}
		}
		printTemplate();
	}
	
	public function bookCustomAppointment() 
	{
		var params = php.Web.getParams();
		var i = new Interview();
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
		var interviewID = Std.parseInt(id_in);
		var interview = Interview.manager.get(interviewID);
		var parentID = interview.parentID;
		var parent = Parent.manager.get(parentID);
		view.assignObject("parent", parent);
		view.assignObject("interview", interview);
		for (student in parent.children)
		{
			if(student.id == interview.studentID) 
			{
				view.newLoop("studentSelected").assignObject("student", student);
			}
			view.newLoop("student").assignObject("student", student);
		}
		Teacher.manager.setOrderBy("lastName");
		for (teacher in Teacher.manager.all(false))
		{
			if(teacher.id == interview.teacherID) 
			{
				view.newLoop("teacherSelected").assignObject("teacher", teacher);
			}
			view.newLoop("teacher").assignObject("teacher", teacher);
		}
		printTemplate();
	}
	
	public function deleteCustomAppointment(id_in) 
	{
		var interviewID = Std.parseInt(id_in);
		var i = Interview.manager.get(interviewID);
		var parentID = i.parentID;
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
		loadTemplate("views/teacher/viewTimetable.tpl");
		template.assign("pageTitle", "Your Timetable");
		var teacherID = Std.parseInt(id);
		var teacher = Teacher.manager.get(teacherID);
		var categoryBlocks = new Hash();
		view.assignObject("teacher", teacher);
		Interview.manager.setOrderBy("timeslotID");
		var interviews:Array<Interview> = Lambda.array(teacher.interviews);
		
		interviews.sort(function (a,b) {
			return Std.int(a.timeslot.startTime.getTime() - b.timeslot.startTime.getTime());
		});
		
		for (interview in interviews)
		{
			var category = interview.student.category.name;
			var cat:HxTpl;
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
			var date = DateTools.format(interview.timeslot.startTime, "%A %d %B");
			cat.assign("date", date);
			var loop = cat.newLoop("interview");
			loop.assignObject("class", interview.schoolClass);
			loop.assignObject("parent", interview.parent);
			loop.assignObject("student", interview.student);
			var startTime = DateTools.format(interview.timeslot.startTime, "%I:%M");
			var endTime = DateTools.format(interview.timeslot.endTime, "%I:%M");
			loop.assign("startTime", startTime);
			loop.assign("endTime", endTime);
		}
		
		printTemplate();
	}
	
	public function printAllTeachers() 
	{
		var allTimetables = new StringBuf();
		pageTemplateFile = "views/Empty.tpl";
		Interview.manager.setOrderBy("timeslotID");
		Teacher.manager.setOrderBy("lastName");
		for (teacher in Teacher.manager.all())
		{
			viewTeacher(Std.string(teacher.id));
			allTimetables.add("\n<hr class=\"page-break\" />");
			allTimetables.add(output);
		}
		pageTemplateFile = null;
		loadTemplate();
		template.assign("pageTitle", "All Teacher Timetables");
		view.assign("printAll", allTimetables, false);
		printTemplate();
	}
	public static var aliases = [];
}
