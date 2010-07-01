<?php

class hxbase_Dispatcher {
	public function __construct(){}
	static $controllerRegistry;
	static function dispatch($request) {
		controllers_ControllerRegistry::registerAll();
		$parts = hxbase_Dispatcher::getRequestParts($request);
		$firstPart = $parts[0];
		$controllerClass = hxbase_Dispatcher::$controllerRegistry->get($firstPart);
		if($controllerClass !== null) {
			$parts->shift();
		}
		else {
			$controllerClass = AppConfig::$defaultController;
		}
		if($parts->length === 0) {
			$parts->push("");
		}
		haxe_Log::trace("We're going to load " . $controllerClass, _hx_anonymous(array("fileName" => "Dispatcher.hx", "lineNumber" => 51, "className" => "hxbase.Dispatcher", "methodName" => "dispatch")));
		Type::createInstance($controllerClass, $parts);
	}
	static function registerController($url, $controller) {
		hxbase_Dispatcher::$controllerRegistry->set($url, $controller);
	}
	static function getRequestParts($request) {
		if(substr($request, strlen($request) - 1, 1) == "/") {
			$request = _hx_substr($request, 0, strlen($request) - 1);
		}
		return _hx_explode("/", $request);
	}
	function __toString() { return 'hxbase.Dispatcher'; }
}
hxbase_Dispatcher::$controllerRegistry = new Hash();
