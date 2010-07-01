<?php

class controllers_ControllerRegistry {
	public function __construct(){}
	static function registerAll() {
		hxbase_Dispatcher::registerController("test", _hx_qtype("controllers.TestController"));
		if(Lambda::has(Type::getClassFields(_hx_qtype("controllers.TestController")), "aliases", null)) {
			{
				$_g = 0; $_g1 = controllers_TestController::$aliases;
				while($_g < $_g1->length) {
					$alias = $_g1[$_g];
					++$_g;
					hxbase_Dispatcher::registerController($alias, _hx_qtype("controllers.TestController"));
					unset($alias);
				}
			}
		}
	}
	function __toString() { return 'controllers.ControllerRegistry'; }
}
