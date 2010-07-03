<?php

class controllers_UsersController extends hxbase_BaseController {
	public function __construct($args) { if( !php_Boot::$skip_constructor ) {
		parent::__construct($args);
	}}
	public function getDefaultAction() {
		return (isset($this->hlist) ? $this->hlist: array($this, "hlist"));
	}
	public function hlist() {
		haxe_Log::trace("This is our list", _hx_anonymous(array("fileName" => "UsersController.hx", "lineNumber" => 14, "className" => "controllers.UsersController", "methodName" => "list")));
	}
	static $aliases;
	function __toString() { return 'controllers.UsersController'; }
}
controllers_UsersController::$aliases = new _hx_array(array());
