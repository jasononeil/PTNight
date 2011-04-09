/*
Where I'm up to:

- imports a template from a file, changes it into an XML object
- cycles through the XML tree, finding important types and ignoring others
- finds all occurances of {varname}

Next

- uncomment the string outputs in the function
- after the for(everything but blocks) loop, go through and
- do a for(only the blocks, and only at this level) loop that
     - captures the OuterHTML, sends it through the function
     - Deletes the entire block and replaces it with the innerHTML
       (essentially removing the container element)
- implement the class stuff from pseudocode, including
     - varName array
     - varValue array
     - some sort of block mechanism
     - assign()
     - newLoop()
     - include()
- change the digThroughXML function so that all the "replace variable" and "new block" actions etc. are in seperate functions
- make the assign function work
- make the digThroughXML function actually replace the variables used in assign();
*/

/***********************************************************************
   Class: HxTpl
   Package: jasononeil.tpl   
   
   A very simple templating class that processes live using any string, 
   rather than requiring pre-processing.  This would allow you to load 
   templates from a database, a file, or even user input.
***********************************************************************/


package basehx.tpl;

import php.Lib;
import php.io.File;
import haxe.xml.Fast;
import StringTools;

import basehx.xml.XmlNode;
import basehx.xml.XmlList;
using Lambda;

class HxTpl extends basehx.tpl.Tpl
{
	private var templateXML:XmlNode;
	private var templateString:String;
	
	/* This is used when processing to know where we are in the heirarchy */
	private var currentTplBlock:Tpl;
	
	/***********************************************************************
	Constructor: new
	Initializes the template object.
	***********************************************************************/
	/**
	 * Constructor. 
	 * 
	 * <p>Initializes the template object</p>
	 */
	
	
	public function new()
	{
		super();
		currentTplBlock = this;
		assignObject('this', { URL : php.Web.getURI() });
	}
	
	/***********************************************************************
	Function: loadTemplateFromString
	************************************************************************
	
	Sets the template to be used for this object, based on a string.  
	This could be based off an included file, a template from a database, 
	a block of an existing template, or user inputted data.  Any valid XML will do.
	
	Parameters:
		tpl:String - The string to use as a template. 
		
	Returns:
		(Bool) Should: True if the template is a valid XML String, 
		  False otherwise.  Reality: Always returns true.
		
	***********************************************************************/
	
	public function loadTemplateFromString(tpl:String):Tpl
	{
		templateString = tpl;
		try {
			templateXML = new XmlNode(templateString);
		} catch (e:Dynamic)
		{
			templateString = "<h1>Error Processing Template</h1>";
 			templateString += "<p>We're sorry, the template you're using ";
 			templateString += "appears to be corrupt.  Here's the error:</p>";
 			templateString += "<pre>" + e + "</pre>";
 			templateXML = new XmlNode(templateString);
		}
		
		return this;
	}
	
	/***********************************************************************
	Function: loadTemplateFromFile
	************************************************************************
	
	Loads a template for this object from a file.  
	
	Parameters:
		url:String - The url or path to the root directory for this filesystem
		
	Returns:
		(Bool) Should: True if the template is valid, False otherwise.  
		  Reality: Always returns true.
		
	***********************************************************************/
	
	public function loadTemplateFromFile(url:String):Tpl
	{
		var templateString:String;
		try {
			templateString = php.io.File.getContent(url);
		} catch (e:Dynamic)
		{
			templateString = "<h1>Error Loading Template</h1>";
 			templateString += "<p>We're sorry, the template we're supposed to use ";
 			templateString += "couldn't be found.  Here's the error:</p>";
 			templateString += "<pre>" + e + "</pre>";
		}
		loadTemplateFromString(templateString);
		
		return this;
	}
	
	/***********************************************************************
	Function: getOutput
	************************************************************************
	Processes the template and returns a string with the full XML output.
	
	Please note this does not actually print the template to the browser etc. 
	It is up to the class calling the template to take this output and do that.
		
	Returns:
		(String) Full XML Output, the end product of the template
	***********************************************************************/
	
	public function toString()
	{
		process(templateXML);
		return templateXML.outerXML;
	}
	
	
	//
	// This function will probably replace exportTemplate directly (wait... this is recursive.  exportTemplate should be available from outside)
	// Currently it cycles through all the elements recursively, and stops if it gets to a block level element
	//
	private function process(element:XmlNode)  // later add attribute tplVariables
	{
		// if this is an element, check the attributes
		if (element.isElement)
		{
			processAttributes(element);
		}
		
		// Go through every item in the XML, elements, PCData, Comments, all of it
		for (child in element)
		{
			if (["hxVar", "hxSwitch", "hxLoop", "hxInclude"].has(child.name))
			{
				if (child.name == "hxVar")
				{
					processHxVar(child);
				}
				else if (child.name == "hxSwitch")
				{
					processHxSwitch(child);
				}
				else if (child.name == "hxLoop")
				{
					processHxLoop(child);
				}
				else if (child.name == "hxInclude")
				{
					processHxInclude(child);
				}
			}
			else if (child.isElement || child.isDocument)
			{
				process(child);
			}
			else
			{
				child.value = processText(child.value);
			}
		}
	}
	
	private function processText(str_in:String):String
	{
		var string = str_in;
		var templateVariable = ~/{([A-Za-z0-9]+[.A-Za-z0-9:]*)}/;
		while (templateVariable.match(string))
		{
			var varName = templateVariable.matched(1);
			var varValue = currentTplBlock.getAssignedVariable(varName);
			string = templateVariable.replace(string,varValue);
		}
		return string;
	}
	
	private function processAttributes(n:XmlNode)
	{
		for (attName in n.getAttList())
		{
			var oldValue:String = n.getAtt(attName);
			if (oldValue.indexOf("{") != -1)
			{
				n.setAtt(attName, processText(oldValue));
			}
		}
	}
	
	private function processHxVar(child:XmlNode)
	{
		var varName:String;
		var varValue:String;
		
		varName = child.getAtt("name");
		varValue = currentTplBlock.getAssignedVariable(varName);
		if(varValue != "")
		{
			child.outerXML = varValue;
		}
		else
		{
			child.replaceWithChildren();
		}
	}
	
	private function processHxSwitch(child:XmlNode)
	{
		var showing = false;
		var name = "";
		
		if (child.hasAtt("name"))
		{
			name = child.getAtt("name");
			if (currentTplBlock.switches.exists(name) && currentTplBlock.switches.get(name) == true)
			{
				showing = true;
			}
			
			if (showing)
			{
				// change the currentTplBlock variable while we process the children
				currentTplBlock = currentTplBlock.getBlock(child.getAtt("name"));
				
				process(child);
				
				// done, change it back
				currentTplBlock = currentTplBlock.parent;
				
				child.replaceWithChildren();
			}
			else
			{
				child.parent.removeChild(child);
			}
		}
	}
	
	private function processHxLoop(elm:XmlNode)
	{
		var contents = elm.innerXML;
		var name = elm.getAtt("name");
		
		if (currentTplBlock.loopCount.exists(name))
		{
			var count:Int = currentTplBlock.loopCount.get(name);
			if (count > 0)
			{
				var allLoopItems = new StringBuf();
				var loopName = elm.getAtt("name");
				for (i in 1...count+1)
				{
					// create child xml
					var child = new XmlNode(contents);
					
					// attach, place it just before the current elm
					//elm.parent.addChildBefore(child, elm);
					
					// go a level deeper (like in the include)
					var blockName = loopName + ":" + i;
					currentTplBlock = currentTplBlock.getBlock(blockName);
					
					//
					// we have a child
					// this is in fact a document node, because we made it from a text fragment
					// if we add this using addChildBefore, the children (the actual elements we care about, and whitespace) 
					// are moved from this document tree, into the other document tree.
					// so they are now no longer in child, but in elm.document.
					// so when we try to read child, it's empty.
					// so when we try to process child, it's empty.
					//
					// so rather than add "child" and process "child", let's add and process the actual child nodes that we care about
					for (childNode in child)
					{
						elm.parent.addChildBefore(childNode, elm);
						process(childNode);
					
					}
					
					// come a level up
					currentTplBlock = currentTplBlock.parent;
					
					// do this, and then cancel out the processing / setOuterXMLing below
				}
				elm.parent.removeChild(elm);
				
			}
		}
		else
		{
			elm.parent.removeChild(elm);
		}
		
	}
	
	private function processHxInclude(elm:XmlNode)
	{
		var name:String = elm.getAtt("name");
		var url = currentTplBlock.getIncludeURL(name);
		if (url == "" && elm.hasAtt("url"))
		{
			url = elm.getAtt("url");
		}
		if (url != "")
		{
			var includedFile:String;
			try {
				includedFile = php.io.File.getContent(url);
			} catch (e:Dynamic)
			{
				includedFile = "<h1>Error Loading Template</h1>";
				includedFile += "<p>We're sorry, the template we're supposed to use ";
				includedFile += "couldn't be found.  Here's the error:</p>";
				includedFile += "<pre>" + e + "</pre>";
			}
			elm.innerXML = includedFile;
			
			// change the currentTplBlock variable while we process the children
			currentTplBlock = currentTplBlock.getBlock(elm.getAtt("name"));
			
			process(elm);
			
			// done, change it back
			currentTplBlock = currentTplBlock.parent;
			
			elm.replaceWithChildren();
		}
		else
		{
			elm.parent.removeChild(elm);
		}
	}
	
}
