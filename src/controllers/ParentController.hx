<?php

class controllers_ParentController extends hxbase_BaseController {
	public function __construct($args) { if( !php_Boot::$skip_constructor ) {
		parent::__construct($args);
	}}
	public function getDefaultAction() {
		return (isset($this->welcome) ? $this->welcome: array($this, "welcome"));
	}
	public function checkPermissions() {
		try {
			if ($this->session == null) { die("No session");}
			$this->session->check();
			$userType = $this->session->get("userType");
			/*if($userType != "parent" && $userType != "admin") {
				throw new HException("not a parent - get out!");
			}*/
			echo "user is $userType";
			foreach ($_SESSION as $k=>$v) { echo " $k -> $v "; }
			//die ("ok?");
		}catch(Exception $»e) {
		$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
		;
		{ $e = $_ex_;
		{
			hxbase_App::redirect("/login/");
		}}}
	}
	public function welcome() {
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "ParentController.hx", "lineNumber" => 41, "className" => "controllers.ParentController", "methodName" => "welcome")));
		$this->template->assign("pageTitle", "Step 01: Your Details", null);
		$studentID = $this->session->get("studentID");
		$student = models_Student::$manager->get($studentID, null);
		$»it = $student->getter_parents()->iterator();
		while($»it->hasNext()) {
		$parent = $»it->next();
		{
			$loop = $this->view->newLoop("existingParent", null);
			$loop->assignObject("parent", $parent, null);
			unset($loop);
		}
		}
		$this->printTemplate();
	}
	public function newParent() {
		$studentID = $this->session->get("studentID");
		$student = models_Student::$manager->get($studentID, null);
		$parent = new models_Parent();
		$parent->firstName = $this->params->get("first");
		$parent->lastName = $this->params->get("last");
		$parent->familyID = $student->familyID;
		$parent->email = $this->params->get("email");
		$parent->insert();
		$this->session->set("parentID", $parent->id);
		hxbase_App::redirect("/parent/selectteachers/");
	}
	public function updateParent($parentID_in) {
		$parentID = Std::parseInt($parentID_in);
		$parent = models_Parent::$manager->get($parentID, null);
		$studentID = $this->session->get("studentID");
		$student = models_Student::$manager->get($studentID, null);
		if($student->familyID !== $parent->familyID) {
			throw new HException("It looks like you're trying to update a user that is not tied to your login details.  Sorry, you cannot do that.");
		}
		$parent->firstName = $this->params->get("first");
		$parent->lastName = $this->params->get("last");
		$parent->email = $this->params->get("email");
		$parent->update();
		$this->session->set("parentID", $parentID);
		if(models_Interview::$manager->search(_hx_anonymous(array("parentID" => $parent->id)), false)->length > 0) {
			hxbase_App::redirect("/parent/viewtimetable/");
		}
		else {
			hxbase_App::redirect("/parent/selectteachers/");
		}
	}
	public function selectTeachers() {
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "ParentController.hx", "lineNumber" => 106, "className" => "controllers.ParentController", "methodName" => "selectTeachers")));
		$this->template->assign("pageTitle", "Step 02: The Teachers", null);
		$parentID = $this->session->get("parentID");
		$parent = models_Parent::$manager->get($parentID, null);
		$»it = $parent->getter_children()->iterator();
		while($»it->hasNext()) {
		$child = $»it->next();
		{
			echo "child";
			$category = models_StudentCategory::$manager->get($child->categoryID,false);
			if($category->getter_timeslots()->length > 0) {
				echo "has teacher";
				$childBlock = $this->view->newLoop("child", null);
				$childBlock->assignObject("child", $child, null);
				$childBlock->assign("category", $child->get_category()->name, null);
				$»it2 = $child->getter_classes()->iterator();
				while($»it2->hasNext()) {
				$schoolClass = $»it2->next();
				{
					$classBlock = $childBlock->newLoop("class", null);
					if(models_Interview::$manager->search(_hx_anonymous(array("parentID" => $parentID, "studentID" => $child->id, "classID" => $schoolClass->id)), null)->length > 0) {
						$classBlock->newLoop("checkboxChecked", null);
					}
					else {
						$classBlock->newLoop("checkboxUnchecked", null);
					}
					$classBlock->assignObject("class", $schoolClass, null);
					$classBlock->assign("parentID", $parentID, null);
					$classBlock->assignObject("teacher", $schoolClass->get_teacher(), null);
					unset($classBlock);
				}
				}
			}
			else {
				;
			}
			unset($»it2,$schoolClass,$classBlock,$childBlock);
		}
		}
		$this->printTemplate();
	}
	public function bookings() {
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "ParentController.hx", "lineNumber" => 151, "className" => "controllers.ParentController", "methodName" => "bookings")));
		$this->template->assign("pageTitle", "Step 03: The Times", null);
		if($this->params->exists("teacher")) {
			$categoryBlocks = new Hash();
			$timeslotsForCategory = new Hash();
			$selectedSchoolClasses = php_Web::getParamValues("teacher");
			$teacherAvailability = new Hash();
			$allTeacherIDs = Lambda::map($selectedSchoolClasses, array(new _hx_lambda(array("allTeacherIDs" => &$allTeacherIDs, "categoryBlocks" => &$categoryBlocks, "selectedSchoolClasses" => &$selectedSchoolClasses, "teacherAvailability" => &$teacherAvailability, "timeslotsForCategory" => &$timeslotsForCategory), null, array('line'), "{
				\$classID = Std::parseInt(_hx_array_get(_hx_explode(\",\", \$line), 2));
				\$teacherID = models_SchoolClass::\$manager->get(\$classID, null)->teacherID;
				return _hx_anonymous(array(\"teacherID\" => \$teacherID));
			}"), 'execute1'));
			$»it = models_Interview::$manager->searchForMultiple($allTeacherIDs, null)->iterator();
			while($»it->hasNext()) {
			$i = $»it->next();
			{
				$key = ($i->teacherID . ",") . $i->timeslotID;
				$teacherAvailability->set($key, $i->parentID);
				unset($key);
			}
			}
			{
				$_g = 0;
				while($_g < $selectedSchoolClasses->length) {
					$line = $selectedSchoolClasses[$_g];
					++$_g;
					$parts = _hx_explode(",", $line);
					$studentID = Std::parseInt($parts[0]);
					$parentID = Std::parseInt($parts[1]);
					$classID = Std::parseInt($parts[2]);
					$student = models_Student::$manager->get($studentID, null);
					$parent = models_Parent::$manager->get($parentID, null);
					$schoolClass = models_SchoolClass::$manager->get($classID, null);
					$teacher = $schoolClass->get_teacher();
					$categoryObj = $student->get_category();
					$category = $categoryObj->name;
					$timeslots = null;
					if($timeslotsForCategory->exists($category)) {
						$timeslots = $timeslotsForCategory->get($category);
					}
					else {
						$timeslots = $categoryObj->getter_timeslots();
						//$timeslots = models_Timeslot::$manager->search(_hx_anonymous(array("categoryID" => $student->get_category()->id)), null);
						$timeslotsForCategory->set($category, $timeslots);
					}
					$cat = null;
					if($categoryBlocks->exists($category) === false) {
						$cat = $this->view->newLoop("category", null);
						$categoryBlocks->set($category, $cat);
						$cIT = $timeslots->iterator();
						while ($cIT->hasNext()) {
						$t = $cIT->next();
						{
							$d = DateTools::format($t->startTime, "%l:%M");
							$cat->newLoop("timeslot", null)->assign("time", $d, null);
							unset($d);
						}
						}
					}
					else {
						$cat = $categoryBlocks->get($category);
					}
					$cat->assign("category", $category, null);
					$date = DateTools::format($timeslots->first()->startTime, "%A %d %B");
					$cat->assign("date", $date, null);
					$bookingLine = $cat->newLoop("bookingLine", null);
					$bookingLine->assignObject("student", $student, null);
					$bookingLine->assignObject("parent", $parent, null);
					$bookingLine->assignObject("class", $schoolClass, null);
					$bookingLine->assignObject("teacher", $schoolClass->get_teacher(), null);
					$bookingLine->assign("category", $category, null);
					$»it3 = $timeslots->iterator();
					while($»it3->hasNext()) {
					$t2 = $»it3->next();
					{
						$checkBox = $bookingLine->newLoop("timeslot", null);
						$checkBox->assign("timeslotID", $t2->id, null);
						$key2 = ($teacher->id . ",") . $t2->id;
						if($teacherAvailability->exists($key2)) {
							if($teacherAvailability->get($key2) === $parent->id) {
								$checkBox->newLoop("showCheckboxChecked", null);
							}
						}
						else {
							$checkBox->newLoop("showCheckboxUnchecked", null);
						}
						unset($key2,$checkBox);
					}
					}
					unset($»it3,$»it2,$timeslots,$teacher,$t2,$t,$studentID,$student,$schoolClass,$parts,$parentID,$parent,$line,$key2,$date,$d,$classID,$checkBox,$category,$cat,$bookingLine);
				}
			}
		}
		$this->printTemplate();
	}
	public function makeBookings() {
		$parentID = $this->session->get("parentID");
		models_Interview::$manager->delete(_hx_anonymous(array("parentID" => $parentID)));
		$selectedTimeslots = php_Web::getParamValues("Bookings");
		{
			$_g = 0;
			while($_g < $selectedTimeslots->length) {
				$line = $selectedTimeslots[$_g];
				++$_g;
				$parts = _hx_explode(",", $line);
				$studentID = Std::parseInt($parts[0]);
				$classID = Std::parseInt($parts[1]);
				$timeslotID = Std::parseInt($parts[2]);
				$interview = new models_Interview();
				$interview->studentID = $studentID;
				$interview->parentID = $parentID;
				$interview->classID = $classID;
				$interview->teacherID = models_SchoolClass::$manager->get($classID, null)->teacherID;
				$interview->timeslotID = $timeslotID;
				try {
					$interview->insert();
					hxbase_App::redirect("/parent/viewtimetable/");
				}catch(Exception $»e) {
				$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
				;
				{ $e = $_ex_;
				{
					if(_hx_string_call($e, "indexOf", array("Parent-Timeslot-Unique")) >= 0) {
						hxbase_Log::warning("You're trying to book multiple interviews at this timeslot", _hx_anonymous(array("fileName" => "ParentController.hx", "lineNumber" => 289, "className" => "controllers.ParentController", "methodName" => "makeBookings")));
					}
					else {
						if(_hx_string_call($e, "indexOf", array("Parent-Student-SchoolClass-Unique")) >= 0) {
							hxbase_Log::warning("You have already booked an interview with this teacher.", _hx_anonymous(array("fileName" => "ParentController.hx", "lineNumber" => 293, "className" => "controllers.ParentController", "methodName" => "makeBookings")));
						}
						else {
							if(_hx_string_call($e, "indexOf", array("SchoolClass-Timeslot-Unique")) >= 0) {
								hxbase_Log::warning("We're sorry, the teacher is no longer available at this time.", _hx_anonymous(array("fileName" => "ParentController.hx", "lineNumber" => 297, "className" => "controllers.ParentController", "methodName" => "makeBookings")));
							}
							else {
								haxe_Log::trace("Failed to do this one.  error:" . $e, _hx_anonymous(array("fileName" => "ParentController.hx", "lineNumber" => 301, "className" => "controllers.ParentController", "methodName" => "makeBookings")));
							}
						}
					}
					haxe_Log::trace("Let's load the form and try again...", _hx_anonymous(array("fileName" => "ParentController.hx", "lineNumber" => 304, "className" => "controllers.ParentController", "methodName" => "makeBookings")));
				}}}
				unset($»e,$timeslotID,$studentID,$parts,$line,$interview,$e,$classID,$_ex_);
			}
		}
	}
	public function viewTimetable() {
		$this->loadTemplate(null, _hx_anonymous(array("fileName" => "ParentController.hx", "lineNumber" => 312, "className" => "controllers.ParentController", "methodName" => "viewTimetable")));
		$this->template->assign("pageTitle", "Step 04: Your Timetable", null);
		$parentID = $this->session->get("parentID");
		$parent = models_Parent::$manager->get($parentID, null);
		$categoryBlocks = new Hash();
		$this->view->assignObject("parent", $parent, null);
		models_Interview::$manager->setOrderBy("timeslotID", null);
		$interviews = Lambda::harray($parent->getter_interviews());
		$interviews->sort(array(new _hx_lambda(array("categoryBlocks" => &$categoryBlocks, "interviews" => &$interviews, "parent" => &$parent, "parentID" => &$parentID), null, array('a','b'), "{
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
				$loop->assignObject("teacher", $interview->get_teacher(), null);
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
	function __toString() { return 'controllers.ParentController'; }
}
controllers_ParentController::$aliases = new _hx_array(array());
