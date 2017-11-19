<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Main extends CI_Controller {
	public function index(...$vars)
	{
		$this->load->add_package_path(APPPATH.'third_party/modulemanager');						
		$this->load->library('moduleloader');
		$homepageviewer = $this->moduleloader->get_viewer("homepage");
			
		$this->moduleloader->set_defaultcontent($homepageviewer);
		$this->moduleloader->set_default_title("Stanworld.org");
		$this->moduleloader->add_maincssfile("web/css/main.css");
		$this->moduleloader->view();
	}
}