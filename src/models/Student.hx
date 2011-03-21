package models;
import basehx.BaseDbModel;
import models.Parent;

class Student extends BaseDbModel 
{
	public var id:Int;
	public var username:String;
	public var firstName:String;
	public var lastName:String;
	public var familyID:Int;
	public var categoryID:Int;
	public var category:StudentCategory;
	public var family:Family;
	public var parents(getter_parents,null):List<Parent>;
	public function getter_parents() 
	{
		return Parent.manager.search({familyID: this.familyID});
	}
	public var classes(getter_classes,null):List<SchoolClass>;
	public function getter_classes() 
	{
		var list = new List();
		if(id != null) {
			var jList = SchoolClass_join_Student.manager.search({studentID: id});
			for (join in jList)
			{
				list.add(join.schoolClass);
			}
		}
		return list;
	}
	
	public static var manager = new basehx.DbManager<Student>(Student);
	
	public function new() 
	{
		super();
	}
	
	static function RELATIONS() 
	{
		return [{prop: "category", key: "categoryID", manager: StudentCategory.manager}];
	}
}
