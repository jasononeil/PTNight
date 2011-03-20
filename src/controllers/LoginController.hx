package controllers;
import basehx.BaseController;
import basehx.App;
import basehx.util.Error;
import models.Student;
import models.Teacher;
import AppLogin;

class LoginController extends BaseController 
{
	public function new(args) 
	{
		super(args);
		//if (!session) { die("Here too"); }
	}
	
	override public function getDefaultAction() 
	{
		return this.login;
	}
	
	public function login() 
	{
		var message = null;
		loadTemplate();
		template.assign("pageTitle", "Parent Teacher Night");
		var userType:String = null;
		try 
		{
			 AppLogin.session.check(); 
		}
		catch (e:Dynamic) 
		{
			// do nothing
			//echo "no session";
		}
		if(session.get("userType") != null) {
			userType = AppLogin.session.get("userType");
			//echo "userType is userType";
		}
		else 
		{
			if(params.exists("username") && params.exists("password")) 
			{
				//echo "we have params";
				var u = params.get("username");
				var p = params.get("password");
				try {
					AppLogin.login(u,p);
					session.set("username",u);
					session.set("password",p);
					var yearAtEndOfUsername = ~/[0-9]{4}$/;
					if(yearAtEndOfUsername.match(u)) 
					{
						userType = "parent";
						var student = Student.manager.search({username: u}).first();
						if(student != null) 
						{
							 AppLogin.session.set("studentID", student.id);
						}
					}
					else 
					{
						userType = "teacher";
						var teacher = Teacher.manager.search({username: u}).first();
						if(teacher != null) 
						{
							 AppLogin.session.set("teacherID", teacher.id);
						}
						if(u == "jason" || u == "joneil" || u == "dmckinnon" || u == "gmiddleton") 
						{
							userType = "admin";
						}
					}
					 AppLogin.session.set("userType", userType);
					//echo "Died on userType " + AppLogin.session.get("userType") + AppLogin.session.get("studentID");
				}
				catch(e:Error) 
				{
					view.setSwitch("message", true).assign("explanation", e.explanation).assign("suggestion", e.suggestion);
				}
			}
		}
		if(userType != null) 
		{
			App.redirect("/" + userType + "/");
		}
		printTemplate();
	}

	public function logout() 
	{
		 AppLogin.session.end();
		App.redirect("/");
	}
	public static var aliases = [];
}
