<?php

class MainApp {
	public function __construct(){}
	static function main() {
		php_Lib::hprint("<pre>");
		haxe_Log::trace("Call the dispatcher to figure out what to do...", _hx_anonymous(array("fileName" => "MainApp.hx", "lineNumber" => 10, "className" => "MainApp", "methodName" => "main")));
		hxbase_Dispatcher::dispatch();
		php_Lib::hprint("</pre>");
	}
	function __toString() { return 'MainApp'; }
}
