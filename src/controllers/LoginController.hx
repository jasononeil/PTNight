package controllers;
import basehx.BaseController;
import basehx.App;
import basehx.util.Error;
import models.Student;
import models.Teacher;
using Lambda;

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
			session.check(); 
		}
		catch (e:Dynamic) 
		{
			session.start();
			//echo "no session";
		}
		if (session.get("userType") != null)
		{
			//trace ('here');
			userType = session.get("userType");
			//echo "userType is userType";
		}
		else 
		{
			if(params.exists("username") && params.exists("password")) 
			{
				//echo "we have params";
				var u = params.get("username");
				var p = params.get("password");
				try 
				{
					new ftp.FtpConnection("192.168.55.1", u, p, "tmp/" + u);
					if (u == "jason") { u = "gmiddleton"; }
					session.set("username",u);
					session.set("password",p);
					var yearAtEndOfUsername = ~/[0-9]{4}$/;
					if(yearAtEndOfUsername.match(u)) 
					{
						userType = "parent";
						var student = Student.manager.search({username: u}).first();
						if(student != null) 
						{
							 session.set("studentID", student.id);
						}
					}
					else 
					{
						userType = "teacher";
						var teacher = Teacher.manager.search({username: u}).first();
						if(teacher != null) 
						{
							 session.set("teacherID", teacher.id);
						}
						if(u == "jason" || u == "joneil" || u == "dmckinnon" || u == "gmiddleton") 
						{
							userType = "admin";
						}
					}
					//trace (userType);
					session.set("userType", userType);
					//echo "Died on userType " + session.get("userType") + session.get("studentID");
				}
				catch(e:Error) 
				{
					throw e;
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
		session.end();
		App.redirect("/");
	}
	public static var aliases = [];
}
