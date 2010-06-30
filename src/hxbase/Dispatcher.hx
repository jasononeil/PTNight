package hxbase;

/**
The Dispatcher class is responsible for deciding which
Controller class is being requested and which action 
should be executed.

This class is called on most page requests.  
*/
class Dispatcher
{
	/** Takes a request query (usually from the URL) decides
	which controller class to use, passing any extra parameters
	to it as necessary. */
	public static function dispatch(request:String)
	{
		// Get the various parts of the input
		var parts:Array<String> = getRequestParts(request);
		
		// Get the name of the first part
		var firstPart:String = parts[0];
		
		// See if mysite is a controller
		trace ("Seeing if " + firstPart + " is a controller");
		var controllerClass = Type.resolveClass(firstPart);
		if (controllerClass != null)
		{
			// We have the Controller class, so git rid of that
			// from our list of parameters.
			parts.shift();
		}
		else
		{
			// What we had was not a Controller class, so load the
			// default one (defined in AppConfig).  And leave all 
			// parameters in tact to pass to this class.
			controllerClass = AppConfig.defaultController;
		}
		
		// Now pass control to whichever controller class we have
		// (first check it has a 
		trace ("We're going to load " + controllerClass);
		Type.createInstance(controllerClass, parts);
		
	}
	
	private static function getRequestParts(request:String):Array<String>
	{
		// if there's a trailing slash, get rid of it, we don't need it
		if (request.charAt(request.length - 1) == "/")
		{
			request = request.substr(0, request.length - 1);
		}
		
		return request.split('/');
	}
}
