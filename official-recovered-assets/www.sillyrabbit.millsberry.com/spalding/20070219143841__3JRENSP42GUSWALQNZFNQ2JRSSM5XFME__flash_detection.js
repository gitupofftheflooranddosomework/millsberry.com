	//write out VB script for IE flash detection
		if(navigator.appName.indexOf("Microsoft") != -1){
			  document.writeln('<SCR'+'IPT LANGUAGE="VBScript">');
	  		  document.writeln('Function VBGetFlashControlVersion()');
	          document.writeln(' REM detect if IE has flash');
	          document.writeln(' on error resume next');
	          document.writeln(' Dim theversion');
	          document.writeln(' set theversion = 0');
			  document.writeln(' Dim Control');
			  document.writeln(' set Control = CreateObject("ShockwaveFlash.ShockwaveFlash")');
	          document.writeln(' if (IsObject(Control)) then');
	          document.writeln('  theversion = int(Control.FlashVersion()/ 65536)');
	          document.writeln(' end if');
	          document.writeln(' VBGetFlashControlVersion = theversion');
	          document.writeln('End Function');
	  		  document.writeln('</SCR'+'IPT>');
		}
		
		//Netscape flash detection
	 function NetscapeFlash(){//detect if netscape has the right version of flash
		 var plugin = (navigator.mimeTypes && navigator.mimeTypes["application/x-shockwave-flash"] ? navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin : 0);
		 if (plugin && parseInt(plugin.description.substring(plugin.description.indexOf(".")-1)) >= 3) return parseInt(plugin.description.substring(plugin.description.indexOf(".")-1));
		 else return 0;
	 }

	//Place name of flash file, prefix of the flash file, i.e the part before the .swf 
	// the flash height and width in the following variable
	var flashfile = "flashAnim.swf";
	var backupgif = "backupGif.jpg";
	var flashID = "flashID";
	var flashHeight = 400;
	var flashWidth = 400;
	var versionNeeded = 7;
	var isMac = (navigator.appVersion.indexOf('Mac')!= -1)? 1:0 
	
	var InternetExplorer = navigator.appName.indexOf("Microsoft") != -1;
	var browser_version3 = parseInt(navigator.appVersion) < 4 ? true:false

	//Detect for 
	if (InternetExplorer == true && !isMac) var hasFlash = VBGetFlashControlVersion();
	else var hasFlash = NetscapeFlash()
	
	//alert("IE5? "+ InternetExplorer +" -- Mac? "+ isMac +" -- FlashV? "+ hasFlash);
