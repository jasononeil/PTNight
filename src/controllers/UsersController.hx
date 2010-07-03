package controllers;

class UsersController extends hxbase.BaseController
{
	public static var aliases = [];
	
	function getDefaultAction()
	{
		return list;
	}
	
	function list()
	{
		trace ("This is our list");
	}
}
