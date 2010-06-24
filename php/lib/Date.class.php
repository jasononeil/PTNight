<?php

class Date {
	public function __construct($year, $month, $day, $hour, $min, $sec) {
		if( !php_Boot::$skip_constructor ) {
		$this->__t = mktime($hour, $min, $sec, $month + 1, $day, $year);
	}}
	public $__t;
	public function getTime() {
		return $this->__t * 1000;
	}
	public function getPhpTime() {
		return $this->__t;
	}
	public function getFullYear() {
		return intval(date("Y", $this->__t));
	}
	public function getMonth() {
		$m = intval(date("n", $this->__t));
		return -1 + $m;
	}
	public function getDate() {
		return intval(date("j", $this->__t));
	}
	public function getHours() {
		return intval(date("G", $this->__t));
	}
	public function getMinutes() {
		return intval(date("i", $this->__t));
	}
	public function getSeconds() {
		return intval(date("s", $this->__t));
	}
	public function getDay() {
		return intval(date("w", $this->__t));
	}
	public function toString() {
		return date("Y-m-d H:i:s", $this->__t);
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->�dynamics[$m]) && is_callable($this->�dynamics[$m]))
			return call_user_func_array($this->�dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call �'.$m.'�');
	}
	static $__name__;
	static function now() {
		return Date::fromPhpTime(time());
	}
	static function fromPhpTime($t) {
		$d = new Date(2000, 1, 1, 0, 0, 0);
		$d->__t = $t;
		return $d;
	}
	static function fromTime($t) {
		$d = new Date(2000, 1, 1, 0, 0, 0);
		$d->__t = $t / 1000;
		return $d;
	}
	static function fromString($s) {
		return Date::fromPhpTime(strtotime($s));
	}
	function __toString() { return $this->toString(); }
}
Date::$__name__ = new _hx_array(array("Date"));
