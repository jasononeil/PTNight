package hxbase;

import php.Web;

/**
The Dispatcher class is responsible for deciding which
Controller class is being requested and which action 
should be executed.

This class is called on most page requests.  
*/
class Dispatcher
{
	
	public static function dispatch()
	{
		var uri:String = php.Web.getURI();
		trace (uri);
	}
	
}
