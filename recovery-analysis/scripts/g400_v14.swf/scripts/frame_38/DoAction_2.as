CR.addContent(btn_playgame,"Play Game Button",_level0.IDS_playgame_txt);
CR.addContent(btn_instructions,"Instructions Button",_level0.IDS_instructions_txt);
CR.addContent(btn_controls,"Controls Button",_level0.IDS_controls_txt);
CR.flushRegister();
if(_level0.VAR_currbelt == undefined || _level0.VAR_points_needed == undefined || _level0.VAR_posts_needed == undefined)
{
   _root.unloadMovie();
}
