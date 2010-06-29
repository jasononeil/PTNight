package hxbase;
import hxbase.DbControl;

/** 
<b>Conventions</b>
<br />This model follows a few simple conventions
<ul>
	<li>The database details will already be defined in AppConfig.</li>
	<li>The database table will have the same name as this class.</li>
	<li>The primary id will be a column called 'id'.</li>
</ul>
Follow these and you'll be off to a good start.

<b>Various Variable Names</b>
<ul>
	<li>When you extend this class, you'll need to define a public 
	variable for each column in your table.</li>
	<li>Basic definitions are public and non-static, like:
	<br />public var name : String;</li>
	<li>How you know which type to use:
		<ul>
			<li>Int: TINYINT SHORT LONG INT24</li>
			<li>Float: LONGLONG, DECIMAL, FLOAT, DOUBLE</li>
			<li>Bool: TINYINT(1)</li>
			<li>Date: DATE, DATETIME</li>
			<li>String: <All Others> (note - BLOB can contain \0)</li>
		</ul>
	</li>
</ul>

<b>The Manager</b>
<ul>
	<li>You use the manager to perform searches and SELECT statements, basically</li>
	<li>You'll have to add this line right before the end of your class definition:
	<br />public static var manager = new php.db.Manager< MyModelName >(MyModelName);</li>
</ul>

<b>Relationships</b>
<ul>
	<li>I'm not sure how these are really done yet.
	There's a good chance I can't do this in a super
	class anyway, because RELATIONS() is a static field
	which cannot be inherited.</li>
	<li>But this would be a good place to give some instructions</li>
</ul>

<b>Automating this</b>

Boring!  Typing in all this stuff could probably be automated 
to be read directly from the database...

<b>Validation</b>

I'm still going to have to think about this

<b>General Usage</b>

Have a look at <a href="http://haxe.org/doc/neko/spod">the haxe SPOD tutorial</a>,
because that's what all this is based on.
*/
class BaseDbModel extends php.db.Object
{
	
}
