<p>First, can we get your name and email.  If you've been here before you can use your details from last time.</p>

<hxLoop name="existingParent">
	<form method="post" action="{Controller.URL}/updateparent/{parent.id}/">
	<fieldset>
		<label for="first_{parent.id}">Your first name:</label>
		<input type="text" id="first_{parent.id}" name="first" value="{parent.firstName}" />

		<br /><label for="last_{parent.id}">Your last name:</label>
		<input type="text" id="last_{parent.id}" name="last" value="{parent.lastName}" />

		<br /><label for="email_{parent.id}">Your email address (optional):</label>
		<input type="text" id="email_{parent.id}" name="email" value="{parent.email}" />
		<br />
		<input type="submit" value="That's Me >>" class="button next" />
	</fieldset>
	</form>
</hxLoop>
<form method="post" action="{Controller.URL}/newparent/">
<fieldset>
	<label for="first">Your first name:</label>
	<input type="text" id="first" name="first" />

	<br /><label for="last">Your last name:</label>
	<input type="text" id="last" name="last" />

	<br /><label for="email">Your email address (optional):</label>
	<input type="text" id="email" name="email" />
	<br />
	<input type="submit" value="Add Me >>" class="button next" />
</fieldset>
</form>