package models;
import models.BaseDbModel;

class Student extends BaseDbModel 
{
	public var id;
	public var username;
	public var firstName;
	public var lastName;
	public var familyID;
	public var categoryID;
	public var category;
	public var family;
	public var parents;
	public function getter_parents() {
		return Parent.manager.search({familyID: this.familyID});
	}
	public var classes;
	public function getter_classes() {
		list = new List();
		if(id != null) {
			jList = SchoolClass_join_Student.manager.search({"studentID": id});
			for (join in jList)
			{
				list.add(join.get_schoolClass());
			}
		}
		return list;
	}
	
	public static var manager = new hxbase.DbManager(Student);
	
	public function new() 
	{
		super();
	}
	
	static function RELATIONS() 
	{
		return new [{prop: "category", key: "categoryID", manager: StudentCategory.manager}]
	}
}
