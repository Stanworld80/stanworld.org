<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed'); 

class Form
{
	protected $title;
	protected $form_id = "";
	protected $form_action;
	protected $form_submittext;
	protected $formresult;
	protected $viewfile;
	protected $viewdata = array();
	protected $renderedview;
	protected $list_inputs = array();
	protected $list_errors = array();
	protected $successmessage = "Success";
	protected $handler;
	protected $global_model;
	public $session; 
	public $CI;
	public static $counter = 0;
	protected $modulename;
	
	public function __construct(&$ahandler, $id = "",  $from = "")
	{
		
		log_appdebug( get_class($this) . " -> " . __FUNCTION__ ." called ");
		
		$this->handler =& $ahandler;
		$this->CI =& get_instance();
		$this->session =& $this->CI->session;
		
		$this->CI->load->helper(array('form', 'url'));
		$this->CI->load->library('form_validation');
		$this->CI->form_validation->set_error_delimiters('', '');
//		$this->global_model = $this->handler->global_model;
		
		if ($from !== "")
			$this->modulename = $from;
		else		
			$this->modulename = get_class($this);
		
		if ($this->session->has_userdata('formcounter'))
			self::$counter = $this->session->userdata('formcounter') ;			
		self::$counter++;
		$this->session->set_userdata('formcounter',self::$counter);		
		
		$this->init($id);		
	}
	

	public function init($id)
	{
		log_appdebug( get_class($this) . " -> " . __FUNCTION__ ." called ");
		$this->viewfile = 'form.php';		
		
		$this->formresult = true;
		$this->form_class =  strtolower(__CLASS__);
		$this->form_submittext = "Valider";
		$this->form_id =  strtolower(__CLASS__);
		$this->form_action = 'main/index/ajaxformsubmit/'.$this->modulename."/".$this->form_id;
		$this->init_data();		// init specific class data 				
		if ($id == "")
			$this->form_id = $this->form_id . self::$counter;
		else
			$this->form_id = $id;
		foreach ($this->list_inputs as $key => &$input)
		{			
			if (!isset($input["id"]))
				$input["id"] =  $key;
			if (!isset($input["name"]))
				$input["name"] =  $input["id"];
			$input["id"] =  $this->form_id . $input["id"];
			if (isset($input["ci_rules"]))
				$this->CI->form_validation->set_rules($input["name"],$input["label"],$input["ci_rules"]);
		}
		
		$this->prepare_renderedview();
	}
	
		/*** init specific class data : herit this method 
		 to do a specific data initialization, general behavior is just nothing. ***/		 
	public function init_data()
	{
	
	}
	
	public function prepare_renderedview()
	{	
		$this->viewdata["formattributes"] = array("class" => $this->form_class, "id" => $this->form_id);
		$this->viewdata["formname"] = $this->form_class; //form is generic and named by the class
		$this->viewdata["formid"] = $this->form_id;
		$this->viewdata["formaction"] = $this->form_action;
		$this->viewdata["formresult"] = $this->formresult;
		$this->viewdata["submittext"] = $this->form_submittext;
		$this->viewdata["list_inputs"] = $this->list_inputs;
		
//		$this->renderedview = $this->CI->load->view($this->viewfile, $this->viewdata , true);
		$theviewer = $this->handler->get_viewer($this->viewfile,$this->modulename);
		$theviewer->set_content_array($this->viewdata);
		$this->renderedview = $theviewer->get_renderedview();
	}
	
	public function get_renderedview()
	{
		$this->prepare_renderedview();
		return $this->renderedview;
	}
	
	/***
	check function : 
		* set values to list_inputs from thepost 
		* check values with ci_rules
		* check values with callback methods
		* set the error message;
	***/
	public function check($thepost)
	{
		log_appdebug( get_class($this) . " -> " . __FUNCTION__ ." called ");
		$result = TRUE;
		if ($this->CI->form_validation->run())
			$result = TRUE;
		
		if (!empty($this->list_inputs))
			foreach ($this->list_inputs as &$value) 
			{	
				log_appdebug( get_class($this) . " -> " . __FUNCTION__ ." for  ".$value['name']);
				$value["validity"] = TRUE;
				if (!(array_key_exists($value['name'] ,$thepost)))
					if ($value['type'] === "checkbox")	
					{	
						log_appdebug( "checkbox not in the post. created with off value.");
						$thepost[$value['name']] = "off";
						$value['value'] = "off";
					}
						
						
				if (array_key_exists($value['name'] ,$thepost))
				{
					$value["value"] = $thepost[$value['name']];					
					if (!($this->CI->form_validation->error($value['name']) === ''))
					{
						$value["validity"] = FALSE;
						$result = FALSE;
						$value["errormessage"] = $this->CI->form_validation->error($value['name']);
						if ($value['type'] == 'password')
						{
							$value["errormessage"] = 'Mot de passe requis avec au moins 8 caractères dont au minimum  : 1 lettre majuscule, 1 lettre minuscule et 1 numéro';
						}
					}
					else
					{
						$methodname = array($this, 'check_'.$value['name']);
						log_appdebug("avec methode : ". 'check_'.$value['name']);
						if (is_callable($methodname))
						{
								log_appdebug("avec methode : ". 'check_'.$value['name']." callable");
							$value["validity"] = $methodname();
							if (!($value["validity"]))
								$result = FALSE;					
						}
					}
				}		
				//log_appdebug("avec valeur : ". $value['value'] . " => ". $result  ? 1 : 0);
			}
		return $result;
	}
	
	public function apply($thepost, $objid = null)
	{		
		
		log_appdebug(get_class($this) . " -> " . __FUNCTION__ ." called "); 
		log_appdebug("form_id  VALID: ".$this->form_id."\n"); 
		//log_appdebug( " list_inputs-> ",$this->list_inputs); 
		echo '<?xml version="1.0" encoding="UTF-8" ?>';
		echo '<formresult><status>VALID</status>';
		echo '<formid>';
		echo $this->form_id;
		echo '</formid>';
		if (!is_null($objid))
		{
			echo '<objid>';
			echo $objid;
			echo '</objid>';
		}
		echo '<originalform><![CDATA[';
		echo $this->get_renderedview();
		echo ']]></originalform>';
		echo '</formresult>';
	}
	
	public function display_error()
	{
		log_appdebug(get_class($this) . " -> " . __FUNCTION__ ." called "); 
		log_appdebug("form_id  INVALID : ".$this->form_id."\n"); 
		echo '<?xml version="1.0" encoding="UTF-8" ?>';
		echo '<formresult><status>INVALID</status>';
		echo '<formviewfile>';
		echo $this->viewfile; 
		echo '</formviewfile>';
		echo '<formid>';
		echo $this->form_id;
		echo '</formid>';
		echo '<errorlabeledform><![CDATA[';
		echo $this->get_renderedview();
		echo ']]></errorlabeledform>';
		echo '</formresult>';
	}
	
	public function submit($thepost)
	{
		log_appdebug( get_class($this) . " -> " . __FUNCTION__ ." called ");
		log_appdebug("form_id  : ".$this->form_id); 
		log_appdebug("post[form_id]  : ".$thepost['formid']); 
		/* if ($thepost['formid'])
		{
			$this->form_id = $thepost['formid'];
			// FIXME :: changer aussi les inputs
		} */
		$this->formresult = $this->check($thepost); 
		if ($this->formresult)
			$this->apply($thepost);
		else
		{
			$this->prepare_renderedview();
			$this->display_error(); 
		}
	}
}