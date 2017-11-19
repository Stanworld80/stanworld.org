<?php
defined('BASEPATH') OR exit('No direct script access allowed');

if ( ! function_exists('log_appdebug'))
{
	function log_appdebug($message, $var = null)
	{
		static  $tabcount = 0;

		$msg = $message;
		
		if ((strcmp($message, "}") == 0) and ($tabcount > 0))
			$tabcount--;
		
		if ($tabcount > 0)
		{
			$msg = " ". $msg;
			for($i = 0; $i < $tabcount;$i++)
			 $msg = "   ". $msg;
		}
		
		if (strcmp($message, "{") == 0)
			$tabcount++;


		static $prev = NULL;
		
		if ($prev === NULL)
		{
			$prev = $_SERVER["REQUEST_URI"];			
			$msg = "FROM : ".$_SERVER["REQUEST_URI"] ."\n". $msg;
		}
			
		$lvl = "debug";

		if (!is_null($var))
			if (is_array($var))
				log_array($lvl, $msg, $var);
			else
			{
				$msg = $msg." ".$var;
				log_message($lvl,$msg);
			}
		else
			log_message($lvl,$msg);
	}
}

if ( ! function_exists('log_array'))
{
	function log_array($level, $message, $arr)
	{
		static $_log;

		if ($_log === NULL)
		{
			// references cannot be directly assigned to static variables, so we use an array
			$_log[0] =& load_class('Log', 'core');
		}
		if (!empty($arr))
			foreach ($arr as $key => $value )
			{
				if (is_array($value))
				log_array($level,  $message."{".$key."}:" , $value);
				else 
					$_log[0]->write_log($level, $message."(".$key." => ".$value.")");
			}
		else
			{
				$_log[0]->write_log($level, $message." : []");
			}
			
	}
}
?>