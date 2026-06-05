

var cossette_tlaswf = "/activity_break.swf"; //location of first swf movie
var cossette_tlaTLAHeight = 420; //flash height
var cossette_tlaTLAWidth = 520; //flash width
var cossette_tlastartTopLayerAddX = parseInt(cossette_tlagetPageWidth()/2) - parseInt(cossette_tlaTLAWidth/2); //starting x location on page (Centered)
var cossette_tlastartTopLayerAddY = parseInt(cossette_tlagetPageHeight()/2) - parseInt(cossette_tlaTLAHeight/2) ;//starting y location on screen (Centered)
var cossette_timelimit = 27; // minutes to wait for activity break check
var cossette_wait_interval = 10 // seconds to check again if not in focus
var cossette_window_isfocus = true;
var cossette_ignore_global_counter = false;
var cossette_tlaAutoClose = false; //automatically close the Ad true or false
var cossette_tlaAutoCloseAfter = 7; // seconds
var cossette_hasloaded = false;
var cossette_tlaoffTopLayerAddY = -600; // position when closed

var cossette_tlaBlock; // The global variable for the TLA
var cossette_tlaisNav4 = (document.layers) ? 1 : 0;
var cossette_tlaisNav6 = (document.getElementById) ? 1 : 0;
var cossette_tlaisIE4Up = (document.all) ? 1 : 0;
var cossette_tlaCloseval = false;
var cossette_tlacheckfocus;

	if (cossette_tlaisIE4Up == true && navigator.appVersion.indexOf("Mac")==-1){ //If IE draw detect flash version 
	  document.writeln('<SCR'+'IPT LANGUAGE="VBScript">');
	  document.writeln('Function cossette_tlaVBGetFlashControlVersion()'); 
	  document.writeln('REM detect if IE has flash');
	  document.writeln('      on error resume next');
	  document.writeln('      Dim theversion');
	  document.writeln('      set theversion = 0');
	  document.writeln('		Dim Control');
	  document.writeln('	set Control = CreateObject("ShockwaveFlash.ShockwaveFlash")');
	  document.writeln('      if (IsObject(Control)) then');
	  document.writeln('        theversion = int(Control.FlashVersion()/ 65536)');
	  document.writeln('      end if');
	  document.writeln('      cossette_tlaVBGetFlashControlVersion = theversion');
	  document.writeln('  End Function');
	  document.writeln('  Sub thecossettetoplayerad_FSCommand(ByVal command, ByVal args)');
      document.writeln('    call thecossettetoplayerad_DoFSCommand(command, args)');
	  document.writeln('  end sub');
	  document.writeln('</SCRI'+'PT>');
	
	}
	//detect the version of flash
	if (cossette_tlaisIE4Up == true && navigator.appVersion.indexOf("Mac")==-1) var cossette_tlahasFlash = cossette_tlaVBGetFlashControlVersion();
	else var cossette_tlahasFlash = cossette_tlaNetscapeFlash()
	
    //draw TLA to screen, use layer is Netscape 4, use Div if IE or Netscape 6
	if(!cossette_tlaisNav4){
		document.writeln('<div id="cossette_tlaTopLayerAd" style="visibility: visible; position: absolute; top: -500px; left: '+cossette_tlastartTopLayerAddX +'px; z-index:1000;">');
		cossette_tladrawFlash_or_Gif();
		document.writeln('</div>');
	}else {
		document.writeln('<layer name="cossette_tlaTopLayerAd" pagex="'+cossette_tlastartTopLayerAddX+'" pagey="'+cossette_tlastartTopLayerAddY+'" visibility="show" z-index="1000">');
		cossette_tladrawFlash_or_Gif();
		document.writeln('</layer>');
	}
	
	
 function cossette_tlaNetscapeFlash(){//detect if netscape has the right version of flash
	 var plugin = (navigator.mimeTypes && navigator.mimeTypes["application/x-shockwave-flash"] ? navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin : 0);
	 if (plugin && parseInt(plugin.description.substring(plugin.description.indexOf(".")-1)) >= 3) return parseInt(plugin.description.substring(plugin.description.indexOf(".")-1));
	 else return 0;
}

function thecossettetoplayerad_DoFSCommand(command, args) {

	if(command =="checkActivity"){
		cossette_checkdates();
	}
	
}


function cossette_tladrawFlash_or_Gif(){
//draw the flash or gif backup to the page
 	if (cossette_tlahasFlash >5){
			document.write('<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://active.macromedia.com/flash/cabs/swflash.cab#version=2,0,0,0" ID="thecossettetoplayerad2" WIDTH='+cossette_tlaTLAWidth+' HEIGHT='+cossette_tlaTLAHeight+'>');
			document.write('<PARAM NAME=movie VALUE="'+cossette_tlaswf+'">'); 
			document.write('<PARAM NAME=quality VALUE=high> '); 
			document.write('<PARAM NAME=wmode VALUE=transparent> '); 
	        document.write('<EMBED SRC="'+cossette_tlaswf+'" NAME=thecossettetoplayerad2 swLiveConnect=TRUE WIDTH='+cossette_tlaTLAWidth+' HEIGHT='+cossette_tlaTLAHeight+' QUALITY=autohigh SCALE=exactfit TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" wmode="transparent"></EMBED>');   
			document.write('</OBJECT>');
	 
	 }
}

function move_cossette_tlaTopLayerAd(show){
//show the toplayer ad or hide the toplayer ad, Move off scree since hiding in older browsers may block user clicks on page.
	if (!show&&cossette_tlaCloseval){
	//hise TLA only if requestd to close and last minute escape variable is also set to close
	//auto close is set by timeout, if the user clicks then timeout is ignored as escape variable is set to false
		cossette_tlaBlock.ypos = cossette_tlaoffTopLayerAddY;
		cossette_tlaBlock.top = cossette_tlaBlock.ypos;
	}else{
	//show TLA
		cossette_tlaBlock.ypos = cossette_tlastartTopLayerAddY;
		cossette_tlaBlock.top = cossette_tlaBlock.ypos;
	}

}

function cossette_tlaTopLayerAd_init() {
//set variables and position of Ad to start
	if (cossette_tlaisNav4) {
		cossette_tlaBlock = document.cossette_tlaTopLayerAd;
	} else if(cossette_tlaisIE4Up){
		cossette_tlaBlock =cossette_tlaTopLayerAd.style;
	}else if (cossette_tlaisNav6){
		cossette_tlaBlock = document.getElementById('cossette_tlaTopLayerAd').style;
	}
	cossette_tlaBlock.xpos = parseInt(cossette_tlaBlock.left);	
	cossette_tlaBlock.ypos = parseInt(cossette_tlaBlock.top);
	setTimeout("move_cossette_tlaTopLayerAd(true)",50);
}

function cossette_tlaloaded(){
//flash calls this script once the first movie has finished and is waiting for user input
//this will set a timeout to close the ad if cossette_tlaAutoClose = true, if flase ad will not close
//unless user click close
	if(cossette_tlaAutoClose){
		setcossette_tlaClose(true);
		setTimeout("move_cossette_tlaTopLayerAd(false)",(cossette_tlaAutoCloseAfter*1000));
	}
}

function setcossette_tlaClose(value){
//set timeout escape value to true or false, TLA closes if set to true 
	cossette_tlaCloseval = value;
}

function cossette_tlaClose(){
//close the TLA
	setcossette_tlaClose(true);
	move_cossette_tlaTopLayerAd(false);
}

function cossette_tlagetPageWidth() {
// return the users browser width
	var pageWidth;
	
	if (navigator.appName.indexOf("Microsoft") != -1) pageWidth = window.document.body.offsetWidth;
	else pageWidth = window.innerWidth;

	return pageWidth;
}

function cossette_tlagetPageHeight() {
// return the users browser height
	var pageHeight;
	
	if (navigator.appName.indexOf("Microsoft") != -1) pageHeight = window.document.body.offsetHeight;
	else pageHeight = window.innerHeight;
	
	return pageHeight;
}


  var cossette_cookie = document.cookie;

  function cossette_getCookie(name) { // use: cossette_getCookie("name");
  	cossette_cookie = document.cookie
    var index = cossette_cookie.indexOf(name + "=");
    if (index == -1) return null;
    index = cossette_cookie.indexOf("=", index) + 1;
    var endstr = cossette_cookie.indexOf(";", index);
    if (endstr == -1) endstr = cossette_cookie.length;
    return unescape(cossette_cookie.substring(index, endstr));
  }

  function cossette_setCookie(name, value) { // use: cossette_setCookie("name", value);
    if (value != null && value != "")
      document.cookie=name + "=" + escape(value) + "; path=/";
	  //document.cookie=name + "=" + escape(value) + "; expires=" + expiry.toGMTString();
    cossette_cookie = document.cookie; // update cossette_cookie
  }

function cossette_returnMinutes(dobj){
	return (((dobj.getUTCDate()*24)+dobj.getUTCHours())*60)+dobj.getUTCMinutes()
}

var cossette_firsttimer;
var cossette_secondtimer;
function cossette_checkdates(){
	var showactivityFlag = cossette_getCookie("abseen")
	if(showactivityFlag==null){
		var cdate = new Date();
		var firsttime = false
		var thestartTime = cossette_getCookie("abstarttime");
		if (thestartTime==null){
		 thestartTime = cossette_returnMinutes(cdate);
		 cossette_setCookie("abstarttime", thestartTime);
		 firsttime = true;
		 if(!cossette_ignore_global_counter)cossette_firsttimer =  window.setTimeout("cossette_checkdates()",(cossette_timelimit)*60000)
		}
		var	currentMins = cossette_returnMinutes(cdate);
		var minleft = cossette_timelimit - (currentMins - parseInt(thestartTime));
		
		if((currentMins - parseInt(thestartTime))>=cossette_timelimit&&cossette_window_isfocus){
				cossette_tlaTopLayerAd_init();
				cossette_setCookie("abseen", "true");
		}else if((currentMins - parseInt(thestartTime))>=cossette_timelimit&&!cossette_window_isfocus){
		//document.forms[0].testing.value = "checking again in"+(1000*cossette_wait_interval);
			if(!cossette_ignore_global_counter)cossette_secondtimer= window.setTimeout("cossette_checkdates()",1000*cossette_wait_interval)
		}else if(!firsttime){
		//document.forms[0].testing.value = "not checking"+(currentMins - parseInt(thestartTime))+" "+cossette_timelimit+" "+cossette_window_isfocus;
			if(!cossette_ignore_global_counter)cossette_firsttimer =  window.setTimeout("cossette_checkdates()",60000*minleft)
		}
	}
}

function cossette_setIgnoreGCD(value){
	cossette_ignore_global_counter = value;
}

function closeAll(){
	//window.close();
	if(navigator.userAgent != null && navigator.userAgent.indexOf( "Firefox/" ) != -1 ){
		if (window.opener != null){
				window.opener.close();
				window.opener.open('','_parent','');
				window.opener.close();
		}
		window.parent.close();
		window.open('','_parent','');
		window.close();
	}else{
		//if (window.opener){
		//if(!window.opener.closed){ 
		if (window.opener != null){
			specialparent=window.opener.open('','_parent','');
			specialparent.opener="bar"
			specialparent.close();
		}
			//}
		//}
		nameplay = window.open('','_parent','');
		nameplay.opener = "foo";
		nameplay.close();
	}
}

function closeActivity(){
	cossette_tlaClose();
}

window.onload=function(){
	self.focus();
	cossette_checkdates();
	if(cossette_tlaisIE4Up){
		for (var e = 0; e < document.body.all.length; e++){
			document.body.all[e].onfocus = function(){
				cossette_window_isfocus=true;
				//window.status="sdon"
			};
			document.body.all[e].onblur = function(){
				cossette_window_isfocus = false;
				//if(cossette_getCookie("abseen")==null)window.focus();
				//window.status="sdof"
			};
		}
		
		document.onmousedown = function(){
			cossette_window_isfocus=true;
			//window.status="con"
		}
	}
}

window.onfocus=function(){
	cossette_window_isfocus=true;
	//window.status="mdon"
}

window.onblur=function(){
	cossette_window_isfocus = false;
	//window.status="mdof"
}

window.onunload=function(){
	if(window.opener){
		//if(!window.opener.closed)window.opener.focus();
	}
}

