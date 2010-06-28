<?php

class hxbase_Dispatcher {
	public function __construct(){}
	static function dispatch() {
		$uri = php_Web::getURI();
		haxe_Log::trace($uri, _hx_anonymous(array("fileName" => "Dispatcher.hx", "lineNumber" => 18, "className" => "hxbase.Dispatcher", "methodName" => "dispatch")));
	}
	function __toString() { return 'hxbase.Dispatcher'; }
}
