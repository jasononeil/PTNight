<?php

class MainApp {
	public function __construct(){}
	static function main() {
		basehx_App::initiate();
	}
	function __toString() { return 'MainApp'; }
}
