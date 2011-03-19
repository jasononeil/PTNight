package controllers;

import basehx.Dispatcher;
import controllers.UsersController;
/** This whole class is auto-generated from registercontrollers.n in tools. */
class ControllerRegistry
{
	public static function registerAll()
	{
	// For each controller, set the default path to the lowercase name.
	// And if the controller class has a field "aliases", add each of those too
	
	// Registering controller UsersController
		Dispatcher.registerController("users", UsersController); 
		if (Lambda.has(Type.getClassFields(UsersController), "aliases"))
		{
			for (alias in UsersController.aliases)
			{
				Dispatcher.registerController(alias, UsersController); 
			}
		}
		// 
	}
}
