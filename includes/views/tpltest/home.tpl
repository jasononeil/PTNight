<h1>Template Testing</h1>
<h3>What is working?</h3>
<ul>
	<li>Are the text variable replacements working? <b>Yes</b></li>
	<li>For attributes too? <b>Yes</b></li>
	<li>hxVars defaulting? <b>Yes</b>, see the wiki dawg.</li>
	<li>hxVars? <b>Yes</b>, see the name above.</li>
	<li>hxIcnludes? <b>Yes</b>, this template is included.</li>
	<li>hxLoops? <b>Yes</b>, they loop, and recurse correctly.  Execution time is still a little non-optimal.  Maybe go back to parsing all loop xml at once somehow.</li>
	<li>hxSwitch? <b>Yes</b></li>
</ul>

<h5>Simple Variables</h5>
<p>My URL is <a href="{App.URL}">{App.URL}</a></p>

<h5>hxVar blocks</h5>
<p>Hello <hxVar name="name">stranger!</hxVar></p>
<p>Your job is <hxVar name="job">... i dunno!</hxVar></p>

<h5>The switch below is enabled</h5>
<hxSwitch name="showThis">
	<hxLoop name="show3times">	
	<p>See, I told you {name} was right!</p>
	</hxLoop>
</hxSwitch>

<h5>Whereas this switch is not enabled</h5>
<hxSwitch name="dontShowThis"><p>I could swear here and no one would know!</p></hxSwitch>

<h5>And some loops</h5>
<table>
	<hxLoop name="row">
	<tr>
		<hxLoop name="column">
		<td>{rowID}-{columnID}</td>
		</hxLoop>
	</tr>
	</hxLoop>
</table>
