function makePrompt(pType)
{
   _root.attachMovie("endPrompt","endPrompt",gDepths.prompt);
   _root.endPrompt.mcExtends(gPrompt,pType);
}
_global.gPrompt = function(pType)
{
   this.init(pType);
};
var p = gPrompt.prototype;
p.init = function(pType)
{
   _root.gameMusic.stop("gameMusic");
   gList.clearAll.push(this);
   if(pType != "pauseGame")
   {
      Key.removeListener(_root.world);
      _root.world.sb.pauseButton.enabled = 0;
      _root.world.sb.tPauseText = "";
      gList.enemies.removeClips();
      _root.world.player.onEnterFrame = undefined;
   }
   var _loc10_;
   var _loc9_;
   var _loc8_;
   if(pType != "pauseGame")
   {
      if(gDepths.pBulletNum > 0)
      {
         _loc10_ = gDepths.pBulletNum - _root.shotsMissed;
         _root.shotPercent = Math.round(_loc10_ / gDepths.pBulletNum * 100);
         _loc9_ = Math.max(0,_root.shotPercent - 60);
         _root.eRoundBonus.changeto(_loc9_);
         if(_root.shotPercent >= 90)
         {
            _loc8_ = "A";
         }
         else if(_root.shotPercent >= 80)
         {
            _loc8_ = "B";
         }
         else if(_root.shotPercent >= 70)
         {
            _loc8_ = "C";
         }
         else
         {
            _loc8_ = "D";
         }
      }
      else
      {
         _loc8_ = "F";
         _root.shotPercent = 0;
      }
   }
   var _loc5_ = 24;
   var _loc7_ = 16;
   var _loc4_ = "<P ALIGN=\'CENTER\'><FONT SIZE=\'4\'> \n</FONT></P>";
   if(pType == "gameOver")
   {
      Key.removeListener(_root.world);
      gMyNeoStatus.sendTag("Game Finished");
      _loc4_ += "<P ALIGN=\'CENTER\'><FONT SIZE=\'" + _loc5_ + "\'>--" + _level0.IDS_game_over + "--</FONT><BR>" + "\n<FONT SIZE=\'" + _loc7_ + "\'>" + _level0.IDS_you_reach_level + _root.eLevel.show() + "\n\n" + _level0.IDS_accuracy + ": " + _root.shotPercent + "%" + "\n" + _level0.IDS_your_grade + ": " + _loc8_ + "\n" + _level0.IDS_bonus + _root.eRoundBonus.show() + "\n\n" + "<A HREF=\'asfunction:_root.sendscoreCode\'>" + _level0.IDS_send_score + "</A><BR><BR>" + "<A HREF=\'asfunction:_root.restartCode\'>" + _level0.IDS_restart_game + "</A></FONT></P>";
   }
   else if(pType == "endRound")
   {
      _loc4_ += "<P ALIGN=\'CENTER\'><FONT SIZE=\'" + _loc5_ + "\'>--" + _level0.IDS_level + _root.eLevel.show() + _level0.IDS_clear + "--</FONT>" + "<FONT SIZE=\'" + _loc7_ + "\'>\n\n" + _level0.IDS_accuracy + ": " + _root.shotPercent + "%" + "\n" + _level0.IDS_your_grade + ": " + _loc8_ + "\n" + _level0.IDS_bonus + _root.eRoundBonus.show() + "\n\n" + "<A HREF=\'asfunction:_root.nextLevel\'>" + _level0.IDS_next_level + "</A><BR><BR>" + "<A HREF=\'asfunction:_root.endgamecode\'>" + _level0.IDS_end_game + "</A></FONT></P>";
   }
   else if(pType == "pauseGame")
   {
      _loc4_ += "<P ALIGN=\'CENTER\'><FONT SIZE=\'" + _loc5_ + "\'>--" + _level0.IDS_game_paused + "--</FONT><BR><BR>" + "<FONT SIZE=\'" + _loc7_ + "\'><A HREF=\'asfunction:_root.promptUnpause\'>" + _level0.IDS_play_game + "</A><BR><BR>" + "<A HREF=\'asfunction:_root.endgamecode\'>" + _level0.IDS_end_game + "</A></FONT></P>";
   }
   else
   {
      Key.removeListener(_root.world);
      gMyNeoStatus.sendTag("Game Finished");
      _loc4_ += "<P ALIGN=\'CENTER\'><FONT SIZE=\'" + _loc5_ + "\'>--" + _level0.IDS_level_cleared + "--\n\n" + _level0.IDS_accuracy + _root.shotPercent + "%" + "\n" + _level0.IDS_your_grade + _loc8_ + "\n" + _level0.IDS_bonus + _root.eRoundBonus.show() + "\n\n" + "<A HREF=\'asfunction:_root.sendscoreCode\'>" + _level0.IDS_send_score + "</A><BR><BR>" + "<A HREF=\'asfunction:_root.restartCode\'>" + _level0.IDS_restart_game + "</A></FONT></P>";
   }
   _global.translator.addTextField(this.tText,{htmlText:_loc4_});
   if(pType != "pauseGame")
   {
      _root.eScore.changeby(_root.eRoundBonus.show());
      _root.world.sb.refresh();
   }
};
