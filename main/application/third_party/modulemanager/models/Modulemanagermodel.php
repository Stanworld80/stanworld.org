<?php

class Modulemanagermodel extends CI_Model 
{
	
	public function __construct()
	{
		$this->load->database();
		log_appdebug( "Construct MODEL database");
	}
}
