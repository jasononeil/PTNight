package models;
import models.BaseDbModel;

class Family extends BaseDbModel 
{
	public var id;
	public var mazeKey;
	public var studentID;
	public var children;
	public var parents;
	
	public static var manager = new hxbase.DbManager(Family);
	
	public function new() 
	{
		super();
	}
	
	public function getter_children() 
	{
		return Student.manager.search({familyID: id});
	}
	
	public function getter_parents() 
	{
		return Parent.manager.search({familyID: id});
	}
}
