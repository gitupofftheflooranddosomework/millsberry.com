gVersion="1.3";
if (window.ActiveXObject){
	var gFV="";
	for (var gVer=2;gVer<=10;gVer++){
		try{
			var gFlash = eval("new ActiveXObject('ShockwaveFlash.ShockwaveFlash."+gVer+"');");
			if (gFlash){
				gFV=gVer+".0";
				break;
			}
		}
		catch(e){
		}
	}
}