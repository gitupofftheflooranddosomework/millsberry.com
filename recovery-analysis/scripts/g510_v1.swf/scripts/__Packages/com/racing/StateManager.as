class com.racing.StateManager
{
   function StateManager()
   {
   }
   static function goDrivers()
   {
      trace("TRACKING :: startGamePlay-");
      flash.external.ExternalInterface.call("urchinTracker","/game-510/action-startGamePlay");
      com.racing.screens.Drivers.getInstance().show();
      com.racing.screens.Home.getInstance().hide();
   }
   static function goTrack()
   {
      var _loc2_ = com.racing.Application.getInstance();
      var _loc1_ = _loc2_.xmlObject.config.driver[_loc2_.SESSION_DATA.curDriver - 1].attributes.trackingtag;
      trace("TRACKING :: selectedDriver" + _loc1_);
      flash.external.ExternalInterface.call("urchinTracker","/game-510/action-selectedDriver" + _loc1_);
      com.racing.screens.Drivers.getInstance().hide();
      com.racing.screens.Tracks.getInstance().show();
   }
   static function goRace(callee)
   {
      var _loc1_ = com.racing.Application.getInstance();
      _loc1_.SESSION_DATA.curTrack++;
      var _loc2_ = _loc1_.xmlObject.config.track[_loc1_.SESSION_DATA.curTrack - 1].attributes.trackingtag;
      trace("TRACKING :: playLevel" + _loc2_);
      flash.external.ExternalInterface.call("urchinTracker","/game-510/action-playLevel" + _loc2_);
      callee.hide();
      com.racing.Game.getInstance().loadRace();
   }
   static function goResults(success)
   {
      var _loc1_ = !success ? "failedLevel" : "completedLevel";
      var _loc3_ = com.racing.Application.getInstance();
      var _loc2_ = _loc3_.xmlObject.config.track[_loc3_.SESSION_DATA.curTrack - 1].attributes.trackingtag;
      trace("TRACKING :: " + _loc1_ + _loc2_);
      flash.external.ExternalInterface.call("urchinTracker","/game-510/action-" + _loc1_ + _loc2_);
      com.racing.Game.getInstance().hide();
      com.racing.screens.Results.getInstance().show(success);
   }
   static function goHome(callee)
   {
      com.racing.Application.getInstance().SESSION_DATA.curTrack = 0;
      callee.hide();
      com.racing.MB8Controller.resetScore();
      com.racing.screens.Home.getInstance().show();
   }
}
