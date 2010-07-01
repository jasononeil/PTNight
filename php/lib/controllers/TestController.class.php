<?php

class controllers_TestController extends hxbase_BaseController {
	public function __construct($args) { if( !php_Boot::$skip_constructor ) {
		parent::__construct($args);
	}}
	public function testAction() {
		haxe_Log::trace("hey", _hx_anonymous(array("fileName" => "TestController.hx", "lineNumber" => 8, "className" => "controllers.TestController", "methodName" => "testAction")));
	}
	static $aliases;
	function __toString() { return 'controllers.TestController'; }
}
controllers_TestController::$aliases = new _hx_array(array("t", "page"));
