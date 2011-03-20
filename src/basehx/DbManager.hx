package basehx;
import php.db.Manager;
import php.db.Connection;
using StringTools;

class DbManager<T:php.db.Object> extends Manager<T>
{
	public function new(classval) 
	{
		super(classval);
	}
	public var limit:Limit;
	public var groupBy:GroupBy;
	public var orderBy:OrderBy;
	
	public function setLimit(s, c) 
	{
		limit = {start: s, count: c};
	}
	
	public function setGroupBy(f, ?o) 
	{
		var type = (o == null) ? OrderType.ASC : o;
		groupBy = {field: f, type: type};
	}
	
	public function setOrderBy(f, ?o) 
	{
		var type = (o == null) ? OrderType.ASC : o;
		orderBy = {field: f, type: type};
	}
	
	override public function objects( sql : String, lock : Bool ):List<T>
	{
		var sqlEx = sql;
		sqlEx = sqlEx.replace(Manager.FOR_UPDATE, "");
		if(groupBy != null) 
		{
			sqlEx += " GROUP BY " + groupBy.field;
			if(groupBy.type != null) 
			{
				sqlEx += " " + Std.string(groupBy.type);
			}
		}
		if(orderBy != null) 
		{
			sqlEx += " ORDER BY " + orderBy.field;
			if(orderBy.type != null) 
			{
				sqlEx += " " + Std.string(orderBy.type);
			}
		}
		if(limit != null) 
		{
			sqlEx += " LIMIT " + limit.start;
			if(limit.count != null) 
			{
				sqlEx += "," + limit.count;
			}
		}
		sqlEx = (sqlEx + " ") + Manager.FOR_UPDATE;
		return super.objects(sqlEx,false);
	}
	
	public function getMultiple(ids:List<Int>, lock:Bool):List<T>
	{
		if(lock == null) 
		{
			lock = true;
		}
		if(table_keys.length != 1) 
		{
			throw "Invalid number of keys";
		}
		if(ids == null) 
		{
			return null;
		}
		var s = new StringBuf();
		s.add("SELECT * FROM ");
		s.add(table_name);
		s.add(" WHERE ");
		var onFirstValue = true;
		for (id in ids)
		{
			/*var x = Manager.object_cache.get(id + table_name);
			if(x != null && (!lock || !x.__noupdate__)) 
			{
				//return x;
			}*/
			if(onFirstValue != null) 
			{
				onFirstValue = false;
			}
			else 
			{
				s.add(" OR ");
			}
			s.add("(" + quoteField(table_keys[0]));
			s.add(" = ");
			Manager.cnx.addValue(s, id);
			s.add(")");
		}
		if(lock) 
		{
			s.add(Manager.FOR_UPDATE);
		}
		return objects(s.toString(), lock);
	}
	
	public function searchForMultiple(values:List<{}>, lock):List<T>
	{
		if(lock == null) 
		{
			lock = true;
		}
		var s = new StringBuf();
		s.add("SELECT * FROM ");
		s.add(table_name);
		s.add(" WHERE ");
		var onFirstValue = true;
		for (x in values)
		{
			if(onFirstValue) 
			{
				onFirstValue = false;
			}
			else 
			{
				s.add(" OR ");
			}
			addCondition(s, x);
		}
		if(lock) 
		{
			s.add(Manager.FOR_UPDATE);
		}
		return objects(s.toString(), lock);
	}
}

typedef Limit = 
{
	var start:Int;
	var count:Int;
}

typedef OrderBy = 
{
	var field:String;
	var type:OrderType;
}

typedef GroupBy = 
{
	var field:String;
	var type:OrderType;
}

enum OrderType
{
	ASC;
	DESC;
}
