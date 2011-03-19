package controllers;
import basehx.BaseController;

class TeacherController extends BaseController 
{
	public function new(args) 
	{
		super();
	}
	
	override public function getDefaultAction() 
	{
		return this.viewTimetable;
	}
	
	public function checkPermissions() 
	{
		try 
		{
			AppLogin.checkLoggedIn();
			userType = AppLogin.session.get("userType");
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
		teacherID = AppLogin.session.get("teacherID");
		teacher = Teacher.manager.get(teacherID);
		categoryBlocks = new Hash();
		view.assignObject("teacher", teacher);
		Interview.manager.setOrderBy("timeslotID");
		interviews = Lambda.harray(teacher.getter_interviews());
	/*		interviews.sort(array(new _hx_lambda(array("categoryBlocks": &categoryBlocks, "interviews": &interviews, "teacher": &teacher, "teacherID": &teacherID), null, array('a','b'), "{
			return intval(\a.get_timeslot().startTime.getTime() - \b.get_timeslot().startTime.getTime());
		}"), 'execute2'));*/
		throw "fix this";
		{
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
				loop.assignObject("parent", interview.get_parent());
				loop.assignObject("student", interview.get_student());
				startTime = DateTools.format(interview.get_timeslot().startTime, "%I:%M");
				endTime = DateTools.format(interview.get_timeslot().getter_endTime(), "%I:%M");
				loop.assign("startTime", startTime);
				loop.assign("endTime", endTime);
				unset(startTime,loop,interview,endTime,date,category,cat);
			}
		}
		printTemplate();
	}
	public static var aliases = [];
}
