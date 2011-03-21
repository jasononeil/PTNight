<ul>
<hxLoop name="parent">
	<li>{parent.lastName}, {parent.firstName}
	<br /><small><a href="{Controller.URL}/viewparent/{parent.id}/">View timetable</a>
	| <a href="{Controller.URL}/customappointment/{parent.id}/">Custom Appointments</a></small></li>
</hxLoop>
</ul>