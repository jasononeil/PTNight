<?php

class AppLogin {
	public function __construct(){
		if ( !php_Boot::$skip_constructor ) {
	}}
	public $session;
	function login($username, $password) {
		$loginSuccessful = false;
		AppLogin::registerErrorMessages();
		AppLogin::initiateFTP($username, $password);
	}
	function checkLoggedIn() {
		try {
			$session->check();
		}catch(Exception $»e) {
		$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
		;
		if(($err = $_ex_) instanceof hxbase_ErrorObject){
			switch($err->code) {
			case "SESSION.NO_SESSION":{
				throw new HException(new hxbase_ErrorObject("SESSION.NOT_LOGGED_IN", _hx_anonymous(array("fileName" => "AppLogin.hx", "lineNumber" => 54, "className" => "AppLogin", "methodName" => "checkLoggedIn"))));
			}break;
			case "SESSION.TIMEOUT":{
				throw new HException(new hxbase_ErrorObject("SESSION.TIMED_OUT", _hx_anonymous(array("fileName" => "AppLogin.hx", "lineNumber" => 56, "className" => "AppLogin", "methodName" => "checkLoggedIn"))));
			}break;
			}
		} else throw $»e; }
		}
	function logout() {
		$this->$session->end();
	}
	function initiateFTP($username, $password) {
		$server = "172.16.55.1";
		$home = "/home/students/";
		$tmpFolder = "tmp/" . $username;
		try {
			$ftp = new hxbase_ftp_FtpConnection($server, $username, $password, $tmpFolder, $home, null, null);
		}catch(Exception $»e) {
		$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
		;
		if(($e = $_ex_) instanceof hxbase_ErrorObject){
			switch($e->code) {
			case "FTP.SERVER_NOT_FOUND":{
				throw new HException(new hxbase_ErrorObject("FTP.SERVER_DOWN", _hx_anonymous(array("fileName" => "AppLogin.hx", "lineNumber" => 81, "className" => "AppLogin", "methodName" => "initiateFTP"))));
			}break;
			case "FTP.BAD_LOGIN":{
				throw new HException(new hxbase_ErrorObject("SESSION.INCORRECT_LOGIN", _hx_anonymous(array("fileName" => "AppLogin.hx", "lineNumber" => 83, "className" => "AppLogin", "methodName" => "initiateFTP"))));
			}break;
			}
		} else throw $»e; }
	}
	static function registerErrorMessages() {
		hxbase_ErrorObject::registerErrorType("SESSION.NOT_LOGGED_IN", "Please sign in", "We won't be able to get started until you've signed in.", "Please sign in with your child's student username and password.");
		hxbase_ErrorObject::registerErrorType("SESSION.LOGGED_OUT", "See you next time!", "You've signed out successfully.", "See you at the Parent Teacher Night!");
		hxbase_ErrorObject::registerErrorType("SESSION.TIMED_OUT", "I thought you were gone!", "Sorry, after 1 hour we sign you out automatically, to keep your account safe in case you're gone.", "You'll have to sign in again.  Make sure you're quick!");
		hxbase_ErrorObject::registerErrorType("SESSION.INCORRECT_LOGIN", "Try again...", "Your username or password seems to be incorrect.", null);
		hxbase_ErrorObject::registerErrorType("FTP.SERVER_DOWN", "The student server seems to be down.", "We're really sorry but it looks like the student server is down at the moment.", "You might want to try again a bit later.  If there's a teacher nearby, perhaps let them know so the IT guys can get onto it.");
		hxbase_ErrorObject::registerErrorType("FTP.OPERATION_FAILED", "Sorry, that didn't work.", "Whatever it was you were trying to do just failed, and we're not entirely sure why.", "Check the file or folder is not read only, try again later or ask for help.");
	}
	function __toString() { return 'AppLogin'; }
}
