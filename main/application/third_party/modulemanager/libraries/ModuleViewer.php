<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed'); 

class ModuleViewer extends Viewer
{
	protected $modulename;
	protected $viewfile;
	
	function __construct($viewfile = "default_view", $ahandler, $from = "")
	{		
		
		if ($from !== "")
			$this->modulename = $from;
		else
			if ((strlen(get_class($this)) > 6))
				$this->modulename = substr(get_class($this) , 0, -6);
			else	
				$this->modulename = get_class($this);
		
		//if ($viewfile == "undefined") //FIXME : should test the file existence of modulename.php
		//	$viewfile = $this->modulename;
			
		parent::__construct($viewfile, $ahandler);
		
	
		$linkcssfile = $this->handler->createlink(  APPPATH.'third_party/modulemanager/web/css/moduleloaderdefault.css',
							APPPATH."../web/bymodule/ModuleViewer/css/moduleloaderdefault.css");				
		$this->handler->add_maincssfile("web/bymodule/ModuleViewer/css/moduleloaderdefault.css");
	
	
	}
	
	public function init()
	{
		$this->set_viewfile($this->viewfile);		
	}
	
	public function prepare_contentviewdata()
	{		
		parent::prepare_contentviewdata();
		$this->viewdata = array_merge(	$this->viewdata, $this->handler->viewdata);
	}
	
	public function set_viewfile($viewfile, $from = "")
	{
		//log_appdebug( "(". basename(__FILE__).__LINE__ . ")". " " . get_class($this) . " -> " . __FUNCTION__ ."($viewfile, $from) called");
		
		if (strcmp($from, "") == 0) 	
			$from = $this->modulename;
		else
			$from = ucfirst($from);
		if (strcmp($viewfile, "default_view") == 0) 	
			$this->viewfile  = "default_view";	
		else
			$this->viewfile  = '/modules/'.$from.'/'.$viewfile;
		
		if (substr(basename($viewfile),-4) !== ".php")
				$viewfile  = $viewfile . ".php";
		$this->handler->linkview(MODULEPATH.$from."/application/views/".$viewfile,$from);
	}
	
	public function add_modulecssfile($cssfile, $from = "")
	{	
		//log_appdebug( "(". basename(__FILE__).__LINE__ . ")". " " . get_class($this) . " -> " . __FUNCTION__ ." called");	
		if (strcmp($from, "") == 0) 	
			$from = $this->modulename;
		else
			$from = ucfirst($from);
		$this->cssfilelist["web/bymodule/".$from."/css/".basename($cssfile)] = "web/bymodule/".$from."/css/".basename($cssfile);		
		$this->handler->add_cssfile($cssfile, $from);
	}
	
	public function add_cssfile($cssfile)
	{
		 $this->add_modulecssfile($cssfile);
	}
	
	
	public function add_modulejsfile($jsfile, $from = "")
	{	
		//log_appdebug( "(". basename(__FILE__).__LINE__ . ")". " " . get_class($this) . " -> " . __FUNCTION__ ." called");	
		if (strcmp($from, "") == 0) 	
			$from = $this->modulename;
		else
			$from = ucfirst($from);		
		$this->jsfilelist["web/bymodule/".$from."/js/".basename($jsfile)] = "web/bymodule/".$from."/js/".basename($jsfile);
		$this->handler->add_jsfile($jsfile, $from);
	}
	
	public function add_jsfile($jsfile)
	{
		 $this->add_modulejsfile($jsfile);
	}	
	
	
	public function get_formview($form,  $from = "")
	{		
		if (strcmp($from, "") == 0) 	
			$from = $this->modulename;
		else
			$from = ucfirst($from);
		return $this->handler->formview($form, $from, true);
	}
	
	public function get_viewer($view, $from = "", $bymodule = true)
	{
		if (strcmp($from, "") == 0) 	
			$from = $this->modulename;
		else
			$from = ucfirst($from);
		return $this->handler-> get_viewer($view, $from, $bymodule);
	}

	public function set_content_from_viewer($contentname, $view, $from = "")
	{
		$this->set_content($contentname, $this->get_viewer($view, $from));	
	}
}
