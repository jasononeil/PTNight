<?php

class AppConfig {
	public function __construct(){}
	static $defaultController;
	static $baseUrl = "http://localhost/hxbase/php";
	static $subDir = "/hxbase/php";
	static $baseFilePath;
	static $dbServer = "localhost";
	static $dbPort = 3306;
	static $dbDatabase = "hxbase";
	static $dbUsername = "hxbase";
	static $dbPassword = "password";
	static $tablePrefix;
	function __toString() { return 'AppConfig'; }
}
AppConfig::$defaultController = _hx_qtype("MainApp");
