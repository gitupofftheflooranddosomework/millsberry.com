/****************  Millsberry jQuery Functions  ******************/

var gmi_isDocumentReady = false;
var gmi_DialogLinkClass = 'jq_dialog_link';
var gmi_InputFieldClass = 'jq_input_field';
var gmi_LoginPopupID = 'login_popup';
var gmi_InputContainerID = 'input_container';
var gmi_initializedDialogWindows = new Array();

/**************** BEGIN Dialog Windows FUNCTIONS ******************/

/*
* Opens the Login Popup
*/
function loginPopupOn()
{
	openDialogWindow(gmi_LoginPopupID);
}

/*
* Closes the Login Popup
*/
function loginPopupOff()
{
	closeDialogWindow(gmi_LoginPopupID);
}

/*
* Opens any Dialog Window, and initializes it if necessary
*
* @param	dlg_window_id	The #ID of the Dialog Window
*
*/
function openDialogWindow(dlg_window_id)
{
	
	$("div.dialogWindow").each(function(){closeDialogWindow(this.id);})
	
	if(vIE() < 7 && vIE()>=5){
		$("select").css("visibility","hidden");
	}
	
	
	
	var pos = getDialogPosition(dlg_window_id);
	initDialogWindow(dlg_window_id);
	$('#' + dlg_window_id).dialog('option', 'position', pos );
	$('#' + dlg_window_id).dialog('open');
}

/*
* Closes any Dialog Window
*
* @param	dlg_window_id	The #ID of the Dialog Window
*
*/
function closeDialogWindow(dlg_window_id)
{
	if(vIE() < 7 && vIE()>=5){
		$("select").css("visibility","visible");
	}
	if ( isDialogWindowInitialized(dlg_window_id) )
	{
		$('#' + dlg_window_id).dialog('close');
	}
}

function vIE(){return (navigator.appName=='Microsoft Internet Explorer')?parseFloat((new RegExp("MSIE ([0-9]{1,}[.0-9]{0,})")).exec(navigator.userAgent)[1]):-1;}

/*
* Tells if a Dialog Window is initialized
*/
function isDialogWindowInitialized(dlg_window_id)
{
	return ( jQuery.inArray(dlg_window_id, gmi_initializedDialogWindows) >= 0 );
}

/*
* Initializes a Dialog Window
*/
function initDialogWindow(dlg_window_id)
{
	var successful = false;

	if ( !isDialogWindowInitialized(dlg_window_id) )
	{
		// Get the Dialog Window
		var dlg_window = $("#" + dlg_window_id);
		
		// If found, we'll set the functionality for it
		if (dlg_window)
		{
			
			
			// Create an empty Object that will hold any necessary Dialog Button
			var dlg_buttons = new Object();
			
			// Find any Input-Hidden elements in the Dialog Window
			var temp_hidden_inp = $('input[type=hidden]', dlg_window).each( function()
			{
				var temp_classes = $(this).attr( 'class' ).split(' ');

				// Iterate the list of CSS Classes of the Hidden Inputs and process any necessary Dialog Buttons
				for ( var j = 0; j < temp_classes.length; j++ )
				{	
					// If the current class is a Dialog Button try to add it
					if( temp_classes[j].indexOf( "dlg_button", 0 ) != -1 )
					{
						// Get the Dialog Button text
						var dlg_button_text = $(this).val();

						// Try to get the JS Function name that will be triggered when the Dialog Button is clicked
						var _fn_name = '';
						var _fn_index = temp_classes[j].indexOf( "-" );
						if ( _fn_index != -1 ) // If JS Function is found...
						{
							if (temp_classes[j].substring( _fn_index + 1 ) != '')
							{
								_fn_name = temp_classes[j].substring( _fn_index + 1 ) + '()';
								alert("_fn_name: "+_fn_name);
							}
						}
						eval('dlg_buttons[dlg_button_text] = function() { '+ _fn_name +'; $(this).dialog("close"); }');
					}
				}
			});

			// Initialize the Dialog Window to the Dialog Link
			var dlg_width = dlg_window.css('width') ? dlg_window.css('width') : '400';
			dlg_width = (dlg_width.indexOf('px') == dlg_width.length - 2) ? parseInt(dlg_width) : dlg_width;

			var dlg_height = dlg_window.css('height') ? dlg_window.css('height') : 'auto';
			dlg_height = (dlg_height.indexOf('px') == dlg_height.length - 2) ? parseInt(dlg_height) : dlg_height;

			var dlg_modal = dlg_window.hasClass('dlg_modal') ? true : false;

			dlg_window.dialog({
				autoOpen: false,
				width: dlg_width,
				height: dlg_height,
				modal: dlg_modal,
				resizable: false
			});
			dlg_window.dialog('option', 'buttons', dlg_buttons );
			
			//Remove title bar
			dlg_window.dialog().parents(".ui-dialog").find(".ui-dialog-titlebar").remove();
			
			// Set it as initialized
			gmi_initializedDialogWindows.push(dlg_window_id);
			successful = true;
		}
	}
	else // Is already initialized
	{
		successful = true;
	}
	return successful;
}

/*
* Automatically binds "Dialog Links" with "Dialog Windows"
*
* The links should use the "jq_dialog_link" class and define
* its Dialog Window using a class in the format: "jq_dialog_win-MyDlgWindowId"
*
* Example: <a class="jq_dialog_link jq_dialog_win-help_window">Open</a>
* Where "help_window" is the ID of the Dialog Window.
*/
function initLinkAndDialogs()
{
	// Iterate the link of Dialog Links
	$('.' + gmi_DialogLinkClass ).each(function(i)
	{
		var _jq_win_token = "jq_dialog_win-";
		// Get Attached Dialog
		var _classes = $(this).attr( 'class' ).split(' ');
		for (var i in _classes)
		{
			// If a Dialog Window is found, initialize the Window and attatch it.
			if ( _classes[i].indexOf( _jq_win_token, 0 ) != -1 )
			{
				var dialog_window_id = _classes[i].substring( _classes[i].indexOf( "-" ) + 1 );
				if ( dialog_window_id && initDialogWindow( dialog_window_id ) )
				{
					$(this).click(function(){
						openDialogWindow(dialog_window_id);
						return false;
					});
				}
			}
		}
	});
}

/*
* Gets the appropriate position for a Dialog Window
* depending on its CSS positioning.
*/
function getDialogPosition(dlg_window_id)
{
	var dlg_win = $('#' + dlg_window_id);
	var dlg_left = dlg_win.css('left');
	var dlg_top = dlg_win.css('top');
	var w_width = $(window).width();
	var w_height = $(window).height();

	var pos_left = (parseInt(dlg_left) > 0) ? parseInt(dlg_left) : 'auto';
	if (dlg_left.indexOf('%') == dlg_left.length -1)
	{
		pos_left = Math.round(w_width / 100 * parseInt(dlg_left));
	}

	var pos_top = (parseInt(dlg_top) > 0) ? parseInt(dlg_top) : 'auto';
	if (dlg_top.indexOf('%') == dlg_top.length -1)
	{
		pos_top = Math.round(w_height / 100 * parseInt(dlg_top));
	}
	var result = new Array(pos_left, pos_top);
	return result;
}

/**************** END OF Dialog Windows FUNCTIONS ******************/

/*
* Handles the change of background for the input fields in a form
*/
	
function inputFieldsEffect(){
	// Iterate the input fields
	$('.' + gmi_InputFieldClass ).each(function(i)
	{
		$("input")
		.focus(function(){
			//remove alert
			var id = $(this).parents(".input_container").attr("id");
		    	manageInputContainerClasses(id, "input_container_active", "input_container_inactive");
		})
		.blur(function(){
			
			var id = $(this).parents(".input_container").attr("id");
			if (this.value != ""){
				$("#"+id).removeClass("input_container_error");
			}
	    	manageInputContainerClasses(id, "input_container_inactive", "input_container_active");
		});
	});        
}

/*
* Switches between 2 classes (active/inactive) for the div containing the input fields
*
* @param	id		The #ID of Input Container
* @param	classToAdd	The class we need to style the InputContainer
* @param	classToRemove	The current class, which we need to remove from the InputContainer
*
*/

function manageInputContainerClasses(id, classToAdd, classToRemove){
//	alert("switch: " + id);
	$('#' + id).addClass(classToAdd).removeClass(classToRemove);
}


/*
* Goes to a URL
*
* @param	url	The URL where the user will be redirected
*
*/
function redirectURL( url )
{
	window.location.href = url;
}


/*
* Calls a Function embedded in a SWF file.
*
* @param	selector	The jQuery "selector" to obtain the SWF object. Example: '#myId > object'
* @param	func		The name of the SWF Function to execute. Example: 'doSomething'
* @param	arg1		An optional argument to pass to the SWF function.
*/
function callSWFFunction( selector, func, arg1 )
{
	if ( gmi_isDocumentReady ) // Only proceed if the document is ready or it won't work
	{
		var swfID = $(selector).attr('id');
		var swfObj = document.getElementById( swfID );

		if ( swfObj ) // Only continue if we found an element using the passed "selector"
		{
			// Check if the function does exist with the current SWFObj
			eval('var isFunc = jQuery.isFunction(swfObj.' + func + ')');
			if (!isFunc) // If it doesn't work, try to get the object again, Mozilla's way
			{
				swfObj = document[swfID];
				// Check if the function does exist with the current SWFObj
				eval('var isFunc = jQuery.isFunction(swfObj.' + func + ')');
			}

			if (isFunc) // If the function does exist, call it
			{
				if (typeof arg1 == 'undefined')
				{
					eval('swfObj.' + func + '();');
				}
				else
				{
					eval('swfObj.' + func + '(arg1);');
				}
			}
		}
	}
}

/*custom radio buttons*/

function toggleradio(obj){
	if (obj.id){
		var rid=obj.id.replace("radiowrapper-","");
	}else if(obj.attr("id")){
		var rid=obj.attr("id").replace("radiowrapper-","");
	}
//	alert(rid);
	
	$(obj).parents(".entry").find(".customradio-wrapper-activated").addClass("customradio-wrapper-deactivated");
	$(obj).parents(".entry").find(".customradio-wrapper-activated").removeClass("customradio-wrapper-activated");
	
	$("#"+rid).attr("checked",true);
	$(obj).removeClass("customradio-wrapper-deactivated");
	$(obj).addClass("customradio-wrapper-activated");
		
}

/*gender selector for step 2*/
function pickgender(v){
	$("#buddy_gender_"+v).attr("checked",true);
	
	$("#gender-option-m").removeClass("option-m-activated").addClass("option-m-deactivated");
	$("#gender-option-f").removeClass("option-f-activated").addClass("option-f-deactivated");
	
	$("#gender-option-"+v).removeClass("option-"+v+"-deactivated").addClass("option-"+v+"-activated");
}

/*customize tabset logic*/
function setCustomizeTab(n){
	$("#customize-tabset").removeClass("customize-tabset-1").removeClass("customize-tabset-2");
	$("#customize-tabset").addClass("customize-tabset-"+n);
	
	$("#customize-tabset .tabs-body .option-1").css("display","none")
	$("#customize-tabset .tabs-body .option-2").css("display","none")
	$("#customize-tabset .tabs-body .option-"+n).css("display","block")
	
}

function toggleRollover(obj,v){
	if(v==1){
		pos = obj.style.backgroundPosition;
		//pos = $(obj).css("backgroundPosition");
		parts = pos.split(" ");
		//$(obj).css("backgroundPosition",parts[0]+" 143px");
		obj.style.backgroundPosition = parts[0]+" 154px";
//		alert(pos);
	}else{
//		pos = $(obj).css("backgroundPosition");
		pos = obj.style.backgroundPosition;
		parts = pos.split(" ");
//		$(obj).css("backgroundPosition",parts[0]+" 0px");
		obj.style.backgroundPosition = parts[0]+" 0px";
	}
}

function clearForm(form) {
  // iterate over all of the inputs for the form
  // element that was passed in
  $(':input', form).each(function() {
 var type = this.type;
 var tag = this.tagName.toLowerCase(); // normalize case
 // it's ok to reset the value attr of text inputs,
 // password inputs, and textareas
 if (type == 'text' || type == 'password' || tag == 'textarea')
   this.value = "";
 // checkboxes and radios need to have their checked state cleared
 // but should *not* have their 'value' changed
 else if (type == 'checkbox' || type == 'radio')
   this.checked = false;
 // select elements need to have their 'selectedIndex' property set to -1
 // (this works for both single and multiple select elements)
 else if (tag == 'select')
   this.selectedIndex = -1;
  });
};

$(document).ready(function(){
	gmi_isDocumentReady = true;
	initDialogWindow(gmi_LoginPopupID);
	initLinkAndDialogs();
	inputFieldsEffect();
	
	/*code to fix the submit with Enter on login form*/
	$('#login_popup input').keydown(function(e){
        if (e.keyCode == 13) {
            $(this).parents('form').submit();
            return false;
        }
    });

	/*initialize rollovers for congratulations dialog*/
	$("#reg_completed div.actionbtn").mouseover(function(){toggleRollover(this,1)})
	$("#reg_completed div.actionbtn").mouseout(function(){toggleRollover(this,0)})
    
});

jQuery.preloadImages = function()
{
  for(var i = 0; i<arguments.length; i++)
  {
    jQuery("<img>").attr("src", arguments[i]);
  }
}