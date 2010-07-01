<?php

class hxbase_BaseController implements haxe_rtti_Infos{
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
	static $__rtti = "<class path=\"hxbase.BaseController\" params=\"\" file=\"src/hxbase/BaseController.hx\">\x0A\x09<implements path=\"haxe.rtti.Infos\"/>\x0A\x09<aliases public=\"1\" line=\"18\" static=\"1\">\x0A\x09\x09<c path=\"Array\"><unknown/></c>\x0A\x09\x09<haxe_doc> Create a static array \"aliases\" with any alternate URL requests\x0A\x09that you want to point to this controller.  </haxe_doc>\x0A\x09</aliases>\x0A\x09<isCacheable public=\"1\" set=\"null\">\x0A\x09\x09<e path=\"Bool\"/>\x0A\x09\x09<haxe_doc> Can this controller be cached?  (Read only)\x0A\x09In your Controller Class definition, set this to true or false </haxe_doc>\x0A\x09</isCacheable>\x0A\x09<output><c path=\"String\"/></output>\x0A\x09<toString public=\"1\" set=\"method\" line=\"42\">\x0A\x09\x09<f a=\"\"><c path=\"String\"/></f>\x0A\x09\x09<haxe_doc><![CDATA[ The toString() method should give the output from the various\x0A\x09actions we've called.  This means elsewhere you'll be able to use:\x0A\x09<pre>\x09myController = new MyController(args);\x0A\x09php.Lib.print(myController);</pre>\x0A\x09to print all the output.]]></haxe_doc>\x0A\x09</toString>\x0A\x09<print set=\"method\" line=\"48\">\x0A\x09\x09<f a=\"str\">\x0A\x09\x09\x09<unknown/>\x0A\x09\x09\x09<e path=\"Void\"/>\x0A\x09\x09</f>\x0A\x09\x09<haxe_doc> In your methods, use print() to write to the output </haxe_doc>\x0A\x09</print>\x0A\x09<clearOutput set=\"method\" line=\"54\">\x0A\x09\x09<f a=\"\"><e path=\"Void\"/></f>\x0A\x09\x09<haxe_doc> In your methods, if you want to clear the output, use this </haxe_doc>\x0A\x09</clearOutput>\x0A\x09<new public=\"1\" set=\"method\" line=\"24\">\x0A\x09\x09<f a=\"args\">\x0A\x09\x09\x09<c path=\"Array\"><c path=\"String\"/></c>\x0A\x09\x09\x09<e path=\"Void\"/>\x0A\x09\x09</f>\x0A\x09\x09<haxe_doc> The new() constructor will probably be called by the Dispatcher\x0A\x09if it decides this is the Controller to use.  The constructor should\x0A\x09take the arguments, decide on which \"action\" (method) should be called,\x0A\x09and call it.  </haxe_doc>\x0A\x09</new>\x0A\x09<haxe_doc>\x0AYour controllers should inherit from this base class.\x0A</haxe_doc>\x0A</class>";
	static $aliases;
	function __toString() { return $this->toString(); }
}
hxbase_BaseController::$aliases = new _hx_array(array());
