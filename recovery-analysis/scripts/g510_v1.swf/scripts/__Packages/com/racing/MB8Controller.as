class com.racing.MB8Controller
{
   static var GAMESCORE;
   static var ITEM_NAME;
   static var ScoringSystem;
   function MB8Controller()
   {
   }
   static function init()
   {
      var Evar = function(value)
      {
         this.value = value;
      };
      Evar.prototype.show = function()
      {
         return this.value;
      };
      Evar.prototype.changeBy = function(amount)
      {
         this.value += amount;
         return this.value;
      };
      Evar.prototype.changeTo = function(value)
      {
         this.value = value;
         return this.value;
      };
      com.racing.MB8Controller.ScoringSystem = new Object();
      com.racing.MB8Controller.ScoringSystem.Evar = Evar;
      com.racing.MB8Controller.ScoringSystem._MBPOINTS = new Evar(0);
      com.racing.MB8Controller.ScoringSystem._SRA_ITEM_ID = new Evar(0);
      com.racing.MB8Controller.ScoringSystem.reset = function()
      {
      };
      com.racing.MB8Controller.ScoringSystem.submitScore = function()
      {
      };
      com.racing.MB8Controller.ScoringSystem.getAwardItem = function()
      {
         return "";
      };
      com.racing.MB8Controller.GAMESCORE = new com.racing.MB8Controller.ScoringSystem.Evar(0,"","");
      com.racing.MB8Controller.ITEM_NAME = new com.racing.MB8Controller.ScoringSystem.Evar("","","");
   }
   static function getScore()
   {
      trace("MB8Controller - getScore : " + com.racing.MB8Controller.GAMESCORE.show());
      return com.racing.MB8Controller.GAMESCORE.show();
   }
   static function getPrize(score)
   {
      var _loc1_ = com.racing.MB8Controller.ScoringSystem.getAwardItem(score);
      var _loc2_ = com.racing.MB8Controller.ScoringSystem._SRA_ITEM_ID.show();
      trace("RACING GAME ITEM AWARD: " + _loc1_);
      trace("TRACKING :: itemAwarded" + _loc2_);
      flash.external.ExternalInterface.call("urchinTracker","/game-510/action-itemAwarded" + _loc2_);
      return _loc1_;
   }
   static function getMillsbucks()
   {
      return com.racing.MB8Controller.ScoringSystem._MBPOINTS.show();
   }
   static function changeScoreBy(num)
   {
      trace("MB8Controller - changeScoreBy : " + num);
      com.racing.MB8Controller.GAMESCORE.changeBy(num);
   }
   static function resetScore()
   {
      trace("MB8Controller - resetScore");
      com.racing.MB8Controller.ScoringSystem.reset();
   }
   static function submitScore(success)
   {
      var _loc1_ = !success ? "failedLevel" : "completedLevel";
      var _loc3_ = com.racing.Application.getInstance();
      var _loc2_ = _loc3_.xmlObject.config.track[_loc3_.SESSION_DATA.curTrack - 1].attributes.trackingtag;
      trace("TRACKING :: " + _loc1_ + _loc2_ + "AndSubmittedScore");
      flash.external.ExternalInterface.call("urchinTracker","/game-510/action-" + _loc1_ + _loc2_ + "AndSubmittedScore");
      com.racing.MB8Controller.ScoringSystem.submitScore(com.racing.MB8Controller.GAMESCORE.show());
   }
}
