<?php

class hxbase_Dispatcher {
	public function __construct(){}
	static function dispatch($request) {
		$parts = hxbase_Dispatcher::getRequestParts($request);
		$firstPart = $parts[0];
		haxe_Log::trace(("Seeing if " . $firstPart) . " is a controller", _hx_anonymous(array("fileName" => "Dispatcher.hx", "lineNumber" => 27, "className" => "hxbase.Dispatcher", "methodName" => "dispatch")));
		$controllerClass = Type::resolveClass($firstPart);
		if($controllerClass !== null) {
			$parts->shift();
			haxe_Log::trace("Apparently it is...", _hx_anonymous(array("fileName" => "Dispatcher.hx", "lineNumber" => 35, "className" => "hxbase.Dispatcher", "methodName" => "dispatch")));
		}
		else {
			$controllerClass = AppConfig::$defaultController;
		}
		haxe_Log::trace("We're going to load " . $controllerClass, _hx_anonymous(array("fileName" => "Dispatcher.hx", "lineNumber" => 47, "className" => "hxbase.Dispatcher", "methodName" => "dispatch")));
		Type::createInstance($controllerClass, $parts);
	}
	static function getRequestParts($request) {
		if(substr($request, strlen($request) - 1, 1) == "/") {
			$request = _hx_substr($request, 0, strlen($request) - 1);
		}
		return _hx_explode("/", $request);
	}
	function __toString() { return 'hxbase.Dispatcher'; }
}
