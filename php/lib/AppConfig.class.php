<?php

class AppConfig {
	public function __construct(){}
	static $defaultController;
	static $baseUrl = "http://localhost/hxbase/php";
	static $subDir = "/hxbase/php";
	static $baseFilePath;
	static $dbServer;
	static $dbPort;
	static $dbDatabase;
	static $dbUsername;
	static $dbPassword;
	static $tablePrefix;
	function __toString() { return 'AppConfig'; }
}
AppConfig::$defaultController = _hx_qtype("MainApp");
