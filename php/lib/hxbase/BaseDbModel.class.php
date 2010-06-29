<?php

class hxbase_BaseDbModel extends php_db_Object {
	public function __construct() { if( !php_Boot::$skip_constructor ) {
		parent::__construct();
	}}
	function __toString() { return 'hxbase.BaseDbModel'; }
}
