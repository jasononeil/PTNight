import basehx.util.Error;
import basehx.session.SessionHandler;
import ftp.FtpConnection;
class AppLogin 
{
	public static var session:basehx.session.SessionHandler;
	
	public static function login(username, password) 
	{
		var loginSuccessful = false;
		AppLogin.registerErrorMessages();
		initiateFTP(username, password);
	}
	
	public static function checkLoggedIn() 
	{
		try 
		{
			session.check();
		}
		catch(err:Error) 
		{
			switch(err.code) 
			{
			case "SESSION.NO_SESSION":
				throw new Error("SESSION.NOT_LOGGED_IN");
			case "SESSION.TIMEOUT":
				throw new Error("SESSION.TIMED_OUT");
			}
		}
	}
	
	public static function logout() 
	{
		session.end();
	}
	
	public static function initiateFTP(username, password) 
	{
		var server = "localhost";
		var home = "/home/students/";
		var tmpFolder = "tmp/" + username;
		try 
		{
			var ftp = new FtpConnection(server, username, password, tmpFolder);
		}
		catch(e:Error) 
		{
			switch(e.code) 
			{
				case "FTP.SERVER_NOT_FOUND":
					throw new Error("FTP.SERVER_DOWN");
				case "FTP.BAD_LOGIN":
					throw new Error("SESSION.INCORRECT_LOGIN");
			}
		}
	}
	
	static function registerErrorMessages() 
	{
		Error.registerErrorType("SESSION.NOT_LOGGED_IN", "Please sign in", "We won't be able to get started until you've signed in.", "Please sign in with your child's student username and password.");
		Error.registerErrorType("SESSION.LOGGED_OUT", "See you next time!", "You've signed out successfully.", "See you at the Parent Teacher Night!");
		Error.registerErrorType("SESSION.TIMED_OUT", "I thought you were gone!", "Sorry, after 1 hour we sign you out automatically, to keep your account safe in case you're gone.", "You'll have to sign in again.  Make sure you're quick!");
		Error.registerErrorType("SESSION.INCORRECT_LOGIN", "Try again...", "Your username or password seems to be incorrect.");
		Error.registerErrorType("FTP.SERVER_DOWN", "The student server seems to be down.", "We're really sorry but it looks like the student server is down at the moment.", "You might want to try again a bit later.  If there's a teacher nearby, perhaps let them know so the IT guys can get onto it.");
		Error.registerErrorType("FTP.OPERATION_FAILED", "Sorry, that didn't work.", "Whatever it was you were trying to do just failed, and we're not entirely sure why.", "Check the file or folder is not read only, try again later or ask for help.");
	}
}
