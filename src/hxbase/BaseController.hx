package hxbase;
import hxbase.tpl.HxTpl;
import hxbase.Dispatcher;

/**
Your controllers should inherit from this base class.
*/
class BaseController
{
	/** Can this controller be cached?  (Read only)
	In your Controller Class definition, set this to true or false */
	public var isCacheable(default,null):Bool;
	
	private var output:String;
	
	/** Create a static array "aliases" with any alternate URL requests
	that you want to point to this controller.  */
	static public var aliases = [];
	
	/** The new() constructor will probably be called by the Dispatcher
	if it decides this is the Controller to use.  The constructor should
	take the arguments, decide on which "action" (method) should be called,
	and call it.  */
	public function new(args:Array<String>)
	{
		hxbase.Log.error("This is where you're up to");
		// NEXT:
		// Have code here to pick the appropriate action
		// This will use REFLECT to see what's available
		// And read a variable to see what the default is
		// Each action should be:
		//	function myAction(args:Array<String>):Void
		//  and sets the "output" string.
		// ALSO: Decide where template codes
	}
	
	/** The toString() method should give the output from the various
	actions we've called.  This means elsewhere you'll be able to use:
	<pre>	myController = new MyController(args);
	php.Lib.print(myController);</pre>
	to print all the output.*/
	public function toString():String
	{
		return output;
	}
	
	/** In your methods, use print() to write to the output */
	private function print(str)
	{
		output = output + Std.string(str);
	}
	
	/** In your methods, if you want to clear the output, use this */
	private function clearOutput()
	{
		output = "";
	}
}
