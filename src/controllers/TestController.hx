package controllers;

class TestController extends hxbase.BaseController
{
	static public var aliases = ["t","page"];
	override function defaultAction(args, ?action = null) 
		{ super.defaultAction(args,"myWeirdDefault"); }
	
	public function testAction()
	{
		trace ('hey');
	}
	
	public function myWeirdDefault(str:String)
	{
		trace ("Default on Test Controller: " + str);
	}
}
