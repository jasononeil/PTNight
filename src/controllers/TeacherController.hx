package controllers;
import basehx.BaseController;
import basehx.tpl.HxTpl;
import basehx.util.Error;
import basehx.App;
import AppLogin;
import models.Teacher;
import models.Interview;

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
			AppLogin.checkLoggedIn();
			var userType:String = AppLogin.session.get("userType");
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
		var teacherID = AppLogin.session.get("teacherID");
		var teacher = Teacher.manager.get(teacherID);
		var categoryBlocks = new Hash();
		view.assignObject("teacher", teacher);
		Interview.manager.setOrderBy("timeslotID");
		var interviews = Lambda.array(teacher.interviews);
	/*		interviews.sort(array(new _hx_lambda(array("categoryBlocks": &categoryBlocks, "interviews": &interviews, "teacher": &teacher, "teacherID": &teacherID), null, array('a','b'), "{
			return intval(\a.timeslot.startTime.getTime() - \b.timeslot.startTime.getTime());
		}"), 'execute2'));*/
		throw "fix this";
		{
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
		}
		printTemplate();
	}
	public static var aliases = [];
}
