package models;

class TodoItem extends hxbase.BaseDbModel
{
	public var id:Int;
	public var userId:Int;
	public var subject:String;
	public var text:String;
	public var priority:Int;
	public var completion:Float;
	
	public static var manager = new php.db.Manager<TodoItem>(TodoItem);
}
