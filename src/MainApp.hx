import hxbase.Dispatcher;
import hxbase.DbControl;
import AppConfig;

import models.User;
import models.TodoItem;

class MainApp
{
	public static var startTime:Float = php.Sys.time();
	
	public static function main()
	{
		php.Lib.print('<pre>');
		
		trace("Call the dispatcher to figure out what to do...");
		
		// Pass control off to the dispatcher, 
		// (which will find the appropriate Controller)
		var request:String = php.Web.getParams().get("request");
		Dispatcher.dispatch(request);
		
		//testing();
		
		php.Lib.print('</pre>');
		printStats();
	}
	
	public static function testing()
	{
		// Connect
		DbControl.connect();
		trace (DbControl.cnx);
		
		// Add a user
		var u = User.manager.search({username:'jason'}).first();
		if (u == null)
		{
			u = new User();
			u.username = "jason";
			u.password = haxe.Md5.encode("password");
			u.insert();
			trace ('Inserted, id is ' + u.id);
		}
		else
		{
			trace ('User already there.  Id is ' + u.id);
		}
		
		// Add another todo item to the pile
		var count = TodoItem.manager.count();
		var t = new TodoItem();
		t.userId = u.id; // Fails is it's not valid. Hooray!
		t.subject = "Todo number " + count;
		t.text = "You better get moving before number " + (count + 1) + " comes along";
		t.priority = 5;
		t.completion = Std.random(100) / 100;
		t.insert();
		
		// And print the list.
		var todoList = TodoItem.manager.all();
		for (item in todoList)
		{
			trace ("ITEM: " + item.subject + " " + item.user.username);
		}
		
		// And just to check the function I'm using for hasMany is working
		trace("Number of tasks for " + u.username + ": " + u.todoList.length);
		for (item in u.todoList)
		{
			trace ("ITEM: " + item.subject + " " + item.user.username);
		}
		
		// End the connection
		DbControl.close();
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
