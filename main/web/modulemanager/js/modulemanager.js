
'use strict';
 function debuglog(data)
{
   console.log(data);
};	

function executeFunctionByName(functionName, context /*, args */) 
{
	var args = Array.prototype.slice.call(arguments, 2);
	var namespaces = functionName.split(".");
	var func = namespaces.pop();
	for (var i = 0; i < namespaces.length; i++) 
	{
		context = context[namespaces[i]];
	}
	if (typeof  context[func] == 'undefined')
		debuglog(functionName+" is not defined");
	return context[func].apply(context, args);
};
	
function parseallfloat(data)
{
	var transformeddata = data;
	transformeddata = data.replace(",",".");
	var result = parseFloat(transformeddata);
	return result;
};


function reload_ajaxview_by_selector(ajaxview, selector,  callback, additionaldata)
{
	debuglog("call reload_ajaxview_by_selector : "+ajaxview+ " . with selector : ");
	debuglog(selector);
	$.get("index.php/main/index/ajaxview/"+ajaxview,additionaldata, 
		function reload_ajaxview_by_selector_ajaxcallback(data){		
			var dom = $("<div>").append($.parseHTML(data)).find(selector).html();
			$(selector).html(dom);					
			modulemanager.init_loadedelements(selector, callback);
		});			
};
	
function inner_load_ajaxview_in_selector(ajaxview, selector, callback, additionaldata)
{
	
	debuglog("call inner_load_ajaxview_in_selector : "+ajaxview+ " . with selector : "+ selector);
	$.get("index.php/main/index/ajaxview/"+ajaxview,additionaldata,
		function inner_load_ajaxview_in_selector_ajaxcallback(data){
			$(selector).html($.parseHTML(data));									
			modulemanager.init_loadedelements(selector, callback);
		});			
};	



function reload_ajaxrun_by_selector(ajaxrun, selector,  callback, additionaldata)
{
	debuglog("call reload_ajaxrun_by_selector : "+ajaxrun+ " . with selector : "+ selector);
	$.get("index.php/main/index/ajaxrun/"+ajaxrun,additionaldata, 
		function reload_ajaxrun_by_selector_ajaxcallback(data){
			var dom = $("<div>").append($.parseHTML(data)).find(selector).html();
			$(selector).html(dom);					
			modulemanager.init_loadedelements(selector, callback);
		});			
};
	
function inner_load_ajaxrun_in_selector(ajaxrun, selector, callback, additionaldata)
{
	
	debuglog("call inner_load_ajaxrun_in_selector : "+ajaxrun+ " . with selector : "+ selector);
	$.get("index.php/main/index/ajaxrun/"+ajaxrun,additionaldata,
		function inner_load_ajaxrun_in_selector_ajaxcallback(data){
			$(selector).html($.parseHTML(data));									
			modulemanager.init_loadedelements(selector, callback);
		});			
};	

var modulemanager = {
	
	
	zonetarget : {} , 
	setzonetarget : function(ajaxloader, target)
	{
		modulemanager.zonetarget[ajaxloader] = target;
	},	
	getzonetarget : function(ajaxloader)
	{
		if (typeof modulemanager.zonetarget[ajaxloader] == 'undefined')
			return "body";
		else
			return modulemanager.zonetarget[ajaxloader];
	},
	
	allcallbacks : {},
	addcallback : function(callbacklist, callback)
	{
		if (typeof modulemanager.allcallbacks[callbacklist] == 'undefined')
			modulemanager.allcallbacks[callbacklist] = $.Callbacks();
		modulemanager.allcallbacks[callbacklist].add(callback);
	},	

	init_loadedelements_callbacks : {},
	add_init_loadedelements_callback : function(callbacklist, callback)
	{
		if (typeof modulemanager.init_loadedelements_callbacks[callbacklist] == 'undefined')
			modulemanager.init_loadedelements_callbacks[callbacklist] = $.Callbacks();
		modulemanager.init_loadedelements_callbacks[callbacklist].add(callback);
	},	
	
	
	/*** init_loadedelements
	 initiate when loaded elements are loaded or re-loaded and ready
	 ***/
	init_loadedelements  : function(context, callback)
	{
		debuglog("init_loadedelements in context : "+context);
	
	
		$("form", context).each(function(index, value)
		{
			var theformmanager =  new modulemanager.FormManager($(value).attr('id'));			
			modulemanager.prepare_form_trait(theformmanager);
			modulemanager.formready(theformmanager);
			});
		
		// calling the callback if defined
		for (var cb in modulemanager.init_loadedelements_callbacks)	
				modulemanager.init_loadedelements_callbacks[cb].fire(context);
		
		if (typeof callback !== 'undefined') callback();	
	},
	
	FormManager : function (formid) {
		this.formid = formid;   // id of the form
		this.submitname = "";   // get the value of the last submit input used to post the form;
		this.validcallback = function(xmldata) {} ;
		this.invalidcallback = function(xmldata) {
			 console.log("invalidcallback of "+ this.formid);
		} ;
	},
	/***
	 Generic Form traits 
	 ***/ 
	formready : function(theformmanager)
	 {
		  console.log("call formready : "+theformmanager.formid);
		   $('input[type="submit"]', "#"+theformmanager.formid).off("click");
		   $('input[type="submit"]', "#"+theformmanager.formid).click(
				function clicksubmit(evt) {
					 console.log(theformmanager.formid + " submitting! " );
					if (typeof theformmanager.submitspecific !== 'undefined')
					{
						 console.log ('a specific submit function will be called');
						theformmanager.submitspecific(evt, this.name, this.value);
					}
					else
					{
						evt.preventDefault(evt);
						modulemanager.formsend(evt, theformmanager,this.name, this.value);
					}
				}			
			);
	 },
	 
	 
	 
	 formsend : function(evt, theformmanager, submitname, submitvalue,additionalpostdata)
	 { 
	 	//exec_afteruserchecked(function()
		//{
			var formid = theformmanager.formid;
			console.log("call formsend : "+formid + " : " + submitvalue);			
			//$("#"+formid+submitname).prop("disabled", true);
			$("#"+formid+"submitbutton").after('<img id="'+formid+'patienceloader" class="patienceloader" src="web/images/ajax-loader.gif">');
			$("#"+formid+"patienceloader").css('height', $("#"+formid+"submitbutton").height());
			// $("#"+formid+"submitbutton").remove();
			var unhashedpasswords = [];
			$('input[id^="'+formid+'"][type="password"]').each(
				function(index, value)
				{ 
					unhashedpasswords[index] =  $(value).val();
					var hashedpassword = "";
					var anUpperCase = /[A-Z]/;
					var aLowerCase = /[a-z]/; 
					var aNumber = /[0-9]/;
					if (unhashedpasswords[index].length < 8
						|| unhashedpasswords[index].search(anUpperCase) == -1 
						|| unhashedpasswords[index].search(aLowerCase) == -1 
						|| unhashedpasswords[index].search(aNumber) == -1 
						)  
					{
						hashedpassword = "e";
					}
					else
						hashedpassword = CryptoJS.SHA1(unhashedpasswords[index]);
					/*if ((unhashedpasswords[index]).length  >= 8)
						hashedpassword = CryptoJS.SHA1(unhashedpasswords[index]);
					else 
						hashedpassword = "e";
					*/ 
					$(value).val(hashedpassword);
				} 
			);
			var submitdata = new Object();
			submitdata[submitname] = submitvalue;
			submitdata["formid"] = formid;
			if (!(typeof additionalpostdata === 'undefined'))
			{
				for(var i= 0; i < additionalpostdata.length; i++)
				{
				
					if (!(typeof additionalpostdata[i][0] === 'undefined'))
					{
						// console.log("with additionnal : " + additionalpostdata[i][0] +" : "+additionalpostdata[i][1]);
						submitdata[additionalpostdata[i][0]] = additionalpostdata[i][1];
					}
				}
			}
					
			var options = {
				data : submitdata,	
				beforeSubmit : function() {console.log(submitdata);	return true;},
				success: function(data)
					{
						console.log('form ajaxsubmit success : ' + formid);
						$('input[id^="'+formid+'"][type="password"]').each(
							function(index, value)
							{ 
								$(value).val(unhashedpasswords[index]);
							} 
							);
						theformmanager.submitname = submitname;
						modulemanager.formresult(theformmanager,data);
					},
				async: true
			};
			
			$("#"+formid).ajaxSubmit(options);		
		//});
		return false;
	},
	 
	/** specific submit function for image**/
	formsendimage : function (evt, theformmanager, submitname, submitvalue)
	 {
		exec_afteruserchecked(function()
		{
			var formid = theformmanager.formid;
			console.log("call formsendimage : "+formid + " : " + submitvalue);
			$("#"+formid+"submitbutton").after('<img id="'+formid+'patienceloader" class="patienceloader" src="web/images/ajax-loader.gif">');
			$("#"+formid+"patienceloader").css('height', $("#"+formid+"submitbutton").height());
			var submitdata = new Object();
			submitdata[submitname] = submitvalue;
			submitdata["formid"] = formid;
			var options = {
				data : submitdata,
				beforeSubmit : 
				function() {
				
					console.log("beforeSubmit file  : ")
					var maxfilesize = 120;
					console.log($("#"+formid+"userfile"));
					console.log($("#"+formid+"userfile")[0].files[0].size);
					if (typeof $("#"+formid+"userfile")[0].files[0].size !== "undefined")
					if ($("#"+formid+"userfile")[0].files[0].size  > (maxfilesize * 1024) )
					{
						$("#progressbar").html("Transfert : La taille du fichier ne doit pas dépasser " + maxfilesize + " Ko.");	
						return false;					
					}
				},
				uploadProgress: function(event, position, total, percentComplete)
				{
					$("#progressbar").html("Transfert : " + percentComplete + '%');					
				},
				success: function(data)
					{
						console.log('form ajaxsubmit success : ' + formid);
						theformmanager.submitname = submitname;
						formresult(theformmanager,data);
					},
				async: true
			};
			$("#"+formid).ajaxSubmit(options);	
		});
	 },
	 
	 formresult : function (theformmanager, data)
	 {
			 console.log("call formresult");
			/*FIXME if data are invalid then reload the form errorlabelled and call invalidcallback
			else reload the form original  and go for the validcallback */ 
			
			var xmldata = $($.parseXML(data));
			var formresult = xmldata.children("formresult");	
			var statusresult = formresult.children("status").text();
			var dataformid = formresult.children("formid").text();
			
			 console.log("statusresult :		  "+statusresult);
			 console.log("dataformid :            "+dataformid);
			 console.log("theformmanager.formid : "+theformmanager.formid);
			if (statusresult === "INVALID") 
			{					
				// console.log("text that replace : "+formresult.children("errorlabeledform").text());
				$("#"+theformmanager.formid).replaceWith(formresult.children("errorlabeledform").text());
				theformmanager.formid = formresult.children("formid").text();				
				modulemanager.prepare_form_trait(theformmanager);
				modulemanager.formready(theformmanager);
				modulemanager.init_loadedelements("#"+theformmanager.formid);
				theformmanager.invalidcallback(xmldata);
			} 
			else if (statusresult === "VALID") 
			{											
				
				// console.log("text that replace : "+formresult.children("errorlabeledform").text());
				$("#"+theformmanager.formid).replaceWith(formresult.children("originalform").text());
				theformmanager.formid = formresult.children("formid").text();
				modulemanager.prepare_form_trait(theformmanager);
				modulemanager.formready(theformmanager);
				modulemanager.init_loadedelements("#"+theformmanager.formid);
				theformmanager.validcallback(xmldata);
				
			}
			else 
			{
				 console.log("call formresult error");
			}
	 },
	 
	/** 
	prepare forms trait
	**/ 
	prepare_form_trait :function (theformmanager)
	{
		 console.log("call prepare_form_trait pour : "+ theformmanager.formid);
		if(!(typeof theformmanager.formid === 'undefined'))
		{
			var formclass = $("#"+theformmanager.formid).attr('class') ;
			console.log("determination de la classe  :" +	formclass );
			executeFunctionByName("prepare_form_trait_"+formclass, window, theformmanager);				
		}
	},
	
	
	ajaxaction : function(ajaxurl, callbacksname, callback)
	{
		
		$.ajax({
				url: "index.php/main/index/"+ajaxurl,
				complete :
					function(data)
					{
						if (typeof modulemanager.allcallbacks[callbacksname] !== 'undefined')
							modulemanager.allcallbacks[callbacksname].fire();
					}
				});
		if(!(typeof callback === 'undefined'))
			callback();
	},

	main : function()
	{	
	
	/**************************************************************************
     ***  Initialisation when dom is ready 
	 *** (equivalent to $(document).ready(function (...)) )
	 ***  more about ready function :  http://api.jquery.com/ready/
     *************************************************************************/
    $(function() {	
		
		console.log("DOM loaded." );
		console.log("modulemanager : main called." );
		//debuglog("Disable caching of AJAX responses");
		$.ajaxSetup ({cache: false , async : true });

		modulemanager.init_loadedelements("body");	
		console.log("modulemanager : Ready ...");
	});
	return;
	}  // close main function
}; // close namespace
//
//modulemanager.main();
console.log("modulemanager : javascript loaded." );

/** End of files */