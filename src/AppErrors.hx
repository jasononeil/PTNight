import basehx.util.Error;
class AppErrors
{
	public static function registerErrorMessages() 
	{
		Error.registerErrorType("SESSION.NO_SESSION", "Please sign in", "We won't be able to get started until you've signed in.", "Please sign in with your child's student username and password.");
		Error.registerErrorType("SESSION.LOGGED_OUT", "See you next time!", "You've signed out successfully.", "See you at the Parent Teacher Night!");
		Error.registerErrorType("SESSION.TIMEOUT", "I thought you were gone!", "Sorry, after 1 hour we sign you out automatically, to keep your account safe in case you're gone.", "You'll have to sign in again.  Make sure you're quick!");
		Error.registerErrorType("FTP.BAD_LOGIN", "Try again...", "Your username or password seems to be incorrect.");
		Error.registerErrorType("FTP.SERVER_NOT_FOUND", "The student server seems to be down.", "We're really sorry but it looks like the student server is down at the moment.", "You might want to try again a bit later.  If there's a teacher nearby, perhaps let them know so the IT guys can get onto it.");
		Error.registerErrorType("FTP.OPERATION_FAILED", "Sorry, that didn't work.", "Whatever it was you were trying to do just failed, and we're not entirely sure why.", "Check the file or folder is not read only, try again later or ask for help.");
	}
}
