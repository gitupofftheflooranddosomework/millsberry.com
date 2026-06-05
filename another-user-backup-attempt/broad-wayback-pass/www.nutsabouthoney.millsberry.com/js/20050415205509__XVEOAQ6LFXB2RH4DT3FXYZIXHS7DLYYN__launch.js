

addToProperties = "";  

function launch()
{
	var url = 'swf/Landing.aspx';
	var winl = (screen.width - 750) / 2;
	var wint = (screen.height - 550) / 2;
	var features = "menubar=no, status=no, resizable=no, left=" + winl + ", top=" + wint + ", scrollbars=no, width=750, height=550";
	var newWin = window.open(url,'HNC',features);
	newWin.focus();
}
