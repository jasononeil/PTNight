<?php

class models_StudentCategory extends hxbase_BaseDbModel {
	public function __construct() {
		if( !php_Boot::$skip_constructor ) {
		parent::__construct();
	}}
	public $id;
	public $name;
        public function getter_timeslots() {
                $list = new HList();
                if ($this->id !== null) {
                        $jList = models_Timeslot_join_StudentCategory::$manager->search(_hx_anonymous(array("studentCategoryID" => $this->id)), null);
                        $ï¿½it = $jList->iterator();
                        while($ï¿½it->hasNext()) {
                        $join = $ï¿½it->next();
                        {
                                $list->add($join->get_timeslot());
                                ;
                        }
                        }
                }
                return $list;
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
	static $manager;
	function __toString() { return 'models.StudentCategory'; }
}
models_StudentCategory::$manager = new hxbase_DbManager(_hx_qtype("models.StudentCategory"));
