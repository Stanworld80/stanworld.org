<?php 

if ( ! defined('BASEPATH')) exit('No direct script access allowed'); 

require_once(APPPATH.'third_party/modulemanager/include/Common.php');
require_once(APPPATH.'third_party/modulemanager/libraries/Viewer.php');
require_once(APPPATH.'third_party/modulemanager/libraries/ModuleViewer.php');
require_once(APPPATH.'third_party/modulemanager/libraries/ModuleController.php');

class Moduleloader extends  ModuleController
{
	public $modulecontrollers  = array();
	public $maincssfilelist = array();
	public $mainjsfilelist = array();
	protected $default_content = NULL;
	protected $default_title = "title";
	
	
	public function __construct()
	{
		if (!defined('MODULEPATH') ) define('MODULEPATH',APPPATH."modules".DIRECTORY_SEPARATOR);
		
		$this->createlink(APPPATH.'third_party/modulemanager/web/js/modulemanager.js',APPPATH."../web/modulemanager/js/modulemanager.js");
		$this->createlink(APPPATH."third_party/modulemanager/web/js/jquery.form.js",APPPATH."../web/modulemanager/js/jquery.form.js");
		$this->createlink(APPPATH."third_party/modulemanager/web/js/sha1.js",APPPATH."../web/modulemanager/js/sha1.js");
	
		$this->add_mainjsfile("https://code.jquery.com/jquery.min.js");
		$this->add_mainjsfile("web/modulemanager/js/jquery.form.js");
		$this->add_mainjsfile("web/modulemanager/js/sha1.js");		
		$this->add_mainjsfile("web/modulemanager/js/modulemanager.js");
		
		parent::__construct($this);
		if (is_null($this->default_content))
			$this->default_content = $this->CI->load->view("default_content", $this->viewdata, true);
		
	}
	
	public 
	function add_maincssfile($cssfile)
	{		
		$this->maincssfilelist[$cssfile] = $cssfile;
	}
	
	public 
	function add_mainjsfile($jsfile)
	{		
		$this->mainjsfilelist[$jsfile] = $jsfile;
	}

	
	/***	run 
	***
	***/
	public
	function run(...$vars)
	{
		log_appdebug( "(". basename(__FILE__).__LINE__ . ")"." ".get_class($this) . " -> " . __FUNCTION__ ." called ");
		log_appdebug( "{");
		if (is_null($this->default_content))
			$this->default_content = $this->CI->load->view("default_content", $this->viewdata, true);
				
		$modulecontroller = $this;	
		if (count($vars) == 0)
			$arg1  = "index";
		else	
			$arg1 = array_shift($vars);
		
		$modulename = ucfirst($arg1);
		
		if (is_dir(MODULEPATH.$modulename))
		{			
			$modulefilename = MODULEPATH.$modulename."/application/controllers/".$modulename.".php";
			if (file_exists($modulefilename))
			{
				require_once($modulefilename);
				$modulecontroller = new $modulename($this);
			}
			else
			{
				show_error("module $modulefilename not found");
				exit();			
			}
			if (count($vars) > 0)
				$action = array_shift($vars);
			else	
				$action = "index";
		}
		else
			$action = $arg1;
		if (is_callable(array($modulecontroller, $action)))
			$modulecontroller->$action(...$vars);		
		else
		{			
			show_error(get_class($modulecontroller) ." -> $action is not callable");
			exit();
		}
		log_appdebug( "}");
	}
	
	public
	function get_viewer($view, $from = "", $bymodule = true)
	{
		log_appdebug( "(". basename(__FILE__).__LINE__ . ")"." ".get_class($this) . " -> " . __FUNCTION__ ."($view, $from)"." called ");
		log_appdebug("{");
		
		$this->CI->load->library("Viewer");

		
		$viewucfirst = ucfirst($view);		
		$viewerclass = 'Viewer';
		
		if ($bymodule)
		  $modulepath = MODULEPATH;
		else	
		  $modulepath = APPPATH;
				
		$viewucfirst = ucfirst($view);		
		$viewerclass = 'Viewer';
		
		$viewerfilefrom = $modulepath.ucfirst($from).'/application/controllers/viewers/'.$viewucfirst.'Viewer.php';
		$viewfilefrom =  $modulepath.ucfirst($from).'/application/views/'.$view.'.php';
	
		$viewerfile =  '/controllers/viewers/'.$viewucfirst.'Viewer.php';
		$viewfile   =  '/views/'.$view.'.php';
		if ($bymodule)
		{		
			$viewfile =  $modulepath.$viewucfirst."/application/".$viewfile;
			$viewerfile = $modulepath.$viewucfirst."/application/".$viewerfile;
		}
		else
		{
			$viewfile =  $modulepath.$viewfile;
			$viewerfile = $modulepath.$viewerfile;
		}
		
		$result = NULL;
		if (strcmp($from, "") !== 0) // there is a from defined , means there is a module specified
		{
			
			$from = ucfirst($from);
			log_appdebug("from defined : $from");
			if (file_exists($viewerfilefrom))
			{	
				log_appdebug("$viewerfilefrom  found as a Viewer Object in the module $from");
				$viewerclass = $viewucfirst.'Viewer';
				require_once($viewerfilefrom);
				$result = new $viewerclass("undefined",$this, $from );			
			}
			else if (file_exists($viewfilefrom))
			{					
				log_appdebug("$viewfilefrom  found as a View File in the module $from");
				$viewfile = $this->linkview($viewfilefrom,$from);				
				$result = new $viewerclass($viewfile, $this);
			}
			else
			{
				log_appdebug("not found :$viewerfilefrom ");
				log_appdebug("not found :$viewfilefrom ");
				log_appdebug("No viewerfile nor viewfile found in the $from module");
			}
		}
		if (is_null($result))
		{
			log_appdebug("No from defined");
			if (file_exists($viewerfile))
			{		
				$from = $viewucfirst;
				log_appdebug("$viewerfile found as a Viewer Object in his own module ");
				$viewerclass = $viewucfirst.'Viewer';
				require_once($viewerfile);
				$result = new $viewerclass("",$this);
			}
			else
			{	
				log_appdebug("$viewerfile not found");
				if (file_exists($viewfile))
				{					
					$from = $viewucfirst;
					log_appdebug("la vue \"$viewucfirst\" n'a pas de viewer specifique. mais a une view dans son propre module");
					$viewfile = $this->linkview($viewfile,$viewucfirst);
					$result = new  $viewerclass($viewfile,$this);
				}
				else
				{	
					log_appdebug("$viewfile not found");
					log_appdebug("la vue $viewucfirst n'existe pas");
					$errormsg = "Unable to do ".get_class($this) ." -> " . __FUNCTION__ ."($view, $from, $bymodule)"; 
					$errormsg .="\n $viewerfile n'existe pas \n  $viewfile n'existe pas";
					if (strcmp($from, "") !== 0)
						$errormsg .="\n $viewerfilefrom n'existe pas \n $viewfilefrom n'existe pas";
					log_appdebug($errormsg);					
					if ($bymodule)
						$result = $this->get_viewer($view, "", false);
					else
						$result = new  $viewerclass($view, $this);
				}
			}
			log_appdebug( "}");			
		}
		if (strcmp($from, "") !== 0)
		{
			$this->load($from);
		}			
		
		if (is_callable( array($this->CI, 'set_contentforviewer')))
			$this->CI->set_contentforviewer($result);
		$result->merge_cssfilelist($this->maincssfilelist);
		$result->merge_jsfilelist($this->mainjsfilelist);
		return $result;
	}
		
	function set_currentviewer( $param1 = "", $param2 = "")
	{	
		if (strcmp($param1, "") == 0) 
			$param1 = "default_view";
		if (strcmp($param2, "") == 0) 
			$this->currentviewer =  $this->get_viewer($param1, $param2);
		else
			$this->currentviewer =  $this->get_viewer($param2, ucfirst($param1));
		if ($param1 == "default_view")
		{
			$this->currentviewer->set_content("default_content", $this->default_content);
			$this->currentviewer->set_content("title",$this->default_title);
		}
	}
	
	function view($view = "default_view", $from = "")
	{			
	    $this->set_currentviewer($view, $from);
		$this->currentviewer->view();
	}

	
	function ajaxview($view = "default_view", $from = "")
	{
		$this->set_currentviewer($view, $from);
		$this->currentviewer->rawview();		
	}

	
	function ajaxrun(...$vars)
	{
		
		if ($this->CI->input->is_ajax_request())
		{
			$this->run(...$vars);
		}
	}
	
	function index()
	{
		$this->view();
	}

	public function set_defaultcontent($default_content)
	{
		$this->default_content = $default_content;
	}
	
	public function set_default_title($title)
	{
		$this->default_title = $title;
	}
	public function load($module)
	{ 
		$modulecontroller = null;
		$modulename = ucfirst($module);
		$modulefilename = MODULEPATH.$modulename."/application/controllers/".$modulename.".php";
		if (is_dir(MODULEPATH.$modulename))
		{					
			if (file_exists($modulefilename))				
			{
				if (!isset($this->modulecontrollers[$modulefilename]))
				{
					require_once($modulefilename);
					$this->modulecontrollers[$modulefilename] = new $modulename($this);
					log_appdebug(" $modulefilename  loaded");
				}
				else	
					log_appdebug(" $modulefilename  already loaded");
			}
			else
			{
				//show_error("module $modulefilename not found");
				//exit();
				$this->modulecontrollers[$modulefilename] = null;
			}
		}	
		else
		{
		//		show_error("moduledir $modulename not found");
		//		exit();
			$this->modulecontrollers[$modulefilename] = null;
		}
		return $this->modulecontrollers[$modulefilename];
	}
	
	
	public function ajaxformsubmit($module = "" , $formclass = "")
	{
		log_appdebug( get_class($this) . " -> " . __FUNCTION__ ." ($module , $formclass) called "); 
	
		if ($this->CI->input->is_ajax_request())
		{
			$formclass = ucfirst($formclass);
			log_appdebug( "ajaxsubmit call for formclass : $formclass"); 
			require_once(APPPATH.'modules/'.ucfirst($module).'/application/controllers/forms/'.$formclass.'.php');
			$thepost = $this->CI->input->post();
			if ($thepost['formid'])
				$id = $thepost['formid'];
			else
				$id = "";
			switch ($formclass) 
			{	
			/*	 case "Addtocartform" : 
					$theform = new $formclass($this, $id, $thepost["productid"]);
					break; 
				case "Confirmform" : 
					$theform = new $formclass($this, $id, $thepost["user_id"]);
					break;  */
				default :
					$theform = new $formclass($this, $id);			
					break;
			}
			
			$theform->submit($this->CI->input->post()); 
		}
		else
		{
			//	show_error( "(". basename(__FILE__)." ".__LINE__ . ") "."this is not a ajax request");
			//	exit();
		}
	}
}
