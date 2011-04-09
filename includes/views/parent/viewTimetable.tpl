<h2>{parent.firstName} {parent.lastName}</h2>
<hxLoop name="category">
<h3>{date}</h3>
<table class="zebra">
	<tr>
		<th>Time</th>
		<th>Teacher</th>
		<th>Class</th>
		<th>Child</th>
	</tr>
	<hxLoop name="interview">
	<tr>
		<td>{startTime}</td>
		<td><b>{teacher.firstName} {teacher.lastName}</b></td>
		<td>{class.className}</td>
		<td>{student.firstName}</td>
	</tr>
	</hxLoop>
</table>
</hxLoop>
<p>All interviews are scheduled for five minutes blocks.</p>
<p class="noprint"><a href="javascript:window.print()">Print</a></p>
<form>
<fieldset class="noprint">
	<input type="button" value="Switch Parent" class="button" onclick="location.href='{Controller.URL}/'" />
	<input type="button" value="Change Bookings" class="button left" onclick="location.href='{Controller.URL}/selectteachers/'" />
</fieldset>
</form>
