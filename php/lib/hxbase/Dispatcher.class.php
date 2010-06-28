<?php

class hxbase_Dispatcher {
	public function __construct(){}
	static function dispatch($uri) {
		haxe_Log::trace("URI " . $uri, _hx_anonymous(array("fileName" => "Dispatcher.hx", "lineNumber" => 16, "className" => "hxbase.Dispatcher", "methodName" => "dispatch")));
		$request = str_replace(AppConfig::$subDir, "", $uri);
		haxe_Log::trace("REQUEST " . $request, _hx_anonymous(array("fileName" => "Dispatcher.hx", "lineNumber" => 19, "className" => "hxbase.Dispatcher", "methodName" => "dispatch")));
	}
	function __toString() { return 'hxbase.Dispatcher'; }
}
