startList = function() 
	{
	if (document.all && document.getElementById)
		{
		navRoot = document.getElementById("main_menu");
		for (i=0; i<navRoot.childNodes.length; i++) 
			{
			
			node = navRoot.childNodes[i];
			if (node.nodeName=="LI") 
				{
				node.onmouseover=function() 
					{
					this.className+=" over";
					}
				node.onmouseout=function() 
					{
					this.className=this.className.replace
					(" over", "");
					}
				}
			}
		}
	}
	
resizeWall = function() 
	{
	var height = document.getElementById('submenu').offsetHeight + 12;
	document.getElementById('retaining_wall_left_filler').style.height = height + "px";
	}
	
	
onLoadLauncher = function()
	{
	startList(); // makes ie6 do the rollovers properly.
	//resizeWall(); // resizes the retaining wall
	}
	
window.onload=onLoadLauncher;
