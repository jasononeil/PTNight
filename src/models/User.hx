package models;

class User extends hxbase.BaseDbModel
{
	public var id:Int;
	public var username:String;
	public var password:String;
	
	// And add some relations
	public var todoList(getter_todoList,null):List<TodoItem>;
	private function getter_todoList():List<TodoItem> 
	{
		return (id == null) ? 
			new List<TodoItem>() : 
			TodoItem.manager.search({ userId : id }); 
	}
	
	public static var manager = new php.db.Manager<User>(User);
	
}
