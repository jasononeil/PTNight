<?php

class models_Timeslot extends hxbase_BaseDbModel {
	public function __construct() {
		if( !php_Boot::$skip_constructor ) {
		parent::__construct();
	}}
	public $id;
	public $startTime;
	public $length;
	public $categoryID;
	public function get_category() { return call_user_func($this->get_category); }
	public $get_category;
	public function set_category($v) { return call_user_func($this->set_category, $v); }
	public $set_category;
	public function getter_categories() {
		$list = new HList();
		if ($this->id !== null) {
                        $jList = models_Timeslot_join_StudentCategory::$manager->search(_hx_anonymous(array("timeslot" => $this->id)), null);
                        $ï¿½it = $jList->iterator();
                        while($ï¿½it->hasNext()) {
                        $join = $ï¿½it->next();
                        {
                                $list->add($join->get_studentCategory());
                                ;
                        }
                        }
                }
                return $list;
	}
	public $endTime;
	public function getter_endTime() {
		return DateTools::delta($this->startTime, $this->length * 1000);
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->»dynamics[$m]) && is_callable($this->»dynamics[$m]))
			return call_user_func_array($this->»dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call «'.$m.'»');
	}
	static function RELATIONS() {
		//return new _hx_array(array(_hx_anonymous(array("prop" => "timeslot", "key" => "categoryID", "manager" => models_StudentCategory::$manager))));
		return new _hx_array(array());
	}
	static $manager;
	function __toString() { return 'models.Timeslot'; }
}
models_Timeslot::$manager = new hxbase_DbManager(_hx_qtype("models.Timeslot"));
