package controllers;

import hxbase.Dispatcher;
import controllers.TestController;
/** This whole class is auto-generated from registercontrollers.n in tools. */
class ControllerRegistry
{
	public static function registerAll()
	{
	// For each controller, set the default path to the lowercase name.
	// And if the controller class has a field "aliases", add each of those too
	
	// Registering controller TestController
		Dispatcher.registerController("test", TestController); 
		if (Lambda.has(Type.getClassFields(TestController), "aliases"))
		{
			for (alias in TestController.aliases)
			{
				Dispatcher.registerController(alias, TestController); 
			}
		}
		// 
	}
}
