<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed'); 
require_once(APPPATH.'third_party/modulemanager/include/Common.php');

interface ViewerHandler
{
    public function add_mainjsfile($jsfile);
    public function add_maincssfile($cssfile);
}

class Viewer implements ViewerHandler
{
	public $CI;
	protected $viewfile;
	protected $viewdata = array();
	protected $cssfilelist = array();
	protected $jsfilelist = array();
	protected $contentlist = array(); 
	
	function __construct($viewfile = "default_view" , $ahandler = null)
	{	
		$this->handler = $ahandler;
		$this->CI =& get_instance();			
		if (!isset($this->CI->viewdata))
			$this->CI->viewdata = array();
		
		$this->CI->load->helper('html');
		$this->CI->load->helper('form');
		$this->CI->load->helper('language');		
		
		$this->viewfile = $viewfile;					
		
		
		// viewdata for htmlheader and htmlfooter
		$this->viewdata["base_url"] = $this->CI->config->base_url();
		$this->viewdata["title"] = "title";
		$this->viewdata["cssfilelist"] =& $this->cssfilelist;
		$this->viewdata["jsfilelist"] =& $this->jsfilelist;		
		$this->init();
//		log_appdebug("Viewer creer :  ".get_class($this)." avec viewfile initial a $viewfile");
	}
	
	public function init()
	{
	}
	
	public function add_maincssfile($cssfile)
	{
		$this->add_cssfile($cssfile);
	}
	
	public function add_cssfile($cssfile)
	{
		log_appdebug( "(". basename(__FILE__).__LINE__ . ")"." ".get_class($this) . " -> " . __FUNCTION__ ."($cssfile)"." called ");
		$this->cssfilelist[$cssfile] = $cssfile;		
		if (!is_null($this->handler))
			$this->handler->add_maincssfile($cssfile);
	}
	
	public function merge_cssfilelist($cssfilelist)
	{		
		log_appdebug( "(". basename(__FILE__).__LINE__ . ")"." ".get_class($this) . " -> " . __FUNCTION__ ."()"." called ");
		
		$this->cssfilelist = array_merge($this->cssfilelist, $cssfilelist);
	}
	
	public function add_mainjsfile($jsfile)
	{
		$this->add_jsfile($jsfile);
	}
	
	public function add_jsfile($jsfile)
	{				
		$this->jsfilelist[$jsfile] = $jsfile;
		if (!is_null($this->handler))
			$this->handler->add_mainjsfile($jsfile);
	}
		
	public function merge_jsfilelist($jsfilelist)
	{		
		$this->jsfilelist = array_merge($this->jsfilelist, $jsfilelist);
	
	}
	
	public function set_content_array($anarray)
	{		
		if(!empty($anarray))
			foreach($anarray as $k => $v)
				$this->set_content($k,$v);
	}
	
	public function set_content_from_view($contentname, $view, $viewdata = array())
	{
		$this->set_content($contentname, $this->CI->load->view($view, $viewdata, true));
	}
	
	
	public function set_content($contentname, $contentvalue = "")
	{		
		if (is_object($contentvalue))
		{
			if ( $contentvalue == $this)
			{
				show_error("loop detected dans un $this->modulename pour un $contentname de type ".get_class($contentvalue));
				exit();
			}
		}
		$this->contentlist[$contentname] = $contentvalue;
		
	}
	
	
	public function prepare_viewdata()
	{
		log_appdebug( "(". basename(__FILE__).__LINE__ . ")". " " . get_class($this) . " -> " . __FUNCTION__ ." called");
		log_appdebug(  " " . get_class($this) ." -> viewfile = ".$this->viewfile);
	}
	
	public function view()
	{
		log_appdebug( "(". basename(__FILE__).__LINE__ . ")". " " . get_class($this) . " -> " . __FUNCTION__ ." called ");
		
		$this->prepare_viewdata();
		$this->prepare_contentviewdata();
		$this->CI->load->view('htmlheader', $this->viewdata);
		$this->CI->load->view($this->viewfile, $this->viewdata);
		$this->CI->load->view('htmlfooter', $this->viewdata);
	}
	
	public function rawview()
	{		
		$this->prepare_viewdata();
		$this->prepare_contentviewdata();
		$this->CI->load->view($this->viewfile, $this->viewdata);
	}
	
	public function prepare_contentviewdata()
	{		
		log_appdebug( "(". basename(__FILE__).__LINE__ . ")". " " . get_class($this) . " -> " . __FUNCTION__ ." called");

		if (!empty($this->contentlist))
			foreach ($this->contentlist as $contentname => $contentvalue)
			{
				if (is_object($contentvalue))
					$this->viewdata[$contentname] = $contentvalue->get_renderedview();					
				else	
					$this->viewdata[$contentname] = $contentvalue;	
			}
	}
	
	public function rawviewasdata()
	{		
		$this->prepare_viewdata();		
		$this->prepare_contentviewdata();
		$result =  $this->CI->load->view($this->viewfile, $this->viewdata, true);
		return $result;
	}
	
	public function get_renderedview() 
	{
		return $this->rawviewasdata();
	}

}
