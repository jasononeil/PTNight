package models;

class User extends hxbase.BaseDbModel
{
	public var id:Int;
	public var username:String;
	public var password:String;
	
	public static var manager = new php.db.Manager<User>(User);
}
