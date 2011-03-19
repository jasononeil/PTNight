<?php

class controllers_LoginController extends hxbase_BaseController {
	public function __construct($args) { if( !php_Boot::$skip_constructor ) {
		parent::__construct($args);
		//if (!$this->session) { die("Here too"); }
	}}
	public $session;
	public function getDefaultAction() {
		return (isset($this->login) ? $this->login: array($this, "login"));
	}
	public function login() {
		$message = null;
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "LoginController.hx", "lineNumber" => 18, "className" => "controllers.LoginController", "methodName" => "login")));
		$this->template->assign("pageTitle", "Parent Teacher Night", null);
		$userType = null;
		try {
		$this->session->check(); }
		catch (Exception $e) {
			// do nothing
			echo "no session";
		}
		if($this->session->get("userType") !== null) {
			$userType = $this->session->get("userType");
			//echo "userType is $userType";
		}
		else {
			if($this->params->exists("username") && $this->params->exists("password")) {
				echo "we have params";
				$u = $this->params->get("username");
				$p = $this->params->get("password");
				try {
					$applogin = new AppLogin;
					$applogin->login($u,$p);
					$this->session->set("username",$u);
					$this->session->set("password",$p);
					$yearAtEndOfUsername = new EReg("[0-9]{4}\$", "");
					if($yearAtEndOfUsername->match($u)) {
						$userType = "parent";
						$student = models_Student::$manager->search(_hx_anonymous(array("username" => $u)), null)->first();
						if($student !== null) {
							$this->session->set("studentID", $student->id);
						}
					}
					else {
						$userType = "teacher";
						$teacher = models_Teacher::$manager->search(_hx_anonymous(array("username" => $u)), null)->first();
						if($teacher !== null) {
							$this->session->set("teacherID", $teacher->id);
						}
						if($u == "jason" || $u == "joneil" || $u == "dmckinnon" || $u == "gmiddleton") {
							$userType = "admin";
						}
					}
					$this->session->set("userType", $userType);
					echo "Died on $userType " . $this->session->get("userType") . $this->session->get("studentID");
				}catch(Exception $»e) {
				$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
				;
				if(($e = $_ex_) instanceof hxbase_ErrorObject){
					$this->view->setSwitch("message", true, null)->assign("explanation", $e->explanation, null)->assign("suggestion", $e->suggestion, null);
				} else throw $»e; }
			}
		}
		if($userType !== null) {
			hxbase_App::redirect(("/" . $userType) . "/");
		}
		$this->printTemplate();
	}

	public function logout() {
		$this->session->end();
		hxbase_App::redirect("/");
	}
	static $aliases;
	function __toString() { return 'controllers.LoginController'; }
}

controllers_LoginController::$aliases = new _hx_array(array());
