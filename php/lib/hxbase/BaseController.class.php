<?php

class hxbase_BaseController {
	public function __construct($args) {
		if( !php_Boot::$skip_constructor ) {
		hxbase_Log::error("This is where you're up to", _hx_anonymous(array("fileName" => "BaseController.hx", "lineNumber" => 26, "className" => "hxbase.BaseController", "methodName" => "new")));
	}}
	public $isCacheable;
	public $output;
	public function toString() {
		return $this->output;
	}
	public function hprint($str) {
		$this->output = $this->output . Std::string($str);
	}
	public function clearOutput() {
		$this->output = "";
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
	static $aliases;
	function __toString() { return $this->toString(); }
}
hxbase_BaseController::$aliases = new _hx_array(array());
