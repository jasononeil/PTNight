import hxbase.Dispatcher;
import hxbase.DbControl;
import AppConfig;
import hxbase.Log;
import hxbase.tpl.HxTpl;

import models.Class_join_Student;
import models.Parent;
import models.Student;
import models.Parent_join_Student;
import models.Class;
import models.Teacher;
import models.Timeslot;
import models.Interview;

class MainApp
{
	public static var startTime:Float = php.Sys.time();
	
	public static function main()
	{
		haxe.Log.trace = hxbase.Log.trace;
		trace ("FATTY");
		php.Lib.print('<pre>');
		
		// Pass control off to the dispatcher, 
		// (which will find the appropriate Controller)
		var request:String = php.Web.getParams().get("request");
		Dispatcher.dispatch(request);
		
		php.Lib.print('</pre>');
		printStats();
	}
	
	/** This allows you to set a site-wide HTML template for your App.
	You can also set a template for each controller, but if that is not
	there it will full back to this.  Should this stuff be kept in
	AppConfig instead?    */
	public static var pageTemplateFile(default,null):String;
	public static function initiatePageTemplate():HxTpl
	{
		var template = new HxTpl();
		template.loadTemplateFromFile(pageTemplateFile);
		return template;
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
		trace ("Execution Time: " + executionTime);
		php.Lib.print('</pre>');
	}
} 
