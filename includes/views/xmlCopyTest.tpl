<html>
<h1>This is my {pageName}</h1>
<hxSwitch name="info">
	<h2>Infos</h2>
	<ul>
		<li>Infos #1</li>
		<li>Infos #2</li>
		<li>Infos #3</li>
		<li>Infos #4</li>
	</ul>
</hxSwitch>
<hxLoop name="list">
<h3>{listID}</h3>
<ul>
	<hxLoop name="listItem">
	<li>List item {listID}:{itemID}<hxSwitch name="even">
	<br />Did you know this is an even number?</hxSwitch></li>
	</hxLoop>
</ul>
</hxLoop>
</html>