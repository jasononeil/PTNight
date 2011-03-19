package models;
import models.BaseDbModel;

class Parent extends BaseDbModel 
{
	
	public var id;
	public var firstName;
	public var lastName;
	public var familyID;
	public var email;
	
	public var children;
	public function getter_children() 
	{
		return Student.manager.search({familyID: this.familyID});
	}
	
	public var interviews;
	public function getter_interviews() 
	{
		return Interview.manager.search({parentID: id], false);
	}
	
	public static var manager = new hxbase.DbManager(Parent);
	
	public function new() 
	{
		super();
	}
}
