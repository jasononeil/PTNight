<?php

class AppConfig {
	public function __construct(){}
	static $defaultController;
	static $baseUrl = "http://";
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
