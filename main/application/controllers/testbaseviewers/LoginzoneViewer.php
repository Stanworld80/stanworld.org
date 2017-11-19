<?php 

class LoginzoneViewer extends Viewer
{	
	 function init()
	 {
		 $this->viewfile = "loginzone.php";		 
		 require_once(APPPATH.'controllers/testbaseviewers/WelcomezoneViewer.php');		
		 
		 $theviewer = new WelcomezoneViewer("", $this);
		 $this->set_content("welcomemsg", $theviewer);
		 $this->add_cssfile("web/css/loginzonedefault.css");		
		
	 }
} 