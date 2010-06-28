import hxbase.Dispatcher;
import AppConfig;

class MainApp
{
	public static function main()
	{
		php.Lib.print('<pre>');
		
		trace("Call the dispatcher to figure out what to do...");
		Dispatcher.dispatch(php.Web.getURI());
		
		php.Lib.print('</pre>');
	}
} 
