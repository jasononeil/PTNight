<?php

class controllers_TestController extends hxbase_BaseController {
	public function __construct($args) { if( !php_Boot::$skip_constructor ) {
		parent::__construct($args);
	}}
	public function defaultAction($args, $action) {
		parent::defaultAction($args,"myWeirdDefault");
	}
	public function testAction() {
		haxe_Log::trace("hey", _hx_anonymous(array("fileName" => "TestController.hx", "lineNumber" => 11, "className" => "controllers.TestController", "methodName" => "testAction")));
	}
	public function myWeirdDefault($str) {
		haxe_Log::trace("Default on Test Controller: " . $str, _hx_anonymous(array("fileName" => "TestController.hx", "lineNumber" => 16, "className" => "controllers.TestController", "methodName" => "myWeirdDefault")));
	}
	static $aliases;
	function __toString() { return 'controllers.TestController'; }
}
controllers_TestController::$aliases = new _hx_array(array("t", "page"));
