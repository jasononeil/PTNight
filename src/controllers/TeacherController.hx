<?php

class controllers_TeacherController extends hxbase_BaseController {
	public function __construct($args) { if( !php_Boot::$skip_constructor ) {
		parent::__construct($args);
	}}
	public function getDefaultAction() {
		return (isset($this->viewTimetable) ? $this->viewTimetable: array($this, "viewTimetable"));
	}
	public function checkPermissions() {
		try {
			AppLogin::checkLoggedIn();
			$userType = AppLogin::$session->get("userType");
			if($userType != "teacher" && $userType != "admin") {
				throw new HException("not a teacher - get out!");
			}
		}catch(Exception $»e) {
		$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
		;
		{ $e = $_ex_;
		{
			hxbase_App::redirect("/login/");
		}}}
	}
	public function welcome() {
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "TeacherController.hx", "lineNumber" => 33, "className" => "controllers.TeacherController", "methodName" => "welcome")));
		$this->printTemplate();
	}
	public function viewTimetable() {
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "TeacherController.hx", "lineNumber" => 39, "className" => "controllers.TeacherController", "methodName" => "viewTimetable")));
		$this->template->assign("pageTitle", "Your Timetable", null);
		$teacherID = AppLogin::$session->get("teacherID");
		$teacher = models_Teacher::$manager->get($teacherID, null);
		$categoryBlocks = new Hash();
		$this->view->assignObject("teacher", $teacher, null);
		models_Interview::$manager->setOrderBy("timeslotID", null);
		$interviews = Lambda::harray($teacher->getter_interviews());
		$interviews->sort(array(new _hx_lambda(array("categoryBlocks" => &$categoryBlocks, "interviews" => &$interviews, "teacher" => &$teacher, "teacherID" => &$teacherID), null, array('a','b'), "{
			return intval(\$a->get_timeslot()->startTime->getTime() - \$b->get_timeslot()->startTime->getTime());
		}"), 'execute2'));
		{
			$_g = 0;
			while($_g < $interviews->length) {
				$interview = $interviews[$_g];
				++$_g;
				$category = $interview->get_student()->get_category()->name;
				$cat = null;
				if($categoryBlocks->exists($category) === false) {
					$cat = $this->view->newLoop("category", null);
					$categoryBlocks->set($category, $cat);
				}
				else {
					$cat = $categoryBlocks->get($category);
				}
				$cat->assign("category", $category, null);
				$date = DateTools::format($interview->get_timeslot()->startTime, "%A %d %B");
				$cat->assign("date", $date, null);
				$loop = $cat->newLoop("interview", null);
				$loop->assignObject("class", $interview->get_schoolClass(), null);
				$loop->assignObject("parent", $interview->get_parent(), null);
				$loop->assignObject("student", $interview->get_student(), null);
				$startTime = DateTools::format($interview->get_timeslot()->startTime, "%I:%M");
				$endTime = DateTools::format($interview->get_timeslot()->getter_endTime(), "%I:%M");
				$loop->assign("startTime", $startTime, null);
				$loop->assign("endTime", $endTime, null);
				unset($startTime,$loop,$interview,$endTime,$date,$category,$cat);
			}
		}
		$this->printTemplate();
	}
	static $aliases;
	function __toString() { return 'controllers.TeacherController'; }
}
controllers_TeacherController::$aliases = new _hx_array(array());
