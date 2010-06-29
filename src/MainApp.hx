import hxbase.Dispatcher;
import AppConfig;
import hxbase.BaseDBModel;

class MainApp
{
	public static var startTime:Float = php.Sys.time();
	
	public static function main()
	{
		php.Lib.print('<pre>');
		
		trace("Call the dispatcher to figure out what to do...");
		
		var params:Hash<Dynamic> = php.Web.getParams();
		var request:String = params.get("request");
		Dispatcher.dispatch(request);
		
		php.Lib.print('</pre>');
		printStats();
	}
	
	public static function printStats()
	{
		php.Lib.print('<pre>');
		#if php
		var memory:Int = untyped __call__("memory_get_peak_usage");
		memory = Std.int(memory / 1000);
		trace ("Memory usage: " + memory + "kb");
		#end
		var executionTime:Float = php.Sys.time() - startTime;
		trace ("CPU Time: " + executionTime);
		php.Lib.print('</pre>');
	}
} 
