package models;
import basehx.BaseDbModel;

class SchoolClass extends BaseDbModel {
	public var id:Int;
	public var teacherID:Int;
	public var className:String;
	public var students(getter_students,null):List<Student>;
	public function getter_students() {
		var list = new List();
		if(id != null) 
		{
			var jList = SchoolClass_join_Student.manager.search({classID: id});
			for (join in jList)
			{
				list.add(join.student);
			}
		}
		return list;
	}
	public var interviews(getter_interviews,null):List<Interview>;
	public function getter_interviews() {
		return Interview.manager.search({classID: id});
	}
	
	public var teacher(dynamic,dynamic):Teacher;
	
	public static var manager = new basehx.DbManager<SchoolClass>(SchoolClass);
	
	public function new() 
	{
		super();
	}
	
	static function RELATIONS() 
	{
		return [{prop: "teacher", key: "teacherID", manager: Teacher.manager}];
	}
}
