CR.addContent(txt_controls_title,"controls title",_level0.IDS_controls_title_txt);
CR.addContent(txt_controls_content,"controls content",_level0.IDS_controls_content_txt);
CR.addContent(btn_back,"Back Button",_level0.IDS_back_txt);
CR.addContent(reset_txt,"controls reset",_level0.IDS_controls_reset_txt);
var i = 0;
while(i < _root.assignedkeys.length)
{
   CR.addContent(this["assignedkey" + i + "_txt"],"assignedkey" + i,_level0.IDS_key_opener + _root.keyname[i] + _level0.IDS_key_closer);
   CR.addContent(this["key" + i + "_txt"],"key" + i,_level0["IDS_controls_key" + i + "_txt"]);
   i++;
}
_root.resetKeys();
var enable_controls_buttons = true;
_root.attachMovie("KeyCapture","keycapture",100).init();
stop();
