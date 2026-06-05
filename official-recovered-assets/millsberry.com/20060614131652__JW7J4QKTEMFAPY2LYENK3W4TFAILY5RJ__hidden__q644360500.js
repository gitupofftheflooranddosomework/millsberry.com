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
function flash_object (src, width, height, flash_vars, version, scale) {
	document.write ("<object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000' ");
	document.write ("codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=" + version + ",0,0,0' ");
	document.write ("width='" + width + "' height='" + height + "'>");
	document.write ("<param name='movie' value='" + src + "'>");
	//document.write ("<param name='loop' value='false'>");
	//document.write ("<param name='devicefont' value='true'>");
	//document.write ("<param name='menu' value='false'>");
	document.write ("<param name='quality' value='high'>");
	document.write ("<param name='wmode' value='transparent'>");
	document.write ("<param name='scale' value='" + scale + "'>");
	document.write ("<param name='FlashVars' value='" + flash_vars + "'>");
	document.write ("<embed type='application/x-shockwave-flash' src='" + src + "' width='" + width + "' height='" + height + "' quality='high' wmode='transparent' scale='" + scale + "' pluginspage='http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash' FlashVars='" + flash_vars + "'></embed>");
	document.write ("</object>");
	
	/*
	document.write ("<object type='application/x-shockwave-flash' data='" + src + "' width='" + width + "' height='" + height + "'>");
	document.write ("<param name='movie' value='" + src + "'>");
	document.write ("<param name='wmode' value='transparent'>");
	document.write ("<param name='scale' value='exactfit'>");
	document.write ("<param name='FlashVars' value='" + flash_vars + "'>");
	document.write ("</object>");
	*/
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
