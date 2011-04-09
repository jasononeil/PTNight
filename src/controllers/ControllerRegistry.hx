package controllers;

import basehx.Dispatcher;
import controllers.AdminController;
import controllers.LoginController;
import controllers.ParentController;
import controllers.TeacherController;
import controllers.TplTestController;
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
	// Registering controller LoginController
		Dispatcher.registerController("login", LoginController); 
		if (Lambda.has(Type.getClassFields(LoginController), "aliases"))
		{
			for (alias in LoginController.aliases)
			{
				Dispatcher.registerController(alias, LoginController); 
			}
		}
		// 
	// Registering controller ParentController
		Dispatcher.registerController("parent", ParentController); 
		if (Lambda.has(Type.getClassFields(ParentController), "aliases"))
		{
			for (alias in ParentController.aliases)
			{
				Dispatcher.registerController(alias, ParentController); 
			}
		}
		// 
	// Registering controller TeacherController
		Dispatcher.registerController("teacher", TeacherController); 
		if (Lambda.has(Type.getClassFields(TeacherController), "aliases"))
		{
			for (alias in TeacherController.aliases)
			{
				Dispatcher.registerController(alias, TeacherController); 
			}
		}
		// 
	// Registering controller TplTestController
		Dispatcher.registerController("tpltest", TplTestController); 
		if (Lambda.has(Type.getClassFields(TplTestController), "aliases"))
		{
			for (alias in TplTestController.aliases)
			{
				Dispatcher.registerController(alias, TplTestController); 
			}
		}
		// 
	}
}
