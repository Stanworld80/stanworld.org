<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed'); 

class ViewerContent
{
	protected $value;
	public $contentlist = array();
	protected $theloader;
	
	function __construct($aloader = NULL)
	{
		$this->theloader = $aloader;
	}

	function set_as_viewer($view, $from = "")
	{
		if ($from == "")
			$form = ucfirst($view);
		if (!is_null($this->theloader))
			$this->value = $this->theloader->get_viewer($view, $from);
	}
	
	
	function get_renderedview()
	{
	//	if ($this->type == "object")
	//		return $this->value->get_renderedview();
	//	else
	//		return $this->value;
	}
}
	