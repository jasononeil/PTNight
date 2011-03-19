<?php

class MainApp {
	public function __construct(){}
	static $startTime;
	static function main() {
		haxe_Log::$trace = (isset(basehx_Log::$trace) ? basehx_Log::$trace: array("basehx_Log", "trace"));
		haxe_Log::trace("FATTY", _hx_anonymous(array("fileName" => "MainApp.hx", "lineNumber" => 14, "className" => "MainApp", "methodName" => "main")));
		php_Lib::hprint("<pre>");
		$request = php_Web::getParams()->get("request");
		basehx_Dispatcher::dispatch($request);
		php_Lib::hprint("</pre>");
		MainApp::printStats();
	}
	static $pageTemplateFile;
	static function initiatePageTemplate() {
		$template = new basehx_tpl_HxTpl();
		$template->loadTemplateFromFile(MainApp::$pageTemplateFile);
		return $template;
	}
	static function printStats() {
		php_Lib::hprint("<pre>");
		$memory = memory_get_peak_usage();
		$memory = intval($memory / 1000);
		haxe_Log::trace(("Memory usage: " . $memory) . "kb", _hx_anonymous(array("fileName" => "MainApp.hx", "lineNumber" => 44, "className" => "MainApp", "methodName" => "printStats")));
		$executionTime = php_Sys::time() - MainApp::$startTime;
		haxe_Log::trace("Execution Time: " . $executionTime, _hx_anonymous(array("fileName" => "MainApp.hx", "lineNumber" => 47, "className" => "MainApp", "methodName" => "printStats")));
		php_Lib::hprint("</pre>");
	}
	function __toString() { return 'MainApp'; }
}
MainApp::$startTime = php_Sys::time();
