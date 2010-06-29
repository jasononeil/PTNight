<?php

class MainApp {
	public function __construct(){}
	static $startTime;
	static function main() {
		php_Lib::hprint("<pre>");
		haxe_Log::trace("Call the dispatcher to figure out what to do...", _hx_anonymous(array("fileName" => "MainApp.hx", "lineNumber" => 13, "className" => "MainApp", "methodName" => "main")));
		$params = php_Web::getParams();
		$request = $params->get("request");
		hxbase_Dispatcher::dispatch($request);
		php_Lib::hprint("</pre>");
		MainApp::printStats();
	}
	static function printStats() {
		php_Lib::hprint("<pre>");
		$memory = memory_get_peak_usage();
		$memory = intval($memory / 1000);
		haxe_Log::trace(("Memory usage: " . $memory) . "kb", _hx_anonymous(array("fileName" => "MainApp.hx", "lineNumber" => 29, "className" => "MainApp", "methodName" => "printStats")));
		$executionTime = php_Sys::time() - MainApp::$startTime;
		haxe_Log::trace("CPU Time: " . $executionTime, _hx_anonymous(array("fileName" => "MainApp.hx", "lineNumber" => 32, "className" => "MainApp", "methodName" => "printStats")));
		php_Lib::hprint("</pre>");
	}
	function __toString() { return 'MainApp'; }
}
MainApp::$startTime = php_Sys::time();
