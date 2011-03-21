package controllers;
import basehx.BaseController;
import basehx.util.Error;
import basehx.App;
import basehx.tpl.HxTpl;
import models.Student;
import models.Parent;
import models.Interview;
import models.StudentCategory;
import models.SchoolClass;
import models.Timeslot;
import basehx.Log;

class ParentController extends BaseController {
	public function new(args) 
	{
		super(args);
	}
	
	override public function getDefaultAction() 
	{
		return this.welcome;
	}
	
	override public function checkPermissions() 
	{
		/*try 
		{
			session.check();
			var userType = session.get("userType");
			
			if(userType != "parent" && userType != "admin") 
			{
				throw "not a parent - get out!";
			}
		}
		catch(e:Error) 
		{
			App.redirect("/login/");
		}*/
	}
	
	public function welcome() 
	{
		loadTemplate();
		template.assign("pageTitle", "Step 01: Your Details");
		var studentID = session.get("studentID");
		var student = Student.manager.get(studentID);
		for (parent in student.parents)
		{
			var loop = view.newLoop("existingParent");
			loop.assignObject("parent", parent);
		}
		printTemplate();
	}
	
	public function newParent() 
	{
		var studentID = session.get("studentID");
		var student = Student.manager.get(studentID);
		var parent = new Parent();
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
		var parentID = Std.parseInt(parentID_in);
		var parent = Parent.manager.get(parentID);
		var studentID = session.get("studentID");
		var student = Student.manager.get(studentID);
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
		var parentID = session.get("parentID");
		var parent = Parent.manager.get(parentID);
		for (child in parent.children)
		{
			var category = StudentCategory.manager.get(child.categoryID,false);
			// If there are timeslots for this category, ie, if bookings are open
			if(category.timeslots.length > 0) 
			{
				var childBlock = view.newLoop("child");
				childBlock.assignObject("child", child);
				childBlock.assign("category", child.category.name);
				for (schoolClass in child.classes)
				{
					if (schoolClass.teacher.firstName != "NULL")
					{
						var classBlock = childBlock.newLoop("class");
						classBlock.assignObject("class", schoolClass);
						classBlock.assign("parentID", Std.string(parentID));
						classBlock.assignObject("teacher", schoolClass.teacher);
						if(Interview.manager.search({parentID: parentID, studentID: child.id, classID: schoolClass.id}).length > 0) 
						{
							classBlock.newLoop("checkboxChecked");
						}
						else 
						{
							classBlock.newLoop("checkboxUnchecked");
						}
					}
				}
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
			var categoryBlocks = new Hash();
			var timeslotsForCategory = new Hash();
			var selectedSchoolClasses = php.Web.getParamValues("teacher");
			var teacherAvailability = new Hash();
			
			var allTeacherIDs:List<{}> = Lambda.map(selectedSchoolClasses, function(line:String):{} {
				var classID = Std.parseInt(line.split(",")[2]);
				var teacherID = SchoolClass.manager.get(classID).teacherID;
				return { teacherID: teacherID }
			});
			
			for (i in Interview.manager.searchForMultiple(allTeacherIDs))
			{
				var key = i.teacherID + "," + i.timeslotID;
				teacherAvailability.set(key, i.parentID);
			}
			for (line in selectedSchoolClasses)
			{
				var parts = line.split(",");
				var studentID = Std.parseInt(parts[0]);
				var parentID = Std.parseInt(parts[1]);
				var classID = Std.parseInt(parts[2]);
				var student = Student.manager.get(studentID);
				var parent = Parent.manager.get(parentID);
				var schoolClass = SchoolClass.manager.get(classID);
				var teacher = schoolClass.teacher;
				var categoryObj = student.category;
				var category = categoryObj.name;
				var timeslots:List<Timeslot>;
				if(timeslotsForCategory.exists(category)) 
				{
					timeslots = timeslotsForCategory.get(category);
				}
				else 
				{
					timeslots = categoryObj.timeslots;
					//timeslots = Timeslot.manager.search({"categoryID": student.category.id});
					timeslotsForCategory.set(category, timeslots);
				}
				var cat:HxTpl;
				if(categoryBlocks.exists(category) == false) 
				{
					cat = view.newLoop("category");
					categoryBlocks.set(category, cat);
					// this loop adds the headers (the first row, with the time of each appointment)
					for (t in timeslots)
					{
						var d = DateTools.format(t.startTime, "%l:%M");
						cat.newLoop("timeslot").assign("time", d);
					}
				}
				else 
				{
					cat = categoryBlocks.get(category);
				}
				cat.assign("category", category);
				var date = DateTools.format(timeslots.first().startTime, "%A %d %B");
				cat.assign("date", date);
				var bookingLine = cat.newLoop("bookingLine");
				bookingLine.assignObject("student", student);
				bookingLine.assignObject("parent", parent);
				bookingLine.assignObject("class", schoolClass);
				bookingLine.assignObject("teacher", schoolClass.teacher);
				bookingLine.assign("category", category);
				
				// this loop adds the individual checkboxes
				for (t2 in timeslots)
				{
					var checkBox = bookingLine.newLoop("timeslot");
					checkBox.assign("timeslotID", t2.id);
					var key2 = teacher.id + "," + t2.id;
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
		var parentID = session.get("parentID");
		Interview.manager.delete({parentID: parentID});
		var selectedTimeslots = php.Web.getParamValues("Bookings");
		
		for (line in selectedTimeslots)
		{
			var parts = line.split(",");
			var studentID = Std.parseInt(parts[0]);
			var classID = Std.parseInt(parts[1]);
			var timeslotID = Std.parseInt(parts[2]);
			var interview = new Interview();
			interview.studentID = studentID;
			interview.parentID = parentID;
			interview.classID = classID;
			interview.teacherID = SchoolClass.manager.get(classID).teacherID;
			interview.timeslotID = timeslotID;
			try
			{
				interview.insert();
				App.redirect("/parent/viewtimetable/");
			}
			catch(e:String)
			{
				if(e.indexOf("Parent-Timeslot-Unique") >= 0) 
				{
					Log.warning("You're trying to book multiple interviews at this timeslot.");
				}
				else if(e.indexOf("Parent-Student-SchoolClass-Unique") >= 0) 
				{
					Log.warning("You have already booked an interview with this teacher.");
				}
				else if(e.indexOf("SchoolClass-Timeslot-Unique") >= 0) 
				{
					Log.warning("We're sorry, the teacher is no longer available at this time.");
				}
				else 
				{
					trace("Failed to do this one.  error:" + e);
				}
				trace("Let's load the form and try again...");
			}
		}
	}
	
	public function viewTimetable() {
		loadTemplate();
		template.assign("pageTitle", "Step 04: Your Timetable");
		var parentID = session.get("parentID");
		var parent = Parent.manager.get(parentID);
		var categoryBlocks = new Hash();
		view.assignObject("parent", parent);
		Interview.manager.setOrderBy("timeslotID");
		var interviews = Lambda.array(parent.interviews);
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
			loop.assignObject("teacher", interview.teacher);
			loop.assignObject("student", interview.student);
			var startTime = DateTools.format(interview.timeslot.startTime, "%I:%M");
			var endTime = DateTools.format(interview.timeslot.endTime, "%I:%M");
			loop.assign("startTime", startTime);
			loop.assign("endTime", endTime);
		}
		
		printTemplate();
	}
	public static var aliases = [];
}
