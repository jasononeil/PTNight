package basehx.tpl;
using Lambda;

class Tpl 
{
	public var parent:Tpl;
	public var template:Tpl;
	
	private var assignedVariables:Hash<String>;
	private var switches:Hash<Bool>;
	private var loopCount:Hash<Int>;
	private var includeURLs:Hash<String>;
	
	//
	// Switches, Loops and Includes all will occupy the same namespace
	// And so they are all kept in this same hash object.
	//
	// The name of the switches and includes remain the same.
	// The name of the loop becomes "loopName:1", "loopName:2" etc.
	//
	// Also worth noting, these blocks can be declared willy nilly, without
	// having to track down what data the template block contains, or even if
	// it exists.
	// 
	private var blocks:Hash<Tpl>;
	
	public function new(?template_in:Tpl = null, ?parent_in:Tpl = null)
	{
		template = template_in;
		parent = parent_in;
		assignedVariables = new Hash();
		blocks = new Hash();
		switches = new Hash();
		loopCount = new Hash();
		includeURLs = new Hash();
	}
	
	/***********************************************************************
	Function: assign
	************************************************************************
	Assign a simple variable name and value.
	An example might be helpful.  If we call
	
	eg - 	my_tpl.assign("title", "Cheesecakes");
	
	Then in the template, any reference to either
	
	eg - 	{title} OR <hxVar name="title">Default Title</hxVar>
	
	Will be replaced with "Cheesecakes".  Simple, no?  
	
	Also, because this object returns itself, statements can be 
	chained together.  
	
	eg -	my_tpl.assign("page", "Five Fruits").assign("url","fruit.html");
	
	Parameters:
		name:String - The name of the template variable we are assigning.
		  You can use Uppercase and Lowercase letters, numbers and 
		  decimal points.
		
		value:String - The text to replace it with.  
		
		useHTMLEncode:Bool - Do we encode this string for HTML?  
		  If *true*, all & < > etc. will be turned into HTML entities.
		  Defaults is *true*
		
	Returns:
		(HxTpl) Returns this template object, so we can chain together 
		assign statements.
	***********************************************************************/
	
	public function assign(name:String, value:Dynamic, ?useHTMLEncode:Bool = true):Tpl
	{
		value = Std.string(value);
		
		// do we add the HTML escaping?
		value = (useHTMLEncode) ? StringTools.htmlEscape(value) : value;
		
		assignedVariables.set(name, value);
		return this;
	}
	
	/***********************************************************************
	Function: assignObject
	************************************************************************
	Assign a simple object containing name value pairs to a template variable.
	An example might be helpful.  If we call
	
	> tpl.assignObject('page', 
	>	{
	>		title		:'New Website',
	>		url		:'http://google.com/myhouse.html'
	>	});
	
	Then they will correspond with atemplate like this -
	
	> title: {page.title}
	> url:   {page.url}
	
	You can also go multiple levels deep.
	
	> tpl.assignObject('page', 
	>	{
	>		url		:'http://google.com/myhouse.html',
	>		urlParts	:
	>				{
	>				protocol : 'http://',
	>				domain : 'google.com',
	>				filename : 'myhouse',
	>				extension : '.html'
	>				}
	>	});
	
	And then access that with
	
	> {page.urlParts.protocol}, {page.urlParts.domain} etc.
	
	As with assign(), assignObject() returns the template object, so you can
	chain together assign commands.
	
	Parameters:
		name:String - The name of the template variable we are assigning.
		  You can use Uppercase and Lowercase letters, numbers and 
		  decimal points.
		
		obj:Dynamic - An object consisting of name:value pairs, possibly
		  multiple levels deep. 
		
		useHTMLEncode:Bool - Do we encode this string for HTML?  
		  If *true*, all & < > etc. will be turned into HTML entities.
		  Defaults is *true*
		
	Returns:
		(HxTpl) Returns this template object, so we can chain together 
		assign statements.
	***********************************************************************/
	
	public function assignObject(name:String, obj:Dynamic, ?useHTMLEncode:Bool = true):Tpl
	{
		// for i=propertyName in obj
		for (propName in Reflect.fields(obj))
		{
			var propValue = Reflect.field(obj, propName);
			
			// For the moment we'll just check for strings and objects containing strings
			// In the future it could be useful to take any object and see if we can't convert it to a string
			
			if (Reflect.isObject(propValue) && !Std.is(propValue, String))
			{
				// this is an object, possibly containing more name/value pairs.
				// Recursively call this function to search through all children
				if (~/__.+__/.match(propName) == false)
				{
					assignObject(name + "." + propName, propValue, useHTMLEncode);
				}
			}
			else
			{
				// if it's not a string,make it one!
				if (!Std.is(propValue, String)) 
					propValue = Std.string(propValue);
				
				// we have a name and a value to assign
				this.assign(name + "." + propName, propValue, useHTMLEncode);
			}
		}
		
		return this;
	}
	
	/***********************************************************************
	Function: setSwitch
	************************************************************************
	
	Define whether a switch will be visible or not.  This returns the block
	inside the switch, so you can assign variables to that block.
	
	Example:
	
	We'll start with this template.
	
	> <h1>Result:</h1>
	> 
	> <p>{message}</p>
	>
	> <hxSwitch name="error">
	>    <p><b>Error:</b> {message}</p>
	> </hxSwitch>
	>
	> <hxSwitch name="theHiddenSection">
	>    The secret of life is something about the number 42
	> </hxSwitch>
	>
	
	Now we run this script.
	
	> var tpl:HxTpl;	// pretend we've loaded the template above
	> tpl.assign("message", "Notice that this message is only affecting the current block, not the block underneath");
	> 
	> var errBlock:HxTpl;
	> errBlock = tpl.setSwitch("error", true);
	> errBlock.assign("message", "The problem is that you're too cool for school.");
	>
	> // if we uncommented the next line, it would show "theHiddenSection"
	> // tpl.setSwitch("theHiddenSection", true);
	
	And it produces this output
	
	> <h1>Result:</h1>
	> 
	> <p>Notice that this message is only affecting the current block, not the block underneath</p>
	>
	> 
	>    <p><b>Error:</b> The problem is that you're too cool for school.</p>
	> 
	
	Parameters:
		name:String - The name of the template switch that we're 
		  looking for.
		
		value:Bool - True to show the switch, false to hide it.  
		
	Returns:
		(HxTpl) Returns a template object of the switch template block, 
		so we can assign variables specifically for the switch.
	***********************************************************************/
	
	public function setSwitch(name:String, value:Bool, ?parent:Tpl):Tpl
	{
		// set the value in the hash
		switches.set(name, value);
		
		return getBlock(name, parent);
	}
	
	/***********************************************************************
	Function: newLoop
	************************************************************************
	
	Create a new instance of a template loop (hxLoop).  No examples yet 
	sorry, though it should work mostly as you'd expect.
	
	Parameters:
		name:String - The name of the template loop that we're 
		  looking for.
		
	Returns:
		(HxTpl) Returns a template object of the loop template block, 
		so we can assign variables specifically for this instance
		of the loop.
	***********************************************************************/
	
	public function newLoop(name:String, ?parent:Tpl = null):Tpl
	{
		// get the number of loops so far;
		var i:Int;
		i = 0;
		if (loopCount.exists(name)) 
			{ i = loopCount.get(name); }
		
		// increment the loop count
		i++;
		loopCount.set(name, i);
		
		// create a HxTpl object if one doesn't exist, or get an existing one
		// return it
		return getBlock(name + ":" + i, parent);
	}
	
	/***********************************************************************
	Function: useListInLoop
	************************************************************************
	
	This is a shortcut to get a list of objects to each have their own 
	template block.
	
	It essentially is just running this code:
	
	> for (obj in list)
	> {
	> 	loopTpl = this.newLoop(loopName);
	> 	loopTpl.assignObject(varName, obj, useHTMLEncode);
	> }
	
	Parameters:
		list:List - A list of objects containing variables to be 
		            assigned.  A new loop will be created for every 
		            item in the list.
		loopName:String - The name of the template loop (hxLoop) to use.
		varName:String - The name of the template variable that the 
		                 object should be assigned to.
		useHTMLEncode:Bool - Use HTML Encoding on the data?
		
	Returns:
		(nothing yet)
	***********************************************************************/
	
	public function useListInLoop(list:List<Dynamic>, loopName:String, varName:String, ?useHTMLEncode:Bool, ?parent:Tpl):Tpl
	{
		var loopTpl:Tpl;
		
		for (obj in list)
		{
			loopTpl = this.newLoop(loopName, parent);
			loopTpl.assignObject(varName, obj, useHTMLEncode);
		}
		
		return this;
	}
	
	//
	// need to make it so that the URL is relative to the script
	//
	public function include(name:String, url:String, ?parent:Tpl):Tpl
	{
		// Set the URL in our hash of include URLs
		includeURLs.set(name, url);
		trace (name + " " + url + " count is " + includeURLs.count());
		
		// create a HxTpl object if one doesn't exist, or get an existing one
		// return it
		return getBlock(name, parent);
	}
	
	public function getBlock(name:String, ?parent:Tpl):Tpl
	{
		// create a HxTpl object if one doesn't exist, or get an existing one
		var newBlock:Tpl;
		
		if (parent == null) { parent = this; }
		
		if (blocks.exists(name))
		{
			trace ("loading an existing block " + name);
			// get the existing block
			newBlock = blocks.get(name);
		}
		else
		{
			trace ("creating a new block " + name);
			// create a new block
			newBlock = new Tpl(this, parent);
			
			// Save it for future reference
			blocks.set(name, newBlock);
		}
		
		// return it
		return newBlock;
	}
	
	
	
	public function getAssignedVariable(name:String):String
	{
		var value = "";
		if (assignedVariables.exists(name))
		{
			trace ("Value in first");
			value = assignedVariables.get(name);
		}
		else if (parent != null)
		{
			value = parent.getAssignedVariable(name);
			trace ("Value in a parent");
		}
		else trace ('here');
		return value;
	}
	
	public function getSwitch(name:String):Bool
	{
		var value = false;
		if (switches.exists(name))
		{
			value = switches.get(name);
		}
		else if (parent != null)
		{
			value = parent.getSwitch(name);
		}
		return value;
	}
	
	public function getLoopCount(name:String):Int
	{
		var count = 0;
		if (loopCount.exists(name))
		{
			count = loopCount.get(name);
		}
		else if (parent != null)
		{
			count = parent.getLoopCount(name);
		}
		return count;
	}
	
	public function getIncludeURL(name:String):String
	{
		var url = "";
		trace ("searching for " + name + " from this many entries " + includeURLs.count());
		if (includeURLs.exists(name))
		{
			url = includeURLs.get(name);
			trace ("in here?");
		}
		else if (parent != null)
		{
			url = parent.getIncludeURL(name);
		}
		return url;
	}
	
	
}
