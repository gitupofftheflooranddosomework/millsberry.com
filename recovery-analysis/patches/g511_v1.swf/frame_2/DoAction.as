function sendScore(level)
{
   ScoringSystem.submitScore(GAMESCORE.show());
   trace("********************************");
   trace("* SCORE SENDED ON Level " + level + " *");
   trace("********************************");
   trace("* Millsbucks earned: " + ScoringSystem._MBPOINTS.show() + " *");
   trace("********************************");
   PLAYTIMER.stop();
   var _loc1_ = PLAYTIMER.getMinutes(PLAYTIMER.time);
   var _loc2_ = "";
   if(_loc1_ < 1)
   {
      _loc2_ = "Game_511/time-0:1min";
   }
   else if(_loc1_ >= 1 && _loc1_ < 2)
   {
      _loc2_ = "Game_511/time-1:2min";
   }
   else if(_loc1_ >= 2 && _loc1_ < 3)
   {
      _loc2_ = "Game_511/time-2:3min";
   }
   else if(_loc1_ >= 3 && _loc1_ < 4)
   {
      _loc2_ = "Game_511/time-3:4min";
   }
   else if(_loc1_ >= 4 && _loc1_ < 5)
   {
      _loc2_ = "Game_511/time-4:5min";
   }
   else if(_loc1_ >= 5 && _loc1_ < 7)
   {
      _loc2_ = "Game_511/time-5:7min";
   }
   else if(_loc1_ >= 7 && _loc1_ < 10)
   {
      _loc2_ = "Game_511/time-7:10min";
   }
   else if(_loc1_ >= 10 && _loc1_ < 15)
   {
      _loc2_ = "Game_511/time-10:15min";
   }
   else if(_loc1_ >= 15 && _loc1_ < 20)
   {
      _loc2_ = "Game_511/time-15:20min";
   }
   else if(_loc1_ >= 20)
   {
      _loc2_ = "Game_511/time-20+min";
   }
   trace("GOOGLE ANALYTICS PATTERN: " + _loc2_);
   flash.external.ExternalInterface.call("urchinTracker",_loc2_);
   PLAYTIMER.reset();
   trace("RESET -> TIME CHECK: " + PLAYTIMER.time);
}
var MillsberryEvar = function(value)
{
   this.value = value;
};
MillsberryEvar.prototype.show = function()
{
   return this.value;
};
MillsberryEvar.prototype.changeBy = function(amount)
{
   this.value += amount;
   return this.value;
};
MillsberryEvar.prototype.changeTo = function(value)
{
   this.value = value;
   return this.value;
};
var ScoringSystem = new Object();
ScoringSystem.Evar = MillsberryEvar;
ScoringSystem._MBPOINTS = new MillsberryEvar(0);
ScoringSystem.reset = function()
{
};
ScoringSystem.submitScore = function()
{
};
var GAMESCORE = new ScoringSystem.Evar(0,"","");
var ITEM_NAME = new ScoringSystem.Evar("","","");
var PLAYTIMER = new gmi.utilities.Timer();
var mc_loader = new MovieClipLoader();
var listener = new Object();
this.createEmptyMovieClip("loader",this.getNextHighestDepth());
listener.onLoadComplete = function(target_mc)
{
   trace("COMPLETED");
};
listener.onLoadInit = function(target_mc)
{
   trace("LOADED MAIN GAME >>>>>>>>>");
   Stage.scaleMode = "exactfit";
   ScoringSystem.reset();
   GAMESCORE.changeTo(0);
};
trace("STAGEWIDTH LOADER: " + Stage.width);
trace("STAGEHEIGHT LOADER: " + Stage.height);
mc_loader.addListener(listener);
mc_loader.loadClip(_level0._MB8_GAME_DATA.FG_GAME_BASE + "flashgames/savethehoney_game/g511_v1_main.swf",loader);
stop();
