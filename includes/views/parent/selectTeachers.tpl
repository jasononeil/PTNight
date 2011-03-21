<p>Please select which teachers you would like to book interviews with.</p>
<form method="post" action="{Controller.URL}/bookings/">
<fieldset>
<hxLoop name="child">
<h3>{child.firstName} {child.lastName} ({category})</h3>
<table class="checkbox zebra">
	<hxLoop name="class">
	<tr>
		<td>
		<!-- These should be a switch, but they're not recursing right -->
		<hxLoop name="checkboxChecked"><input type="checkbox" name="teacher[]" id="teacher{class.id}" value="{child.id},{parentID},{class.id}" checked="yes" /></hxLoop>
		<hxLoop name="checkboxUnchecked"><input type="checkbox" name="teacher[]" id="teacher{class.id}" value="{child.id},{parentID},{class.id}" /></hxLoop>
		</td>
		<td><label for="teacher{class.id}">{teacher.firstName} {teacher.lastName}</label></td>
		<td><label for="teacher{class.id}">{class.className}</label></td>
	</tr>
	</hxLoop>
</table>
</hxLoop>
<input type="submit" value="Next" class="button" /></fieldset>
</form>