package models;
import models.BaseDbModel;

class Interview extends BaseDbModel 
{
	public var id;
	public var parentID;
	public var studentID;
	public var classID;
	public var timeslotID;
	public var teacherID;
	public var parent;
	public var student;
	public var schoolClass;
	public var teacher;
	public var timeslot;
	
	public static var manager = new hxbase.DbManager(Interview);
	
	public function new() 
	{
		super();
	}
	
	static function RELATIONS() 
	{
		return new [{prop: "parent", key: "parentID", manager: Parent.manager}, 
					{prop: "student", key: "studentID", manager: Student.manager},
					{prop: "schoolClass", key: "classID", manager: SchoolClass.manager},
					{prop: "teacher", key: "teacherID", manager: Teacher.manager},
					{prop: "timeslot", key: "timeslotID", manager: Timeslot.manager}];
	}
}
