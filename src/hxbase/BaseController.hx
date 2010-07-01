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
	//private static var defaultAction = doNothing;
	
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
		var thisClass = Type.getClass(this);
		var fields:Array<String> = Type.getInstanceFields(thisClass);
		for (field in fields)
		{
			if (Reflect.isFunction(Reflect.field(this,field)))
			{
				if (field != "hprint" && field != "toString" && field != "clearOutput")
				{
					actions.set(field.toLowerCase(), Reflect.field(this,field));
				}
			}
		}
		
		
		// If first part is one of our actions, then load that action
		var firstArg = args[0];
		if (actions.exists(firstArg))
		{
			// how can we make sure the arguments are of correct type?
			// I think HaxIgniter might do this so take a look at that?
			args.shift();
			Reflect.callMethod(this,actions.get(firstArg),args);
		}
		else
		{
			// use the default one...
			this.defaultAction(args);
		}
	}
	
	public function defaultAction(args:Array<String>, ?action:String)
	{
		trace ('default action is: ' + action);
		action = action.toLowerCase();
		if (actions.exists(action))
		{
			trace ('and it exists');
			Reflect.callMethod(this,actions.get(action),args);
		}
	}
	
	public function doNothing(myString:String):Void
	{
		trace("Value: " + myString);
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
