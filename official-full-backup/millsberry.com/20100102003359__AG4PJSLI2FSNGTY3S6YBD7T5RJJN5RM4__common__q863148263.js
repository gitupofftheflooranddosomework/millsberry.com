// Allows users to name their shortcuts
function addShortcut (to_url, default_title) {
    
	assign_title = default_title;
	var user_title = prompt ("What name do you want to give this link?","");
	if (user_title.length > 0) {
		assign_title = base64_encode( utf8_encode(user_title));
	}
    
	window.location='/process_shortcut.phtml?action=add&item_key=' + escape(to_url) + '&item_name=' + assign_title;
}
// Allows users to name their shortcuts
function add_buddy_to_list(default_alias, list_username)
{
	assign_alias = default_alias;
	var buddy_alias = prompt("What alias do you want to give your buddy?", assign_alias);
	if (buddy_alias.length > 0) {
		assign_alias = buddy_alias;
	}
    window.location = '/process_buddy_list.phtml?action=add&item_name='+ assign_alias +'&item_key='+ list_username;
    
}
function signup_redirect(){
    var url = window.location.protocol+'//'+window.location.hostname+'/?login=1';
    if(window.opener == undefined){
        window.location = url;
    }
    else{
        window.opener.location = url;
        window.self.close();
    }
}
// Base64 encoding for javascript
function base64_encode (input) {
	var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	var output = "";
	var c1, c2, c3;
	var enc1, enc2, enc3, enc4;
	var i = 0;

	while (i < input.length) {
		c1 = input.charCodeAt(i++);
		c2 = input.charCodeAt(i++);
		c3 = input.charCodeAt(i++);

		enc1 = c1 >> 2;
		enc2 = ((c1 & 3) << 4) | (c2 >> 4);
		enc3 = ((c2 & 15) << 2) | (c3 >> 6);
		enc4 = c3 & 63;

		if (isNaN(c2)) {
			enc3 = enc4 = 64;
		} else if (isNaN(c3)) {
			enc4 = 64;
		}

		output = output + chars.charAt(enc1) + chars.charAt(enc2) + chars.charAt(enc3) + chars.charAt(enc4);
	}
	
	return output;
}

// Base64 decoding for javascript
function base64_decode (input) {
	var output = "";
	var c1, c2, c3;
	var enc1, enc2, enc3, enc4;
	var i = 0;

	// Strip invalid encoding characters
	input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

	while (i < input.length) {
		enc1 = keyStr.indexOf(input.charAt(i++));
		enc2 = keyStr.indexOf(input.charAt(i++));
		enc3 = keyStr.indexOf(input.charAt(i++));
		enc4 = keyStr.indexOf(input.charAt(i++));

		c1 = (enc1 << 2) | (enc2 >> 4);
		c2 = ((enc2 & 15) << 4) | (enc3 >> 2);
		c3 = ((enc3 & 3) << 6) | enc4;

		output = output + String.fromCharCode(c1);

		if (enc3 != 64) {
			output = output + String.fromCharCode(c2);
		}
		if (enc4 != 64) {
			output = output + String.fromCharCode(c3);
		}
	}

	return output;
}

// UTF-8 encoding for javascript
function utf8_encode (input) {
	var c, s;
	var output = "";
	var i = 0;

	while (i < input.length) {
		c = input.charCodeAt(i++);
		if (c >= 0xDC00 && c < 0xE000) continue;
		if (c >= 0xD800 && c < 0xDC00) {
			if (i >= input.length) continue;
			s = input.charCodeAt(i++);
			if (s < 0xDC00 || c >= 0xDE00) continue;
			c = ((c-0xD800) << 10) + (s-0xDC00) + 0x10000;
		}
		// Create the output string
		if (c < 0x80) output += String.fromCharCode (c);
		else if (c < 0x800) output += String.fromCharCode (0xC0 + (c >> 6), 0x80 + (c & 0x3F));
		else if (c < 0x10000) output += String.fromCharCode (0xE0 + (c >> 12), 0x80 + (c >> 6&0x3F), 0x80 + (c&0x3F));
		else output += String.fromCharCode (0xF0 + (c >> 18), 0x80 + (c >> 12&0x3F), 0x80 + (c >> 6&0x3F), 0x80 + (c&0x3F));
	}
	
	return output;
}

// Creates a cross-browser AJAX object
function ajax () {
	// Try to use native XMLHttpRequest object first
	if (window.XMLHttpRequest) {
    try {
			http = new XMLHttpRequest ();
		} catch (e) {
			http = false;
		}
	}
	// If native object unavailable, try IE/Windows ActiveX object
	else if (window.ActiveXObject) {
		try {
      http = new ActiveXObject ("Msxml2.XMLHTTP");
    } catch (e) {
      try {
        http = new ActiveXObject ("Microsoft.XMLHTTP");
      } catch (e) {
        http = false;
			}
    }
  }
	else {
		http = false;
  }

	return http;
}

// Opens a destination window of whatever dimensions with or without the window controls
var view_win  = null;
var extraArgs = '';
function openWin (page, winWidth, winHeight, showTools, winName) {
  var props;
  if (!winName) {
		winName = 'newwin_id'+'_'+winWidth+'_'+winHeight;
	}
  if (showTools == true) {
    props = 'width='+winWidth+',height='+winHeight+','+'scrolling=yes,scroll=yes,scrollbars=yes,resizable=yes,toolbar=no';
	}
  else {
    props = 'width='+winWidth+',height='+winHeight+','+'scrolling=no,scroll=no,scrollbars=no,resizable=no,toolbar=no';
	}
  if (page.indexOf('?') == -1) {
    extraArgs = '?width='+winWidth+'&height='+winHeight;
	}
  else {
    extraArgs = '&width='+winWidth+'&height='+winHeight;
	}
  if (view_win) {
		view_win.close();
	}
	
	view_win = window.open(page+extraArgs, winName, props);
}

// Patch to get CSS hover pseudo class working on li in MSIE
function init_menu_hover () {
	if (document.all && document.getElementById) {
		var menuLink = document.getElementById('shortcuts_link');
        menuLink.onmouseover = function() { this.className += ' over'; }
		menuLink.onmouseout = function() { this.className = this.className.replace (' over', ''); }
                
		var menuRoot = document.getElementById ('shortcuts');
		for (i = 0; i < menuRoot.childNodes.length; i++) {
			node = menuRoot.childNodes[i];
			if (node.nodeName == 'LI') {
				node.onmouseover = function() { this.className += ' over'; }
				node.onmouseout = function() { this.className = this.className.replace (' over', ''); }
			}
		}
	}
}

// Embeds a Flash movie on the page using a post-Eolas work-around
function flash_object (src, width, height, flash_vars, version, scale, wmode) {
    if(wmode==undefined){wmode="transparent";}
	
	// added tag "name" in embed ( for Firefox )
	var ac = new Date().getTime() + "_" + Math.floor(Math.random()*1000);
	
	// random id written here to solve IE ExternalInterface null bug
	document.write ("<object id='" + ac + "' classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000' codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=" + version + ",0,0,0' width='" + width + "' height='" + height + "'>");
	document.write ("<param name='movie' value='" + src + "'>");
	document.write ("<param name='menu' value='false'>");
	document.write ("<param name='quality' value='high'>");
	document.write ("<param name='wmode' value='" + wmode + "'>");   
	document.write ("<param name='scale' value='" + scale + "'>");
	document.write ("<param name='salign' value='lt'>");
	document.write ("<param name='AllowScriptAccess' value='always'>");
	document.write ("<param name='FlashVars' value='" + flash_vars + "'>");
	document.write ("<embed type='application/x-shockwave-flash' name='" + ac + "' menu='false' wmode='"+ wmode +"' src='" + src + "' width='" + width + "' height='" + height + "' quality='high' scale='" + scale + "' salign='lt' pluginspage='http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash' AllowScriptAccess='always' FlashVars='" + flash_vars + "'></embed>");
	document.write ("</object>");
}

function can_submit (my_form) {
	// Usage of this function assumes inclusion of this form element on the page to regulate submission
	// Passed form object by reference in case several forms on the page want to make use of this function
	// Using getElementById would be more complicated in that situation
	var submitted = my_form.submitted;

	if (submitted.value == 'false') {
		submitted.value = 'true';
		return true;
	}
	
	return false;
}

// Mark all checkboxes on or off so that the user can affect the whole list at once
function checkAll (form, check, input_name) {
	for (var c = 0; c < form.elements.length; c++)
		if ((form.elements[c].type == 'checkbox') && (form.elements[c].name == input_name))
			form.elements[c].checked = check;
}

//Confirm that checkboxes in list have been selected.  Alert if not.
function confirm_checked(form, check, input_name, confirm_msg){
		var proceed = false;
		for (var c = 0; c < form.elements.length; c++){
			if ((form.elements[c].type == 'checkbox') && (form.elements[c].name == input_name) && (form.elements[c].checked == true)){
				proceed = true;
			}
		}
		if(proceed){ 
			return confirm(confirm_msg); 
		}
		else{ 
			alert('You must select an item before you can proceed.'); 
			return false;
		}
}

//determine if a form field has been set
function validate_required(field,alerttxt) {
    with (field) {
        if ( value==null || value=="" ) {
            alert(alerttxt);
            return false;
        }
        else {
            return true;
        }
    }
}

//Make sure that pole, bait, and location for the fishing game have 
//been selected before casting.  Oh, the horror!
function validate_fishing_game_form(thisform) {
    with (thisform) {
        if (validate_required(pole_id,"You must choose a pole to use!") == false) {
            pole_id.focus();
            return false;
        }
        if (validate_required(bait_id,"You must choose which bait to use!") == false) {
            bait_id.focus();
            return false;
        }
        if (validate_required(fish_location,"You must select a location to cast!") == false) {
            fish_location.focus();
            return false;
        }
    }
}

//Promotion-related links that must be tracked via Google Analytics
function redirect_and_track(url,campaign,action,new_window) {
    track_as = "/campaign=" + campaign + "/action=" + action;
  urchinTracker(track_as);
    if(new_window) {
        window.open(url);
    } else {
        window.location=url;
    }
}

// Ad Spot rollover states
function showspot()
{
    document.getElementById("warning").style.visibility = 'visible';
	setLyr(document.getElementById("ad_spot"),'warning');
	}
function hidespot()
{
	document.getElementById("warning").style.visibility = 'hidden';
}
function setLyr(obj,lyr)
{
    var coors = findPos(obj);
	var x = document.getElementById(lyr);
	x.style.top = coors[1] + 'px';
	x.style.left = coors[0] + 'px';
}
function findPos(obj)
{
	var curleft = curtop = 0;
	if (obj.offsetParent)
	{
		curleft = obj.offsetLeft;
        curtop = obj.offsetTop;
	}
	curtop -= 0;
	curleft += 24;
	return [curleft, curtop];
}

