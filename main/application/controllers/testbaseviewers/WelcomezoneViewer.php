<?php 

class WelcomezoneViewer extends Viewer
{	
	 function init()
	 {
		 $this->viewfile = "welcomezone.php";		
		 $this->set_content("username", "Stanislas Selle");
		 $this->add_cssfile("web/css/welcomezonedefault.css");
	 }
} 