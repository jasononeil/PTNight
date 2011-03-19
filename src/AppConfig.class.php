<?php

class AppConfig {
	public function __construct(){}
	static $defaultController;
	static $baseUrl = "http://www.somerville.wa.edu.au/ptnight";
	static $subDir = "/ptnight";
	static $baseFilePath;
	static $dbServer = "localhost";
	static $dbPort = 3306;
	static $dbDatabase = "PTNight";
	static $dbUsername = "website";
	static $dbPassword = "wa695xx";
	static $tablePrefix;
	static $sessionID = "SbcStudentLoginSessionID";
	static $sessionTimeout = 3600;
	function __toString() { return 'AppConfig'; }
}
AppConfig::$defaultController = _hx_qtype("controllers.LoginController");
