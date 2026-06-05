final_score.text = _parent.score;
trace("FINAL LEVEL 1 SCORE: " + _root.honeyloader.GAMESCORE.show());
btn_submit.onRelease = function()
{
   _root.honeyloader.sendScore(1);
   new mx.transitions.Tween(_parent.panel_score_mc,"_alpha",mx.transitions.easing.Regular.easeInOut,0,100,1,true);
   new mx.transitions.Tween(_parent.MC_Panel_Congratulations,"_alpha",mx.transitions.easing.Regular.easeInOut,100,0,1,true);
   _parent.panel_score_mc._visible = true;
   _parent.MC_Panel_Congratulations._visible = false;
   _parent.panel_score_mc.tf_score_txt.text = _root.honeyloader.GAMESCORE.show();
   _parent.panel_score_mc.tf_mb_txt.text = _root.honeyloader.ScoringSystem._MBPOINTS.show();
};
btn_playagain.onRelease = function()
{
   flash.external.ExternalInterface.call("urchinTracker","Game_511/Action_PlayAgainLevel1");
   _parent.gotoAndStop("game");
};
btn_gotolevel2.onRelease = function()
{
   _root.image_mcl.loadClip(_level0._MB8_GAME_DATA.FG_GAME_BASE + "flashgames/savethehoney_game/g511_v1_level2.swf",_root.mcSubload);
};
