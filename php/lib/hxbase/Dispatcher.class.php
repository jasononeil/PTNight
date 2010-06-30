<?php

class hxbase_Dispatcher {
	public function __construct(){}
	static function dispatch($request) {
		$parts = hxbase_Dispatcher::getRequestParts($request);
		$firstPart = $parts[0];
		haxe_Log::trace(("Seeing if " . $firstPart) . " is a controller", _hx_anonymous(array("fileName" => "Dispatcher.hx", "lineNumber" => 24, "className" => "hxbase.Dispatcher", "methodName" => "dispatch")));
		$controllerClass = Type::resolveClass($firstPart);
		if($controllerClass !== null) {
			$parts->shift();
		}
		else {
			$controllerClass = AppConfig::$defaultController;
		}
		haxe_Log::trace("We're going to load " . $controllerClass, _hx_anonymous(array("fileName" => "Dispatcher.hx", "lineNumber" => 41, "className" => "hxbase.Dispatcher", "methodName" => "dispatch")));
		{
			$_g = 0; $_g1 = Type::getClassFields($controllerClass);
			while($_g < $_g1->length) {
				$field = $_g1[$_g];
				++$_g;
				haxe_Log::trace("Fields in Class: " . $field, _hx_anonymous(array("fileName" => "Dispatcher.hx", "lineNumber" => 44, "className" => "hxbase.Dispatcher", "methodName" => "dispatch")));
				unset($field);
			}
		}
		_hx_qtype("Lambda");
	}
	static function getRequestParts($request) {
		if(substr($request, strlen($request) - 1, 1) == "/") {
			$request = _hx_substr($request, 0, strlen($request) - 1);
		}
		return _hx_explode("/", $request);
	}
	function __toString() { return 'hxbase.Dispatcher'; }
}
