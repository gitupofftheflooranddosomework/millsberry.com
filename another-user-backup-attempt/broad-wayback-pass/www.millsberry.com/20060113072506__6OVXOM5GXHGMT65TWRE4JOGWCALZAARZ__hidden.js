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

// CSS hack to get hover property working on li in MSIE
/*function initMenu () {
	if (document.all && document.getElementById) {
		var menuRoot = document.getElementById ("shortcuts");
		for (i = 0; i < menuRoot.childNodes.length; i++) {
			node = menuRoot.childNodes[i];
			if (node.nodeName == "LI") {
				node.onmouseover = function() {
					this.className += " over";
				}
				node.onmouseout = function() {
					this.className = this.className.replace (" over", "");
				}
			}
		}
	}
}
window.onload = initMenu;*/
