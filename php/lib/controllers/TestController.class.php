<?php

class controllers_TestController extends hxbase_BaseController {
	public function __construct($args) { if( !php_Boot::$skip_constructor ) {
		parent::__construct($args);
	}}
	static $aliases;
	function __toString() { return 'controllers.TestController'; }
}
controllers_TestController::$aliases = new _hx_array(array("t", "page"));
