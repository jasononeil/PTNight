package controllers;
import basehx.BaseController;

class ParentController extends BaseController {
	public function new(args) 
	{
		super(args);
	}
	
	override public function getDefaultAction() 
	{
		return this.welcome;
	}
	
	public function checkPermissions() 
	{
		try 
		{
			if (session == null) { throw "No session"; }
			session.check();
			userType = session.get("userType");
			
			if(userType != "parent" && userType != "admin") 
			{
				throw "not a parent - get out!";
			}
		}
		catch(e:Error) 
		{
			App.redirect("/login/");
		}
	}
	
	public function welcome() 
	{
		loadTemplate();
		template.assign("pageTitle", "Step 01: Your Details");
		studentID = session.get("studentID");
		student = Student.manager.get(studentID);
		for (parent in student.parents())
		{
			loop = view.newLoop("existingParent");
			loop.assignObject("parent", parent);
			unset(loop);
		}
		printTemplate();
	}
	
	public function newParent() 
	{
		studentID = session.get("studentID");
		student = Student.manager.get(studentID);
		parent = new Parent();
		parent.firstName = params.get("first");
		parent.lastName = params.get("last");
		parent.familyID = student.familyID;
		parent.email = params.get("email");
		parent.insert();
		session.set("parentID", parent.id);
		App.redirect("/parent/selectteachers/");
	}
	
	public function updateParent(parentID_in) 
	{
		parentID = Std.parseInt(parentID_in);
		parent = Parent.manager.get(parentID);
		studentID = session.get("studentID");
		student = Student.manager.get(studentID);
		if(student.familyID != parent.familyID) 
		{
			throw "It looks like you're trying to update a user that is not tied to your login details.  Sorry, you cannot do that.";
		}
		parent.firstName = params.get("first");
		parent.lastName = params.get("last");
		parent.email = params.get("email");
		parent.update();
		session.set("parentID", parentID);
		if(Interview.manager.search({parentID: parent.id}).length > 0) 
		{
			App.redirect("/parent/viewtimetable/");
		}
		else 
		{
			App.redirect("/parent/selectteachers/");
		}
	}
	
	public function selectTeachers() 
	{
		loadTemplate();
		template.assign("pageTitle", "Step 02: The Teachers");
		parentID = session.get("parentID");
		parent = Parent.manager.get(parentID);
		for (child in parent.children)
		{
			//echo "child";
			category = StudentCategory.manager.get(child.categoryID,false);
			if(category.getter_timeslots().length > 0) 
			{
				//echo "has teacher";
				childBlock = view.newLoop("child");
				childBlock.assignObject("child", child);
				childBlock.assign("category", child.get_category().name);
				for (schoolClass in child.classes)
				{
					classBlock = childBlock.newLoop("class");
					if(Interview.manager.search({parentID: parentID, studentID: child.id, classID: schoolClass.id}).length > 0) 
					{
						classBlock.newLoop("checkboxChecked");
					}
					else 
					{
						classBlock.newLoop("checkboxUnchecked");
					}
					classBlock.assignObject("class", schoolClass);
					classBlock.assign("parentID", parentID);
					classBlock.assignObject("teacher", schoolClass.get_teacher());
					unset(classBlock);
				}
			}
			else 
			{
				//
			}
		}
		printTemplate();
	}
	public function bookings() 
	{
		loadTemplate();
		template.assign("pageTitle", "Step 03: The Times");
		if(params.exists("teacher")) 
		{
			categoryBlocks = new Hash();
			timeslotsForCategory = new Hash();
			selectedSchoolClasses = php_Web.getParamValues("teacher");
			teacherAvailability = new Hash();
			/*allTeacherIDs = Lambda.map(selectedSchoolClasses, array(new _hx_lambda(array("allTeacherIDs": &allTeacherIDs, "categoryBlocks": &categoryBlocks, "selectedSchoolClasses": &selectedSchoolClasses, "teacherAvailability": &teacherAvailability, "timeslotsForCategory": &timeslotsForCategory), null, array('line'), "{
				\classID = Std.parseInt(_hx_array_get(_hx_explode(\",\", \line), 2));
				\teacherID = SchoolClass.\manager.get(\classID, null).teacherID;
				return {\"teacherID\": \teacherID));
			}"), 'execute1'));*/
			throw "fix the thing above";
			for (i in Interview.manager.searchForMultiple(allTeacherIDs))
			{
				key = i.teacherID + "," + i.timeslotID;
				teacherAvailability.set(key, i.parentID);
			}
			for (line in selectedSchoolClasses)
			{
				parts = _hx_explode(",", line);
				studentID = Std.parseInt(parts[0]);
				parentID = Std.parseInt(parts[1]);
				classID = Std.parseInt(parts[2]);
				student = Student.manager.get(studentID);
				parent = Parent.manager.get(parentID);
				schoolClass = SchoolClass.manager.get(classID);
				teacher = schoolClass.get_teacher();
				categoryObj = student.get_category();
				category = categoryObj.name;
				timeslots = null;
				if(timeslotsForCategory.exists(category)) 
				{
					timeslots = timeslotsForCategory.get(category);
				}
				else 
				{
					timeslots = categoryObj.getter_timeslots();
					//timeslots = Timeslot.manager.search({"categoryID": student.get_category().id});
					timeslotsForCategory.set(category, timeslots);
				}
				cat = null;
				if(categoryBlocks.exists(category) == false) 
				{
					cat = view.newLoop("category");
					categoryBlocks.set(category, cat);
					for (t in timeslots)
					{
						d = DateTools.format(t.startTime, "%l:%M");
						cat.newLoop("timeslot", null).assign("time", d);
					}
				}
				else 
				{
					cat = categoryBlocks.get(category);
				}
				cat.assign("category", category);
				date = DateTools.format(timeslots.first().startTime, "%A %d %B");
				cat.assign("date", date);
				bookingLine = cat.newLoop("bookingLine");
				bookingLine.assignObject("student", student);
				bookingLine.assignObject("parent", parent);
				bookingLine.assignObject("class", schoolClass);
				bookingLine.assignObject("teacher", schoolClass.get_teacher());
				bookingLine.assign("category", category);
				for (t2 in timeslots)
				{
					checkBox = bookingLine.newLoop("timeslot");
					checkBox.assign("timeslotID", t2.id);
					key2 = teacher.id + "," + t2.id;
					if(teacherAvailability.exists(key2)) 
					{
						if(teacherAvailability.get(key2) == parent.id) 
						{
							checkBox.newLoop("showCheckboxChecked");
						}
					}
					else 
					{
						checkBox.newLoop("showCheckboxUnchecked");
					}
				}
			}
		}
		printTemplate();
	}
	public function makeBookings() 
	{
		parentID = session.get("parentID");
		Interview.manager.delete({parentID: parentID});
		selectedTimeslots = php_Web.getParamValues("Bookings");
		{
			for (line in selectedTimeslots)
			{
				parts = line.split(",");
				studentID = Std.parseInt(parts[0]);
				classID = Std.parseInt(parts[1]);
				timeslotID = Std.parseInt(parts[2]);
				interview = new Interview();
				interview.studentID = studentID;
				interview.parentID = parentID;
				interview.classID = classID;
				interview.teacherID = SchoolClass.manager.get(classID, null).teacherID;
				interview.timeslotID = timeslotID;
				try
				{
					interview.insert();
					App.redirect("/parent/viewtimetable/");
				}
				catch(e:Error)
				{
					if(e.indexOf("Parent-Timeslot-Unique") >= 0) 
					{
						Log.warning("You're trying to book multiple interviews at this timeslot.");
					}
					else if(_hx_string_call(e, "indexOf", array("Parent-Student-SchoolClass-Unique")) >= 0) 
					{
						Log.warning("You have already booked an interview with this teacher.");
					}
					else if(_hx_string_call(e, "indexOf", array("SchoolClass-Timeslot-Unique")) >= 0) 
					{
						Log.warning("We're sorry, the teacher is no longer available at this time.");
					}
					else {
								trace("Failed to do this one.  error:" + e);
					}
					trace("Let's load the form and try again...");
				}
			}
		}
	}
	public function viewTimetable() {
		loadTemplate();
		template.assign("pageTitle", "Step 04: Your Timetable");
		parentID = session.get("parentID");
		parent = Parent.manager.get(parentID);
		categoryBlocks = new Hash();
		view.assignObject("parent", parent);
		Interview.manager.setOrderBy("timeslotID");
		interviews = Lambda.harray(parent.getter_interviews());
		/*interviews.sort(array(new _hx_lambda(array("categoryBlocks": &categoryBlocks, "interviews": &interviews, "parent": &parent, "parentID": &parentID), null, array('a','b'), "{
			return intval(\a.get_timeslot().startTime.getTime() - \b.get_timeslot().startTime.getTime());
		}"), 'execute2'));*/
		throw "sort this out";
		for (interview in interviews)
		{
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
			loop.assignObject("teacher", interview.get_teacher());
			loop.assignObject("student", interview.get_student());
			startTime = DateTools.format(interview.get_timeslot().startTime, "%I:%M");
			endTime = DateTools.format(interview.get_timeslot().getter_endTime(), "%I:%M");
			loop.assign("startTime", startTime);
			loop.assign("endTime", endTime);
			unset(startTime,loop,interview,endTime,date,category,cat);
		}
		
		printTemplate();
	}
	public static var aliases = [];
}
