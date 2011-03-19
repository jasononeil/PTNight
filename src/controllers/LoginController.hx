package controllers;
import basehx.BaseController;

class LoginController extends BaseController 
{
	public function new(args) 
	{
		super(args);
		//if (!session) { die("Here too"); }
	}
	
	override public function getDefaultAction() 
	{
		return (isset(login) ? login: array(this, "login"));
	}
	
	public function login() 
	{
		message = null;
		loadTemplate();
		template.assign("pageTitle", "Parent Teacher Night");
		userType = null;
		try 
		{
			session.check(); 
		}
		catch (e:Dynamic) 
		{
			// do nothing
			//echo "no session";
		}
		if(session.get("userType") != null) {
			userType = session.get("userType");
			//echo "userType is userType";
		}
		else 
		{
			if(params.exists("username") && params.exists("password")) 
			{
				//echo "we have params";
				u = params.get("username");
				p = params.get("password");
				try {
					applogin = new AppLogin();
					applogin.login(u,p);
					session.set("username",u);
					session.set("password",p);
					yearAtEndOfUsername = ~/[0-9]{4}$/;
					if(yearAtEndOfUsername.match(u)) 
					{
						userType = "parent";
						student = Student.manager.search({username: u}).first();
						if(student != null) 
						{
							session.set("studentID", student.id);
						}
					}
					else 
					{
						userType = "teacher";
						teacher = Teacher.manager.search({username: u}).first();
						if(teacher != null) 
						{
							session.set("teacherID", teacher.id);
						}
						if(u == "jason" || u == "joneil" || u == "dmckinnon" || u == "gmiddleton") 
						{
							userType = "admin";
						}
					}
					session.set("userType", userType);
					//echo "Died on userType " + session.get("userType") + session.get("studentID");
				}
				catch(e:ErrorObject) 
				{
					view.setSwitch("message", true, null).assign("explanation", e.explanation, null).assign("suggestion", e.suggestion);
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
