<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed'); 

class ModuleController
{
	protected $CI;
	public $viewdata = array();
	protected $handler;
	protected $modulename;
	
	function __construct($ahandler = NULL)
	{
		log_appdebug( "(". basename(__FILE__).__LINE__ . ")". " " . get_class($this) . " -> " . __FUNCTION__ ."  called");	
		$this->modulename = get_class($this);
		$this->CI =& get_instance();	
		$this->session =& $this->CI->session;		
		$this->handler = $ahandler;
		$this->init();		
	}
	
	public function init()
	{
	}
	
	function index()
	{		
	}
	
	public function set_webdir($path, $from = "")
	{
		if (strcmp($from, "") == 0) 	
			$from = $this->modulename;
		else
			$from = ucfirst($from);
		
		$linkcssfile = $this->createlink(  MODULEPATH.$from."/".$path,
							APPPATH."../web/bymodule/".$from);
		
	}
	public function add_modulecssfile($cssfile, $from = "")
	{	
		//log_appdebug( "(". basename(__FILE__).__LINE__ . ")". " " . get_class($this) . " -> " . __FUNCTION__ ." called");	
		if (strcmp($from, "") == 0) 	
			$from = $this->modulename;
		else
			$from = ucfirst($from);
		
		$linkcssfile = $this->createlink(  MODULEPATH.$from."/".$cssfile,
							APPPATH."../web/bymodule/".$from."/css/".basename($cssfile));		
//		$this->cssfilelist["web/bymodule/".$from."/css/".basename($cssfile)] = "web/bymodule/".$from."/css/".basename($cssfile);
		$this->handler->add_maincssfile("web/bymodule/".$from."/css/".basename($cssfile));
	}
	
	public function add_cssfile($cssfile, $from = "")
	{
		 $this->add_modulecssfile($cssfile, $from);
	}
	
	
	public function add_modulejsfile($jsfile, $from = "")
	{	
		//log_appdebug( "(". basename(__FILE__).__LINE__ . ")". " " . get_class($this) . " -> " . __FUNCTION__ ." called");	
		if (strcmp($from, "") == 0) 	
			$from = $this->modulename;
		else
			$from = ucfirst($from);
		
		$linkjsfile = $this->createlink(  MODULEPATH.$from."/".$jsfile,
							APPPATH."../web/bymodule/".$from."/js/".basename($jsfile));		
//		$this->jsfilelist["web/bymodule/".$from."/js/".basename($jsfile)] = "web/bymodule/".$from."/js/".basename($jsfile);
		$this->handler->add_mainjsfile("web/bymodule/".$from."/js/".basename($jsfile));
	}
	
	public function add_jsfile($jsfile, $from = "")
	{
		 $this->add_modulejsfile($jsfile, $from);
	}
		
	public
	function createlink($file, $link)
	{		
	//	log_appdebug( "(". basename(__FILE__).__LINE__ . ")"." ".get_class($this) . " -> " . __FUNCTION__ ." called ($file, $link) ");		
		if ((file_exists($file)) and (!file_exists($link)))
		{
			$dir = dirname($link);
			if (!is_dir($dir))
				mkdir($dir, 0777, true);
			log_appdebug("Création du lien  : ".$link . " -> " .$file );	
			symlink($file,$link);
			return $link;
		}		
	}
		
	public function linkview($viewfile, $module)
	{
		//log_appdebug( "(". basename(__FILE__).__LINE__ . ")"." ".get_class($this) . " -> " . __FUNCTION__ ." called ($viewfile, $module) ");		
		$viewmodulespath = APPPATH."third_party/modulemanager/views/modules";
		$linkdir = $viewmodulespath."/".$module;
		$linkfile = $linkdir."/".basename($viewfile);
		$this->createlink($viewfile, $linkfile);
		return "modules/".$module."/".basename($viewfile);
	}
	
	public function linkmodel($modelfile, $module)
	{
		//log_appdebug( "(". basename(__FILE__).__LINE__ . ")"." ".get_class($this) . " -> " . __FUNCTION__ ." called ($modelfile, $module) ");		
		$modelmodulespath = APPPATH."third_party/modulemanager/models/modules";
		$linkdir = $modelmodulespath."/".$module;
		$linkfile = $linkdir."/".basename($modelfile);
		$this->createlink($modelfile, $linkfile);
	}
	
	public function loadmodel($model, $module = "")
	{
		if (strcmp($module, "") == 0) 
		{			
			$module = $model;
			$model = $module."model";
		}
		$modelucfirst = ucfirst($model);		
		$modelfile = MODULEPATH. $module.'/application/models/'.$model.'.php';
		$this->linkmodel($modelfile, $module);
		$this->CI->load->model("modules/$module/$modelucfirst",$modelucfirst, TRUE);		
		$this->$modelucfirst =& $this->CI->$modelucfirst;
	}
	
	public function view( $view = "", $from = "")
	{
		if (($view == "") and ($from == ""))
		{
			$this->handler->get_viewer($this->modulename)->view();
		}
		else
		{
			if ($from == "")
				$from = $this->modulename;
			$this->handler->get_viewer($view,$from)->view();
		}
	}
	
	public function formview($form, $from = "",$asdata = false)
	{
		$formclass = ucfirst($form)."form";
		if (strcmp($from, "") == 0) 	
			$from = $this->modulename;
		else
			$from = ucfirst($from);
		require_once(MODULEPATH.$from."/application/controllers/forms/".$formclass.".php");
		$theform = new $formclass($this->handler);
		$theviewer = $this->handler->get_viewer("default_view");
		$theviewer->set_content("default_content",$theform->get_renderedview());
		if ($asdata)
			return $theviewer->get_renderedview();
		else
			return $theviewer->view();
	}
}
