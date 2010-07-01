package controllers;

class TestController extends hxbase.BaseController
{
	static public var aliases = ["t","page"];
	public function testAction()
	{
		trace ('hey');
	}
}
