<?php

class hxbase_DbManager extends php_db_Manager {
	public function __construct($classval) {
		if( !php_Boot::$skip_constructor ) {
		parent::__construct($classval);
	}}
	public $limit;
	public $groupBy;
	public $orderBy;
	public function setLimit($s, $c) {
		$this->limit = _hx_anonymous(array("start" => $s, "count" => $c));
	}
	public function setGroupBy($f, $o) {
		$type = (($o === null) ? hxbase_OrderType::$ASC : $o);
		$this->groupBy = _hx_anonymous(array("field" => $f, "type" => $type));
	}
	public function setOrderBy($f, $o) {
		$type = (($o === null) ? hxbase_OrderType::$ASC : $o);
		$this->orderBy = _hx_anonymous(array("field" => $f, "type" => $type));
	}
	public function objects($sql, $lock) {
		$sqlEx = $sql;
		$sqlEx = str_replace(php_db_Manager::$FOR_UPDATE, "", $sqlEx);
		if(_hx_field($this, "groupBy") !== null) {
			$sqlEx .= " GROUP BY " . $this->groupBy->field;
			if($this->groupBy->type !== null) {
				$sqlEx .= " " . Std::string($this->groupBy->type);
			}
		}
		if(_hx_field($this, "orderBy") !== null) {
			$sqlEx .= " ORDER BY " . $this->orderBy->field;
			if($this->orderBy->type !== null) {
				$sqlEx .= " " . Std::string($this->orderBy->type);
			}
		}
		if(_hx_field($this, "limit") !== null) {
			$sqlEx .= " LIMIT " . $this->limit->start;
			if($this->limit->count !== null) {
				$sqlEx .= "," . $this->limit->count;
			}
		}
		$sqlEx = ($sqlEx . " ") . php_db_Manager::$FOR_UPDATE;
		return parent::objects($sqlEx,false);
	}
	public function getMultiple($ids, $lock) {
		if($lock === null) {
			$lock = true;
		}
		if($this->table_keys->length !== 1) {
			throw new HException("Invalid number of keys");
		}
		if($ids === null) {
			return null;
		}
		$s = new StringBuf();
		$s->b .= "SELECT * FROM ";
		$s->b .= $this->table_name;
		$s->b .= " WHERE ";
		$onFirstValue = true;
		$»it = $ids->iterator();
		while($»it->hasNext()) {
		$id = $»it->next();
		{
			$x = php_db_Manager::$object_cache->get($id . $this->table_name);
			if($x !== null && (!$lock || !$x->__noupdate__)) {
				return $x;
			}
			if($onFirstValue) {
				$onFirstValue = false;
			}
			else {
				$s->b .= " OR ";
			}
			$s->b .= "(" . $this->quoteField($this->table_keys[0]);
			$s->b .= " = ";
			php_db_Manager::$cnx->addValue($s, $id);
			$s->b .= ")";
			unset($x);
		}
		}
		if($lock) {
			$s->b .= php_db_Manager::$FOR_UPDATE;
		}
		return $this->objects($s->b, $lock);
	}
	public function searchForMultiple($values, $lock) {
		if($lock === null) {
			$lock = true;
		}
		$s = new StringBuf();
		$s->b .= "SELECT * FROM ";
		$s->b .= $this->table_name;
		$s->b .= " WHERE ";
		$onFirstValue = true;
		$»it = $values->iterator();
		while($»it->hasNext()) {
		$x = $»it->next();
		{
			if($onFirstValue) {
				$onFirstValue = false;
			}
			else {
				$s->b .= " OR ";
			}
			$this->addCondition($s, $x);
			;
		}
		}
		if($lock) {
			$s->b .= php_db_Manager::$FOR_UPDATE;
		}
		return $this->objects($s->b, $lock);
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
	function __toString() { return 'hxbase.DbManager'; }
}
