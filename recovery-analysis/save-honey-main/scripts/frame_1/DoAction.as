_lockroot = true;
_quality = "BEST";
var honeyloader = this._parent;
trace("GAMESCORE: " + honeyloader.GAMESCORE.show());
b0._hit.enabled = b1._hit.enabled = b2._hit.enabled = false;
var gameSubFile = _root.prGameFile;
var mclListener = new Object();
mclListener.onLoadInit = function(target_mc)
{
   if(_currentframe > 23)
   {
      gotoAndStop("continue");
      play();
   }
   Panel_Parchmentcopy01.Btn_SaveSomeHoney.MC_txt_Loading._visible = false;
   Panel_Parchmentcopy01.Btn_SaveSomeHoney.MC_txt_SaveSomeHoney._visible = true;
   trace(target_mc + " loaded");
   Panel_Parchmentcopy01.Btn_SaveSomeHoney.MC_txt_SaveSomeHoney.onRelease = function()
   {
      _root.honeyloader.PLAYTIMER.start();
      gotoAndStop("continue");
      play();
   };
};
mclListener.onLoadProgress = function(target, bytesLoaded, bytesTotal)
{
   Panel_Parchmentcopy01.Btn_SaveSomeHoney.MC_txt_Loading.MC_loadingBar._xscale = 100 * bytesLoaded / bytesTotal;
   trace(target + ".onLoadProgress with " + bytesLoaded + " bytes of " + bytesTotal);
};
var image_mcl = new MovieClipLoader();
image_mcl.addListener(mclListener);
image_mcl.loadClip(_level0._MB8_GAME_DATA.FG_GAME_BASE + "flashgames/savethehoney_game/g511_v1_level1.swf",mcSubload);
