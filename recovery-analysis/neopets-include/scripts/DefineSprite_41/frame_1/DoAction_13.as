function addScoreParameter(cName, val)
{
   aAddParams.push([String(cName),String(val)]);
   includeTracer.trace("Scoring System - adding parameter to sendscore string: " + String(cName) + "=" + String(val));
}
function ch()
{
   var cn = 300 * _level0.game_id;
   var _loc3_ = scripturl + "?cn=" + cn + "&gd=" + String(getTimer() - _level0.game_isLoaded);
   var _loc1_;
   var _loc2_;
   if(aAddParams.length > 0)
   {
      _loc1_ = 0;
      while(_loc1_ < aAddParams.length)
      {
         _loc2_ = "&asp_" + aAddParams[_loc1_][0] + "=" + aAddParams[_loc1_][1];
         _loc3_ += _loc2_;
         _loc1_ = _loc1_ + 1;
      }
   }
   _loc3_ += "&r=" + Math.random(999999999);
   objIncString.initBin();
   var sRaw = "ssnhsh=" + _level0.game_hash + "&ssnky=" + _level0.game_sk + "&gmd=" + _level0.game_id + "&scr=" + _SCORE.show() + "&frmrt=" + _level0.average_real_framerate + "&chllng=" + _level0.game_challenge + "&gmdrtn=" + String(getTimer() - _level0.game_isLoaded);
   var sSlashed = objIncString.addSlashes(sRaw);
   var sessionID = String(_level0.game_hash) + String(_level0.game_sk);
   _loc3_ += "&gmd_g=" + _level0.game_id + "&mltpl_g=" + _level0.game_multiple + "&gmdt_g=" + sSlashed + "&sh_g=" + _level0.game_hash + "&sk_g=" + _level0.game_sk + "&usrnm_g=" + _level0.game_username + "&dc_g=" + _level0.game_dailyChallenge;
   return _loc3_;
}
function resetvar()
{
   includeTracer.trace("resetvar called");
}
function resetscore()
{
   _SCORE = new evar(0,"SCORE","");
   _NEOPOINTS = new evar(0,"NEOPOINTS","");
   var _loc1_ = _level0.FG_SCRIPT_BASE;
   scripturl = _loc1_ + "high_scores/process_score.phtml";
   if(_loc1_.indexOf("dev") != -1)
   {
      if(_level0.game_psurl != "" && _level0.game_psurl != undefined)
      {
         scripturl = _loc1_ + _level0.game_psurl;
      }
   }
   _level100.include.traceon = _level100.include.debug;
   scorereport = customizedmeter.text.scoremessage;
   messagereport = customizedmeter.text.successmessage;
   total_neopoints = 0;
   score_success = 0;
   error_code = 0;
   aAddParams = [];
   _level100.include.gotoAndStop("idleframe");
   includeTracer.trace("Scoring System: Reset and Awaiting Commands",true);
   return 1;
}
function changeScoreTo(newvalue)
{
   _SCORE.changeto(newvalue);
}
function sendscore()
{
   var _loc1_;
   var _loc2_;
   if(this._currentframe == 5)
   {
      _NEOPOINTS.changeto(int(_level0.game_neopointratio * _SCORE.show()));
      _loc1_ = _level0.game_capOnNeopoints;
      _loc2_ = _NEOPOINTS.show();
      if(_loc2_ > _loc1_)
      {
         _NEOPOINTS.changeto(_loc1_);
      }
      else if(_loc2_ < - _loc1_)
      {
         _NEOPOINTS.changeto(- _loc1_);
      }
      false;
      this.gotoAndPlay("sendscoreframe");
   }
}
function reset()
{
   resetscore();
}
objIncString = new np.projects.include.Strings();
_SCORE = undefined;
_NEOPOINTS = undefined;
var aAddParams = [];
