<?php

class controllers_ControllerRegistry {
	public function __construct(){}
	static function registerAll() {
		basehx_Dispatcher::registerController("users", _hx_qtype("controllers.UsersController"));
		if(Lambda::has(Type::getClassFields(_hx_qtype("controllers.UsersController")), "aliases", null)) {
			{
				$_g = 0; $_g1 = controllers_UsersController::$aliases;
				while($_g < $_g1->length) {
					$alias = $_g1[$_g];
					++$_g;
					basehx_Dispatcher::registerController($alias, _hx_qtype("controllers.UsersController"));
					unset($alias);
				}
			}
		}
	}
	function __toString() { return 'controllers.ControllerRegistry'; }
}
