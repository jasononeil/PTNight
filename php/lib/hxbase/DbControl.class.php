<?php

class hxbase_DbControl {
	public function __construct(){}
	static $cnx = null;
	static function connect() {
		if(hxbase_DbControl::$cnx === null) {
			hxbase_DbControl::$cnx = php_db_Mysql::connect(_hx_anonymous(array("host" => AppConfig::$dbServer, "port" => AppConfig::$dbPort, "database" => AppConfig::$dbDatabase, "user" => AppConfig::$dbUsername, "pass" => AppConfig::$dbPassword, "socket" => null)));
			php_db_Manager::setConnection(hxbase_DbControl::$cnx);
			php_db_Manager::initialize();
		}
	}
	static function close() {
		php_db_Manager::cleanup();
		hxbase_DbControl::$cnx->close();
		hxbase_DbControl::$cnx = null;
	}
	function __toString() { return 'hxbase.DbControl'; }
}
