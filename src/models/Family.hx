package models;
import basehx.BaseDbModel;
import models.Parent;

class Family extends BaseDbModel 
{
	public var id:Int;
	public var mazeKey:String;
	public var studentID:Int;
	public var children(getter_children,null):List<Student>;
	public var parents(getter_parents,null):List<Parent>;
	
	public static var manager = new basehx.DbManager<Family>(Family);
	
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
