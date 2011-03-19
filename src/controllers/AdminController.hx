<?php

class controllers_AdminController extends hxbase_BaseController {
	public function __construct($args) { if( !php_Boot::$skip_constructor ) {
		parent::__construct($args);
	}}
	public function getDefaultAction() {
		return (isset($this->home) ? $this->home: array($this, "home"));
	}
	public function checkPermissions() {
		try {
			$this->session->check();
			foreach ($_SESSION as $k=>$v) { echo " $k $v "; }
			echo "--" . $this->session->get("userType");
			/*if(!_hx_equal($this->session->get("userType"), "admin")) {
				throw new HException("You don't look very trustworthy!");
			}*/
		}catch(Exception $»e) {
		$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
		;
		{ $e = $_ex_;
		{
			hxbase_App::redirect("/login/");
		}}}
	}
	public function home() {
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 44, "className" => "controllers.AdminController", "methodName" => "home")));
		$this->template->assign("pageTitle", "Admin Panel", null);
		$this->printTemplate();
	}
	
	public function addTimeSlots($date_in, $start_in, $end_in, $duration_in, $categories_in) {
		hxbase_DbControl::connect();
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 0, "className" => "controllers.AdminController", "methodName" => "addTimeSlots")));
		$date = Date::fromString($date_in);
		$start = $date->getTime() + hxbase_MyDateTools::timeFromString($start_in)->getTime();
		$end = $date->getTime() + hxbase_MyDateTools::timeFromString($end_in)->getTime();
		$duration = Std::parseInt($duration_in);
		//$category = models_StudentCategory::$manager->search(_hx_anonymous(array("name" => $category_in)), null)->first()->id;
		while($end > $start) {
			$t = new models_Timeslot();
			$t->startTime = Date::fromTime($start);
			$t->length = $duration;
			$t->categoryID = null;
			//haxe_Log::trace($t->startTime->toString(), _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 69, "className" => "controllers.AdminController", "methodName" => "addTimeSlots")));
			$t->insert();
			$categories_arr = explode(",", $categories_in);
			foreach ($categories_arr as $category_in)
			{
                                $category = models_StudentCategory::$manager->search(_hx_anonymous(array("name" => $category_in)), null)->first()->id;
                                $c = new models_Timeslot_join_StudentCategory();
                                $c->timeslotID = $t->id;
				$c->studentCategoryID = $category;
				$c->insert();
				unset ($c);
                        }

			$start = $start + $duration * 1000;
			unset($t);
		}
		$this->template->assign("date",$date_in,null);
		$this->template->assign("starttime",$start_in,null);
		$this->template->assign("endtime",$end_in,null);
		$this->template->assign("duration",$duration / 60,null);
		$this->template->assign("category",$category,null);
		hxbase_DbControl::close();
		$this->printTemplate();
	}
	
	public function importMazeData() {
		hxbase_DbControl::connect();
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 80, "className" => "controllers.AdminController", "methodName" => "importMazeData")));
		$hash = php_Web::getMultipart(10485760);
		if($hash->exists("mazedata")) {
			$csv = $hash->get("mazedata");
			$this->importMazeData_execute($csv);
		}
		$this->printTemplate();
		hxbase_DbControl::close();
	}
	public function importMazeData_execute($csv) {
		$studentIDs = new Hash();
		$teacherIDs = new Hash();
		$classIDs = new IntHash();
		$familyIDs = new Hash();
		models_SchoolClass_join_Student::$manager->delete(_hx_anonymous(array()));
		models_Family::$manager->delete(_hx_anonymous(array()));
		models_Teacher::$manager->delete(_hx_anonymous(array()));
		$lines = _hx_string_call($csv, "split", array("\x0A"));
		{
			$_g = 0;
			while($_g < $lines->length) {
				$line = $lines[$_g];
				++$_g;
				if($line != "") {
					$parts = _hx_explode(",", $line);
					$studentKey = $parts[0];
					$studentFirst = $parts[1];
					$studentLast = $parts[2];
					$studentCategory = $parts[3];
					$studentYearGroup = Std::parseInt(_hx_substr($studentCategory, 1, 2));
					$studentGraduation = (Date::now()->getFullYear() + 12) - $studentYearGroup;
					$studentUsername = (strtolower($studentFirst) . strtolower($studentLast)) . $studentGraduation;
					$studentUsername = _hx_deref(new EReg("[^a-zA-Z0-9]", ""))->replace($studentUsername, "");
					$familyKey = $parts[9];
					if($familyIDs->exists($familyKey) === false) {
						$family = new models_Family();
						$family->mazeKey = $familyKey;
						$family->insert();
						$familyIDs->set($familyKey, $family->id);
					}
					if($studentIDs->exists($studentKey) === false) {
						$student = new models_Student();
						$student->firstName = $studentFirst;
						$student->lastName = $studentLast;
						$student->username = $studentUsername;
						$student->categoryID = models_StudentCategory::$manager->search(_hx_anonymous(array("name" => $studentCategory)), null)->first()->id;
						$student->familyID = $familyIDs->get($familyKey);
						$student->insert();
						$studentIDs->set($studentKey, $student->id);
					}
					$teacherKey = $parts[6];
					if($teacherIDs->exists($teacherKey) === false) {
						$teacher = new models_Teacher();
						$teacher->firstName = $parts[7];
						$teacher->lastName = $parts[8];
						$teacher->username = strtolower(_hx_substr($teacher->firstName, 0, 1)) . strtolower($teacher->lastName);
						$teacher->username = _hx_deref(new EReg("[^a-zA-Z0-9]", ""))->replace($teacher->username, "");
						$teacher->email = $teacher->username . "@somerville.wa.edu.au";
						$teacher->insert();
						$teacherIDs->set($teacherKey, $teacher->id);
					}
					$classKey = Std::parseInt($parts[5]);
					if($classIDs->exists($classKey) === false) {
						$schoolClass = new models_SchoolClass();
						$schoolClass->className = $parts[4];
						$schoolClass->teacherID = $teacherIDs->get($teacherKey);
						$schoolClass->insert();
						$classIDs->set($classKey, $schoolClass->id);
					}
					$studentInSchoolClass = new models_SchoolClass_join_Student();
					$studentInSchoolClass->classID = $classIDs->get($classKey);
					$studentInSchoolClass->studentID = $studentIDs->get($studentKey);
					$studentInSchoolClass->insert();
					php_Lib::hprint(". ");
					flush();
				}
				unset($teacherKey,$teacher,$studentYearGroup,$studentUsername,$studentLast,$studentKey,$studentInSchoolClass,$studentGraduation,$studentFirst,$studentCategory,$student,$schoolClass,$parts,$line,$familyKey,$family,$classKey);
			}
		}
		php_Lib::hprint("<pre>");
		haxe_Log::trace("Done import.  Show some stats?", _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 193, "className" => "controllers.AdminController", "methodName" => "importMazeData_execute")));
		haxe_Log::trace(("Imported " . models_Student::$manager->count(null)) . " students", _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 194, "className" => "controllers.AdminController", "methodName" => "importMazeData_execute")));
		haxe_Log::trace(("With " . models_Parent::$manager->count(null)) . " parents", _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 195, "className" => "controllers.AdminController", "methodName" => "importMazeData_execute")));
		haxe_Log::trace(("(that's " . models_Family::$manager->count(null)) . " families)", _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 196, "className" => "controllers.AdminController", "methodName" => "importMazeData_execute")));
		haxe_Log::trace(("In " . models_SchoolClass::$manager->count(null)) . " classes", _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 197, "className" => "controllers.AdminController", "methodName" => "importMazeData_execute")));
		haxe_Log::trace(("(that's " . models_SchoolClass_join_Student::$manager->count(null)) . " combinations)", _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 198, "className" => "controllers.AdminController", "methodName" => "importMazeData_execute")));
		haxe_Log::trace(("Taught by " . models_Teacher::$manager->count(null)) . " teachers", _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 199, "className" => "controllers.AdminController", "methodName" => "importMazeData_execute")));
		php_Lib::hprint("</pre>");
	}
	public function viewAllParents() {
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 205, "className" => "controllers.AdminController", "methodName" => "viewAllParents")));
		$this->template->assign("pageTitle", "Viewing All Parents", null);
		models_Parent::$manager->setOrderBy("lastName", null);
		$this->view->useListInLoop(models_Parent::$manager->all(false), "parent", "parent", null, null);
		$this->printTemplate();
	}
	public function viewParent($id_in) {
		$parentID = Std::parseInt($id_in);
		$this->session->set("parentID", $parentID);
		hxbase_App::redirect("/parent/viewtimetable/");
	}
	public function customAppointment($id_in) {
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 223, "className" => "controllers.AdminController", "methodName" => "customAppointment")));
		$parentID = Std::parseInt($id_in);
		$parent = models_Parent::$manager->get($parentID, null);
		$this->template->assign("pageTitle", "Custom Appointments", null);
		$this->view->assignObject("parent", $parent, null);
		models_Interview::$manager->setOrderBy("timeslotID", null);
		$interviews = Lambda::harray($parent->getter_interviews());
		$interviews->sort(array(new _hx_lambda(array("id_in" => &$id_in, "interviews" => &$interviews, "parent" => &$parent, "parentID" => &$parentID), null, array('a','b'), "{
			return intval(\$a->get_timeslot()->startTime->getTime() - \$b->get_timeslot()->startTime->getTime());
		}"), 'execute2'));
		{
			$_g = 0;
			while($_g < $interviews->length) {
				$interview = $interviews[$_g];
				++$_g;
				$loop = $this->view->newLoop("interview", null);
				$loop->assign("interviewID", $interview->id, null);
				$loop->assignObject("class", $interview->get_schoolClass(), null);
				$loop->assignObject("teacher", $interview->get_teacher(), null);
				$loop->assignObject("student", $interview->get_student(), null);
				$startTime = DateTools::format($interview->get_timeslot()->startTime, "%h %e %I:%M");
				$loop->assign("startTime", $startTime, null);
				unset($startTime,$loop,$interview);
			}
		}
	}
	public function newCustomAppointment($id_in) {
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 251, "className" => "controllers.AdminController", "methodName" => "newCustomAppointment")));
		$parentID = Std::parseInt($id_in);
		$parent = models_Parent::$manager->get($parentID, null);
		$this->view->assignObject("parent", $parent, null);
		$this->view->useListInLoop($parent->getter_children(), "student", "student", null, null);
		models_Teacher::$manager->setOrderBy("lastName", null);
		$this->view->useListInLoop(models_Teacher::$manager->all(false), "teacher", "teacher", null, null);
		$this->printTemplate();
	}
	public function setTimesCustomAppointment() {
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 266, "className" => "controllers.AdminController", "methodName" => "setTimesCustomAppointment")));
		$this->template->assign("pageTitle", "Select Timeslot", null);
		$params = php_Web::getParams();
		$parentID = Std::parseInt($params->get("parentID"));
		$teacherID = Std::parseInt($params->get("teacherID"));
		$studentID = Std::parseInt($params->get("studentID"));
		$interviewID = Std::parseInt($params->get("interviewID"));
		$this->view->assign("parentID", $parentID, null);
		$this->view->assign("teacherID", $teacherID, null);
		$this->view->assign("studentID", $studentID, null);
		$this->view->assign("interviewID", $interviewID, null);
		$teacherAvailability = new Hash();
		$»it = models_Interview::$manager->search(_hx_anonymous(array("teacherID" => $teacherID)), null)->iterator();
		while($»it->hasNext()) {
		$i = $»it->next();
		{
			$teacherAvailability->set("" . $i->timeslotID, $i->parentID);
			;
		}
		}
		$parentAvailability = new Hash();
		$»it2 = models_Interview::$manager->search(_hx_anonymous(array("parentID" => $parentID)), null)->iterator();
		while($»it2->hasNext()) {
		$i2 = $»it2->next();
		{
			$parentAvailability->set("" . $i2->timeslotID, $i2->id);
			;
		}
		}
		$classID = null;
		$student = models_Student::$manager->get($studentID, null);
		$category = $student->get_category()->name;
		$timeslots = models_Timeslot::$manager->all(null);
		$»it3 = $timeslots->iterator();
		while($»it3->hasNext()) {
		$t = $»it3->next();
		{
			$key = "" . $t->id;
			if($teacherAvailability->exists($key) && $teacherAvailability->get($key) !== $parentID) {
				;
			}
			else {
				if($parentAvailability->exists($key) && $parentAvailability->get($key) !== $interviewID) {
					;
				}
				else {
					$timeslot = $this->view->newLoop("timeslot", null);
					$time = DateTools::format($t->startTime, "%A %d %B %l:%M");
					$timeslot->assign("id", $t->id, null);
					$timeslot->assign("time", $time, null);
					if($interviewID !== null) {
						$interview = models_Interview::$manager->get($interviewID, null);
						if($interview->timeslotID === $t->id) {
							$this->view->newLoop("timeslotSelected", null)->assign("id", $t->id, null)->assign("time", $time, null);
						}
					}
				}
			}
			unset($timeslot,$time,$key,$interview);
		}
		}
		$this->printTemplate();
	}
	public function bookCustomAppointment() {
		$params = php_Web::getParams();
		$i = new models_Interview();
		$i->id = (($params->exists("interviewID")) ? Std::parseInt($params->get("interviewID")) : null);
		$i->parentID = Std::parseInt($params->get("parentID"));
		$i->teacherID = Std::parseInt($params->get("teacherID"));
		$i->studentID = Std::parseInt($params->get("studentID"));
		$i->timeslotID = Std::parseInt($params->get("timeslotID"));
		if($i->id === null) {
			$i->insert();
		}
		else {
			$i->update();
		}
		hxbase_App::redirect(("/admin/customappointment/" . $i->parentID) . "/");
	}
	public function editCustomAppointment($id_in) {
		$this->loadTemplate("views/admin/newCustomAppointment.tpl", _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 368, "className" => "controllers.AdminController", "methodName" => "editCustomAppointment")));
		$interviewID = Std::parseInt($id_in);
		$interview = models_Interview::$manager->get($interviewID, null);
		$parentID = $interview->parentID;
		$parent = models_Parent::$manager->get($parentID, null);
		$this->view->assignObject("parent", $parent, null);
		$this->view->assignObject("interview", $interview, null);
		$»it = $parent->getter_children()->iterator();
		while($»it->hasNext()) {
		$student = $»it->next();
		{
			if($student->id === $interview->studentID) {
				$this->view->newLoop("studentSelected", null)->assignObject("student", $student, null);
			}
			$this->view->newLoop("student", null)->assignObject("student", $student, null);
			;
		}
		}
		models_Teacher::$manager->setOrderBy("lastName", null);
		$»it2 = models_Teacher::$manager->all(false)->iterator();
		while($»it2->hasNext()) {
		$teacher = $»it2->next();
		{
			if($teacher->id === $interview->teacherID) {
				$this->view->newLoop("teacherSelected", null)->assignObject("teacher", $teacher, null);
			}
			$this->view->newLoop("teacher", null)->assignObject("teacher", $teacher, null);
			;
		}
		}
		$this->printTemplate();
	}
	public function deleteCustomAppointment($id_in) {
		$interviewID = Std::parseInt($id_in);
		$i = models_Interview::$manager->get($interviewID, null);
		$parentID = $i->parentID;
		models_Interview::$manager->delete(_hx_anonymous(array("id" => $interviewID)));
		hxbase_App::redirect(("/admin/customappointment/" . $parentID) . "/");
	}
	public function viewAllTeachers() {
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 407, "className" => "controllers.AdminController", "methodName" => "viewAllTeachers")));
		$this->template->assign("pageTitle", "Viewing All Teachers", null);
		models_Teacher::$manager->setOrderBy("lastName", null);
		$this->view->useListInLoop(models_Teacher::$manager->all(false), "teacher", "teacher", null, null);
		$this->printTemplate();
	}
	public function viewTeacher($id) {
		$this->loadTemplate("views/teacher/viewTimetable.tpl", _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 418, "className" => "controllers.AdminController", "methodName" => "viewTeacher")));
		$this->template->assign("pageTitle", "Your Timetable", null);
		$teacherID = Std::parseInt($id);
		$teacher = models_Teacher::$manager->get($teacherID, null);
		$categoryBlocks = new Hash();
		$this->view->assignObject("teacher", $teacher, null);
		models_Interview::$manager->setOrderBy("timeslotID", null);
		$interviews = Lambda::harray($teacher->getter_interviews());
		$interviews->sort(array(new _hx_lambda(array("categoryBlocks" => &$categoryBlocks, "id" => &$id, "interviews" => &$interviews, "teacher" => &$teacher, "teacherID" => &$teacherID), null, array('a','b'), "{
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
	public function printAllTeachers() {
		$allTimetables = new StringBuf();
		$this->pageTemplateFile = "views/Empty.tpl";
		models_Interview::$manager->setOrderBy("timeslotID", null);
		models_Teacher::$manager->setOrderBy("lastName", null);
		$»it = models_Teacher::$manager->all(false)->iterator();
		while($»it->hasNext()) {
		$teacher = $»it->next();
		{
			php_Lib::hprint(" ");
			$this->viewTeacher(Std::string($teacher->id));
			$allTimetables->b .= $this->output;
			$allTimetables->b .= "\x0A<hr class=\"page-break\" />";
			;
		}
		}
		$this->pageTemplateFile = null;
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "AdminController.hx", "lineNumber" => 486, "className" => "controllers.AdminController", "methodName" => "printAllTeachers")));
		$this->template->assign("pageTitle", "All Teacher Timetables", null);
		$this->template->assign("printAll", $allTimetables, false);
		$this->printTemplate();
	}
	static $aliases;
	function __toString() { return 'controllers.AdminController'; }
}
controllers_AdminController::$aliases = new _hx_array(array());
