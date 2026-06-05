function getLangGroup(game_lang)
{
   var _loc1_ = ["EN","PT","DE","FR","IT","ES","NL"];
   var _loc2_ = String("NW");
   for(var _loc3_ in _loc1_)
   {
      if(game_lang.toUpperCase() == _loc1_[_loc3_].toUpperCase())
      {
         _loc2_ = "WE";
         break;
      }
   }
   langGroup_str = String(_loc2_).toUpperCase();
   return langGroup_str;
}
function initScoringMeter()
{
   var _loc1_;
   var _loc2_;
   if(customizedmeter.swf != undefined)
   {
      _loc1_ = _level0.FG_GAME_BASE;
      _loc2_ = _loc1_ + "games/utilities/scoring_meters/" + customizedmeter.swf;
      scoringmeter.box.loadMovie(_loc2_);
   }
   hidescoringmeter();
}
function hidescoringmeter()
{
   scoringmeter.gotoAndStop("start");
   scoringmeter.box.gotoAndStop("empty");
   scoringmeter._visible = false;
}
function setText1(cStr)
{
   scoringmeter.textbox1.text1.htmlText = cStr;
   if(customizedmeter.color.text1 != undefined)
   {
      scoringmeter.textbox1.text1.textColor = customizedmeter.color.text1;
   }
}
function setText2(cStr)
{
   scoringmeter.textbox2.text1.htmlText = cStr;
   if(customizedmeter.color.text2 != undefined)
   {
      scoringmeter.textbox2.text1.textColor = customizedmeter.color.text2;
   }
}
function setText3(cStr)
{
   scoringmeter.textbox3.text1.htmlText = cStr;
   if(customizedmeter.color.text3 != undefined)
   {
      scoringmeter.textbox3.text1.textColor = customizedmeter.color.text3;
   }
}
function newSendscore()
{
   var _loc1_ = 0;
   if(metervisible == 0)
   {
      scoringMeterVisible = false;
   }
   if(_SCORE.show() <= minscorevalue)
   {
      _loc1_ = 4;
   }
   else if(_level0.game_username == "guest_user_account")
   {
      _loc1_ = 8;
   }
   else if(_level0.game_scoreposts >= _level0.game_playsAllowed)
   {
      if(_level0.game_challenge != 1 && _level0.game_dailyChallenge != 1)
      {
         _loc1_ = 3;
      }
   }
   var _loc3_ = _SCORE.show();
   if(_loc3_ > _level0.game_hiscore)
   {
      _level0.game_hiscore = _loc3_;
   }
   var _loc2_ = "";
   scoringmeter.gotoAndStop("pending");
   scoringmeter._visible = scoringMeterVisible;
   scoringmeter.box.gotoAndStop("idle");
   scoringmeter.box._visible = scoringMeterVisible;
   scoringmeter.shadow._visible = scoringMeterVisible;
   scoringmeter.slider._visible = false;
   setTextFields();
   _loc2_ = _level0.IDS_SM_TAG1_OPEN + _level0.IDS_SM_score + " " + String(_SCORE.show());
   _loc2_ += "   " + _level0.IDS_SM_npscore + " " + String(_NEOPOINTS.show()) + _level0.IDS_SM_TAG_CLOSE;
   setText1(_loc2_);
   if(_loc1_ == 0)
   {
      objSendScore.sendAndLoad(ch(),objSendScore,"POST");
      scoreWasSent = true;
      _loc2_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_pending + _level0.IDS_SM_TAG_CLOSE;
      setText2(_loc2_);
   }
   else if(!scoringMeterVisible)
   {
      restartGame();
   }
   else
   {
      scoreWasSent = false;
      showMsg(_loc1_);
   }
}
function showmsg(msgID, newNP)
{
   var _loc1_ = "";
   switch(msgID)
   {
      case 1:
         scoringmeter.gotoAndStop("success");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_success + " " + String(newNP) + _level0.IDS_SM_TAG_CLOSE;
         break;
      case 2:
         scoringmeter.gotoAndStop("success");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_bonus + " " + String(newNP);
         break;
      case 3:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_MAXPLAYS;
         break;
      case 4:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_ZEROSCORE;
         break;
      case 5:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_UNKNOWN;
         break;
      case 6:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_INVALID;
         break;
      case 7:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_TIMEOUT;
         break;
      case 8:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_NOLOGIN;
         break;
      case 9:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_CHALLENGE;
         break;
      case 10:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_COOKIE;
         break;
      case 11:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_NOCHALL;
         break;
      case 12:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_CHALLSLOW;
         break;
      case 13:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_DC_COMP;
         break;
      case 14:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_DC_TIME;
         break;
      case 15:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_REVIEW;
         break;
      case 16:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_QUICK_SESSION;
         break;
      case 17:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_MISSING_HASH;
         break;
      case 18:
         scoringmeter.gotoAndStop("error");
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_SM_ERR_WC_TOO_LOW;
   }
   var _loc3_ = objScoreMeterVars.message;
   if(_loc3_.length > 0)
   {
      _loc1_ = _level0.IDS_SM_TAG2_OPEN + "<font face=\'customFSS_fnt\' size=\'14\' color=\'#ff0000\'>";
      _loc1_ += unescape(_loc3_) + "</font>";
   }
   setTextFields();
   if(msgID < 3)
   {
      _level0.game_isLoaded = getTimer();
      _loc1_ += "\n" + _level0.IDS_SM_hiscore + " " + String(_level0.game_hiscore);
      _loc1_ += "\n" + _level0.IDS_SM_plays + " " + String(_level0.game_scoreposts) + _level0.IDS_SM_TAG_CLOSE;
   }
   var _loc2_ = objScoreMeterVars.IDS_MSG;
   if(_loc2_ != undefined)
   {
      if(int(_loc2_) == 1)
      {
         var oldCStr = _loc1_;
         _loc1_ = _level0.IDS_SM_TAG2_OPEN + _level0.IDS_MESSAGE_1 + _level0.IDS_SM_TAG_CLOSE;
         _loc1_ += "<br>" + oldCStr;
      }
   }
   setText2(_loc1_);
   _loc1_ = _level0.IDS_SM_TAG3_OPEN + _level0.IDS_SM_restart + _level0.IDS_SM_TAG_CLOSE;
   setText3(_loc1_);
   if(scoringmeter.textbox2.text1.maxscroll > 1)
   {
      scoringmeter.slider._visible = scoringMeterVisible;
   }
   scoringmeter.box.gotoAndStop("stop");
}
function showLogin()
{
   var _loc1_ = "?destination=" + _level0.game_destination;
   getURL("javascript:var newwin=window.open(\"http://www.neopets.com/loginpage.phtml" + _loc1_ + "\", \"\", \"\" ); window.close();","");
}
function showSignup()
{
   var _loc1_ = "?destination=" + _level0.game_destination;
   getURL("javascript:var newwin=window.open(\"http://www.neopets.com/signup_age.phtml" + _loc1_ + "\", \"\", \"\" ); window.close();","");
}
function validateEmail()
{
   var _loc1_ = "?destination=" + _level0.game_destination;
   getURL("javascript:var st_win=window.open(\"http://www.neopets.com/activate.phtml" + _loc1_ + "\", \"\", \"\"); window.close();","");
}
function showChallenge()
{
   var _loc1_ = "?destination=" + _level0.game_destination;
   getURL("javascript:var st_win=window.open(\"http://www.neopets.com/challenges/challenge_list.phtml" + _loc1_ + "\", \"\", \"\");","");
}
function restartGame()
{
   hidescoringmeter();
   if(_level10 != undefined)
   {
      _level10.gotoAndStop(scoresentframe);
   }
   else
   {
      _level0.gotoAndStop(scoresentframe);
   }
   gotoAndStop("idleframe");
}
function setTextFields()
{
   var _loc2_ = [];
   _loc2_.push([scoringmeter.textbox1.text1,""]);
   _loc2_.push([scoringmeter.textbox2.text1,""]);
   _loc2_.push([scoringmeter.textbox3.text1,""]);
   var _loc1_ = 0;
   while(_loc1_ < _loc2_.length)
   {
      _loc2_[_loc1_][0].embedFonts = _level0.game_bEmbedFonts;
      _loc2_[_loc1_][0].html = true;
      _loc2_[_loc1_][0].selectable = false;
      _loc1_ = _loc1_ + 1;
   }
}
scoreWasSent = false;
objSendScore = new LoadVars();
objScoreMeterVars = {};
scoringMeterVisible = true;
objSendScore.onData = function(data)
{
   var _loc3_;
   var _loc1_;
   var _loc2_;
   if(scoreWasSent)
   {
      scoreWasSent = false;
      _loc3_ = 0;
      var newNP = 0;
      if(data == undefined)
      {
         _loc3_ = 5;
      }
      else
      {
         objScoreMeterVars = {};
         var aParsed = data.split("&");
         _loc1_ = 0;
         while(_loc1_ < aParsed.length)
         {
            _loc2_ = aParsed[_loc1_].split("=");
            objScoreMeterVars[_loc2_[0]] = _loc2_[1];
            _loc1_ = _loc1_ + 1;
         }
         _level0.game_scoreposts = objScoreMeterVars.plays;
         if(objScoreMeterVars.errcode == 18)
         {
            _loc3_ = 18;
         }
         else if(objScoreMeterVars.errcode == 17)
         {
            _loc3_ = 17;
         }
         else if(objScoreMeterVars.errcode == 16)
         {
            _loc3_ = 16;
         }
         else if(objScoreMeterVars.errcode == 15)
         {
            _loc3_ = 15;
         }
         else if(objScoreMeterVars.errcode == 14)
         {
            _loc3_ = 14;
         }
         else if(objScoreMeterVars.errcode == 13)
         {
            _loc3_ = 13;
         }
         else if(objScoreMeterVars.errcode == 12)
         {
            _loc3_ = 12;
         }
         else if(objScoreMeterVars.errcode == 11)
         {
            _loc3_ = 11;
         }
         else if(objScoreMeterVars.errcode == 10)
         {
            _loc3_ = 10;
         }
         else if(objScoreMeterVars.errcode == 9)
         {
            _loc3_ = 9;
         }
         else if(objScoreMeterVars.errcode > 0)
         {
            _loc3_ = 5;
         }
         else if(objScoreMeterVars.success == 2)
         {
            _loc3_ = 2;
         }
         else
         {
            _loc3_ = 1;
         }
         if(objScoreMeterVars.sh != undefined)
         {
            _level0.game_hash = objScoreMeterVars.sh;
         }
         if(objScoreMeterVars.sk != undefined)
         {
            _level0.game_sk = objScoreMeterVars.sk;
         }
         if(objScoreMeterVars.call_url != "" && objScoreMeterVars.call_url != undefined)
         {
            var new_call_url = unescape(objScoreMeterVars.call_url);
            getURL(new_call_url,"_blank");
         }
      }
      if(!scoringMeterVisible)
      {
         restartGame();
      }
      else
      {
         gotoAndStop("promptuserframe");
         showMsg(_loc3_,objScoreMeterVars.np);
      }
   }
};
_level0.game_bEmbedFonts = getLangGroup(_level0.game_lang) == "WE";
