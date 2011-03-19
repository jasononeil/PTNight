package controllers;

class UsersController extends basehx.BaseController
{
	public static var aliases = [];
	
	override function getDefaultAction()
	{
		return list;
	}
	
	function list()
	{
		trace ("This is our list");
	}
}
