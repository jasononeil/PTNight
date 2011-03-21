package models;
import basehx.BaseDbModel;

class Parent extends BaseDbModel 
{
	
	public var id:Int;
	public var firstName:String;
	public var lastName:String;
	public var familyID:Int;
	public var email:String;
	
	public var children(getter_children,null):List<Student>;
	public function getter_children() 
	{
		return Student.manager.search({familyID: this.familyID});
	}
	
	public var interviews(getter_interviews,null):List<Interview>;
	public function getter_interviews() 
	{
		return Interview.manager.search({parentID: id}, false);
	}
	
	public static var manager = new basehx.DbManager<Parent>(Parent);
	
	public function new() 
	{
		super();
	}
}
