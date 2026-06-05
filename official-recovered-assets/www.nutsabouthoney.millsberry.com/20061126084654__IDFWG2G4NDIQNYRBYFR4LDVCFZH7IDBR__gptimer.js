var cookienoticename = "goplaytimer"; // the name of the cookie to prevent confusion
var goplaywidth = (605/2); // width of go play graphic
var movedown = (344/2/2);
var displaynotice = 30 ; // number of minutes for the notice to show up
var displayplayimage = '<img src="images/goplay.gif" alt="" width="605" height="344" usemap="#goplay" border="0">';
onLoad=init();
var playtimeout;
if (document.images) {
	var goplaysrc = newImage("images/goplay.gif");
}
function init(){
	var minutes = settimerminutes();
	if(readCookie(cookienoticename) == null){
		setCookie(cookienoticename,minutes);
	}
}

function gooutsideandplay(){
	document.getElementById("playpop").style.visibility="visible";
}

function closeWindow() {
	if(navigator.userAgent != null && navigator.userAgent.indexOf( "Firefox/" ) != -1 ){
		window.open('','_parent','');
		window.close();
	}else{
		nameplay = window.open('','_parent','');
		nameplay.opener = "foo";
		nameplay.close();
	}
}

function continuetoplay(){
	document.getElementById("playpop").style.visibility="hidden";
	setCookie(cookienoticename,"no");
}
function timeOutCheck(){
	var thistime= new Date();
	var thistimestop = new Date(readCookie(cookienoticename));
	if(thistime >= thistimestop){
		gooutsideandplay();
	}
}

function settimerminutes(){
	var thistime= new Date();
	var minutes=thistime.getMinutes();
	minutes += displaynotice;
	thistime.setMinutes(minutes)
	return thistime
}

//##########COOKIE FUNCTIONS
function setCookie(name,value,days){
	if (days){
		var date = new Date();
		date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
		var expires = "; expires=" + date.toGMTString();
	} else {
		var expires = "";
	}
	document.cookie = name + "=" + value + expires + "; path=/";
}

function readCookie(name){
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++)	{
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}
//###################################################################################
function setplaypop(){
	var finalleftoffset = document.images.positionimage.offsetLeft - goplaywidth; 
	var finaltopoffset = document.images.positionimage.offsetTop + movedown; 
	document.write('<div id="playpop" style="position:absolute;left:'+finalleftoffset+';top:'+finaltopoffset+';visibility:hidden;"><br><br><br>'+
displayplayimage +
'</div>');
	moveplaypop();
//	document.getElementById("playpop").style.visibility="visible";
}

function moveplaypop(){
	var finalleftoffset = document.images.positionimage.offsetLeft - goplaywidth; 
	var finaltopoffset = document.images.positionimage.offsetTop + movedown; 
	document.getElementById("playpop").style.left=finalleftoffset;
	document.getElementById("playpop").style.top=finaltopoffset;
}
onLoad=setplaypop();
window.onresize= moveplaypop;

function newImage(arg) {
	if (document.images) {
		rslt = new Image();
		rslt.src = arg;
		return rslt;
	}
}
