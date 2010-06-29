<?php

class MainApp {
	public function __construct(){}
	static $startTime;
	static function main() {
		php_Lib::hprint("<pre>");
		haxe_Log::trace("Call the dispatcher to figure out what to do...", _hx_anonymous(array("fileName" => "MainApp.hx", "lineNumber" => 16, "className" => "MainApp", "methodName" => "main")));
		MainApp::testing();
		php_Lib::hprint("</pre>");
		MainApp::printStats();
	}
	static function testing() {
		hxbase_DbControl::connect();
		haxe_Log::trace(hxbase_DbControl::$cnx, _hx_anonymous(array("fileName" => "MainApp.hx", "lineNumber" => 32, "className" => "MainApp", "methodName" => "testing")));
		$u = models_User::$manager->search(_hx_anonymous(array("username" => "jason")), null)->first();
		if($u === null) {
			$u = new models_User();
			$u->username = "jason";
			$u->password = haxe_Md5::encode("password");
			$u->insert();
			haxe_Log::trace("Inserted, id is " . $u->id, _hx_anonymous(array("fileName" => "MainApp.hx", "lineNumber" => 42, "className" => "MainApp", "methodName" => "testing")));
		}
		else {
			haxe_Log::trace("User already there.  Id is " . $u->id, _hx_anonymous(array("fileName" => "MainApp.hx", "lineNumber" => 46, "className" => "MainApp", "methodName" => "testing")));
		}
		$count = models_TodoItem::$manager->count(null);
		$t = new models_TodoItem();
		$t->userId = $u->id;
		$t->subject = "Todo number " . $count;
		$t->text = ("You better get moving before number " . ($count + 1)) . " comes along";
		$t->priority = 5;
		$t->completion = Std::random(100) / 100;
		$t->insert();
		$todoList = models_TodoItem::$manager->all(null);
		$»it = $todoList->iterator();
		while($»it->hasNext()) {
		$item = $»it->next();
		{
			haxe_Log::trace("ITEM: " . $item->subject, _hx_anonymous(array("fileName" => "MainApp.hx", "lineNumber" => 63, "className" => "MainApp", "methodName" => "testing")));
			;
		}
		}
		hxbase_DbControl::close();
	}
	static function printStats() {
		php_Lib::hprint("<pre>");
		$memory = memory_get_peak_usage();
		$memory = intval($memory / 1000);
		haxe_Log::trace(("Memory usage: " . $memory) . "kb", _hx_anonymous(array("fileName" => "MainApp.hx", "lineNumber" => 76, "className" => "MainApp", "methodName" => "printStats")));
		$executionTime = php_Sys::time() - MainApp::$startTime;
		haxe_Log::trace("Execution Time: " . $executionTime, _hx_anonymous(array("fileName" => "MainApp.hx", "lineNumber" => 79, "className" => "MainApp", "methodName" => "printStats")));
		php_Lib::hprint("</pre>");
	}
	function __toString() { return 'MainApp'; }
}
MainApp::$startTime = php_Sys::time();
