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
	private var actions:Hash<String>;
	private var output:String;
	
	/** Create a static array "aliases" with any alternate URL requests
	that you want to point to this controller.  */
	static public var aliases = [];
	
	/** The default action to use if one is not given. 
	This action should usually be fine to run without any
	parameters.  */
	//private dynamic function defaultAction() {}
	
	/** The new() constructor will probably be called by the Dispatcher
	if it decides this is the Controller to use.  The constructor should
	take the arguments, decide on which "action" (method) should be called,
	and call it.  */
	public function new(args:Array<String>)
	{
		// Make sure we don't have empty arguments
		// MAKE SURE THIS HAPPENS --^
		
		//
		// This bit of code goes through all the properties of this
		// and takes out the functions that are our actions
		//
		actions = new Hash();
		var fields:Array<String> = Type.getInstanceFields(Type.getClass(this));
		for (field in fields)
		{
			if (Reflect.isFunction(Reflect.field(this,field)))
			{
				if (field != "hprint" && field != "toString" && field != "clearOutput")
				{
					actions.set(field, Reflect.field(this,field));
				}
			}
		}
		
		trace ('number of actions available: ' + Lambda.count(actions));
		
		// NEXT:
		// Have code here to pick the appropriate action
		// This will use REFLECT to see what's available
		// And read a variable to see what the default is
		// Each action should be:
		//	function myAction(args:Array<String>):Void
		//  and sets the "output" string.
		// ALSO: Decide where template codes
	}
	
	public function doNothing(args:Array<String>):Void
	{
	
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
