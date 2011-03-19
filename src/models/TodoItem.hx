:qpackage models;

class TodoItem extends basehx.BaseDbModel
{
	public var id:Int;
	public var userId:Int;
	public var subject:String;
	public var text:String;
	public var priority:Int;
	public var completion:Float;
	
	// And add some relations
	public var user(dynamic,dynamic):User;
	static function RELATIONS() 
	{
		return [{ prop : "user", key : "userId", manager : User.manager }];
	}

	
	public static var manager = new php.db.Manager<TodoItem>(TodoItem);
	
	// performance without relations (1 user, 20 items): 0.27314782142639
	// performance with relations (1 user, 21 items): 0.22158193588257
	// performance with relations (and printing): 0.22159504890442
	
}
