<?php

class MainApp {
	public function __construct(){}
	static function main() {
		haxe_Log::trace("hey you!", _hx_anonymous(array("fileName" => "MainApp.hx", "lineNumber" => 5, "className" => "MainApp", "methodName" => "main")));
	}
	function __toString() { return 'MainApp'; }
}
