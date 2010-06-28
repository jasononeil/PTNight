package hxbase;
using StringTools;

/**
The Dispatcher class is responsible for deciding which
Controller class is being requested and which action 
should be executed.

This class is called on most page requests.  
*/
class Dispatcher
{
	
	public static function dispatch(uri:String)
	{
		trace ("URI " + uri);
		
		var request = uri.replace(AppConfig.subDir, "");
		trace ("REQUEST " + request);
	}
	
}
