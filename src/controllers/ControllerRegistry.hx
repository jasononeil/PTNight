package controllers;

import hxbase.Dispatcher;
import controllers.AdminController;
import controllers.ParentsController;
/** This whole class is auto-generated from registercontrollers.n in tools. */
class ControllerRegistry
{
	public static function registerAll()
	{
	// For each controller, set the default path to the lowercase name.
	// And if the controller class has a field "aliases", add each of those too
	
	// Registering controller AdminController
		Dispatcher.registerController("admin", AdminController); 
		if (Lambda.has(Type.getClassFields(AdminController), "aliases"))
		{
			for (alias in AdminController.aliases)
			{
				Dispatcher.registerController(alias, AdminController); 
			}
		}
		// 
	// Registering controller ParentsController
		Dispatcher.registerController("parents", ParentsController); 
		if (Lambda.has(Type.getClassFields(ParentsController), "aliases"))
		{
			for (alias in ParentsController.aliases)
			{
				Dispatcher.registerController(alias, ParentsController); 
			}
		}
		// 
	}
}
