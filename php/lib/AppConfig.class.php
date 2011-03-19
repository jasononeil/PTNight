<?php

class AppConfig {
	public function __construct(){}
	static $defaultController;
	static $baseUrl = "http://localhost/ptinterviews/php";
	static $subDir = "/ptinterviews/php";
	static $baseFilePath;
	static $dbServer = "localhost";
	static $dbPort = 3306;
	static $dbDatabase = "ptinterviews";
	static $dbUsername = "ptinterviews";
	static $dbPassword = "password";
	static $tablePrefix;
	function __toString() { return 'AppConfig'; }
}
AppConfig::$defaultController = _hx_qtype("basehx.BaseController");
