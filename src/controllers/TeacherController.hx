package controllers;
import basehx.BaseController;
import basehx.tpl.Tpl;
import basehx.util.Error;
import basehx.App;
import models.Teacher;
import models.Interview;
using DateTools;
class TeacherController extends BaseController 
{
	public function new(args) 
	{
		super(args);
	}
	
	override public function getDefaultAction() 
	{
		return this.viewTimetable;
	}
	
	override public function checkPermissions() 
	{
		try 
		{
			session.check();
			var userType = session.get("userType");
			if(userType != "teacher" && userType != "admin") 
			{
				throw "not a teacher - get out!";
			}
		}
		catch(e:Error) 
		{
			App.redirect("/login/");
		}
	}
	public function welcome() {
		loadTemplate();
		printTemplate();
	}
	public function viewTimetable() 
	{
		loadTemplate();
		template.assign("pageTitle", "Your Timetable");
		var teacherID = session.get("teacherID");
		if (teacherID == null) throw "While you logged in okay, you don't appear to be in the database as a teacher.  Please contact IT.";
		var teacher = Teacher.manager.get(teacherID);
		var dateBlocks = new Hash();
		view.assignObject("teacher", teacher);
		Interview.manager.setOrderBy("timeslotID");
		var interviews = Lambda.array(teacher.interviews);
		interviews.sort(function (a,b) {
			return Std.int(a.timeslot.startTime.getTime() - b.timeslot.startTime.getTime());
		});
		for (interview in interviews)
		{
			var category = (interview.studentID != null) ? interview.student.category.name : "Unavailable";
			var date = interview.timeslot.startTime.format("%A %d %B");
			var dateBlock:Tpl;
			if(dateBlocks.exists(date) == false) 
			{
				dateBlock = view.newLoop("category");
				dateBlocks.set(date, dateBlock);
			}
			else 
			{
				dateBlock = dateBlocks.get(date);
			}
			dateBlock.assign("category", category);
			dateBlock.assign("date", date);
			var loop = dateBlock.newLoop("interview");
			var i_schoolClass = (interview.classID != null) ? interview.schoolClass : null;
			var i_schoolClassCategory = (interview.classID != null) ? interview.schoolClass.category : null;
			var i_parent = (interview.parentID != null) ? interview.parent : null;
			var i_student = (interview.studentID != null) ? interview.student : null;
			loop.assignObject("class", i_schoolClass);
			loop.assignObject("classCategory", i_schoolClassCategory);
			loop.assignObject("parent", i_parent);
			loop.assignObject("student", i_student);
			var startTime = interview.timeslot.startTime.format("%I:%M");
			var endTime = interview.timeslot.endTime.format("%I:%M");
			loop.assign("startTime", startTime);
			loop.assign("endTime", endTime);
		}
		printTemplate();
	}
	public static var aliases = [];
}
