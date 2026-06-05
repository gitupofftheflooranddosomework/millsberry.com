_global.scoreBoardObject = function()
{
};
scoreBoardObject.prototype = new MovieClip();
var obj = scoreBoardObject.prototype;
obj.init = function()
{
   var _loc1_ = this;
   _loc1_._x = 0;
   _loc1_._y = 0;
   _loc1_.depth = 0;
   _loc1_.popUpDepth = 1000;
   _loc1_.tickDownDepth = 9800;
   _loc1_.layoutButtons();
   _loc1_.POINTSLEFT = new _global.gMyScoringSystem.Evar(0);
   _loc1_.tRoundShow = "<P ALIGN=\'CENTER\'>" + _root.IDS_ROUND_SB_TXT + _root.ROUND.show() + "</P>";
};
obj.setPrompt = function(headerText, bodyText)
{
   var _loc2_ = 24;
   var _loc1_ = 18;
   this.tPrompt = "<P ALIGN=\'CENTER\'><FONT SIZE=\'" + _loc2_ + "\'>" + headerText + "</FONT></P>" + "<P ALIGN=\'CENTER\'><FONT SIZE=\'" + _loc1_ + "\'>" + bodyText + "</FONT></P>";
};
obj.layoutButtons = function()
{
   var _loc2_ = this;
   _loc2_.buttonList = new Array();
   _loc2_.buttons = new Array();
   var buttonObj = function(message, myFunction, myName)
   {
      var _loc1_ = this;
      _loc1_.message = message;
      _loc1_.myFunction = myFunction;
      _loc1_.pName = myName;
   };
   var gameObj = Game.playground;
   var scrambleButtonCode = function()
   {
      _root.buttonSound.start();
      gameObj.doScramble();
   };
   var enterButtonCode = function()
   {
      _root.buttonSound.start();
      gameObj.enterFunctions();
   };
   var cancelButtonCode = function()
   {
      _root.buttonSound.start();
      gameObj.cancelBlocks();
   };
   var endButtonCode = function()
   {
      _root.buttonSound.start();
      Game.end("userQuit");
   };
   var nextLevelCode = function()
   {
      _root.buttonSound.start();
      this._parent.buttonsOff();
      Game.scoreboard.toggleTo("off");
      Game.endRound();
   };
   var centerAlign = "<P ALIGN=\'CENTER\'>";
   _loc2_.buttonList.push(new buttonObj(_root.IDS_ENTER_BTN_TXT,enterButtonCode,"enterButton"));
   _loc2_.buttonList.push(new buttonObj(_root.IDS_SCRAMBLE_BTN_TXT,scrambleButtonCode,"scrambleButton"));
   _loc2_.buttonList.push(new buttonObj(_root.IDS_CANCEL_BTN_TXT,cancelButtonCode,"cancelButton"));
   _loc2_.buttonList.push(new buttonObj(_root.IDS_ENDGAME_BTN_TXT,endButtonCode,"endGameButton"));
   _loc2_.buttonList.push(new buttonObj(_root.IDS_NEXTLEVEL_BTN_TXT,nextLevelCode,"nextlevelButton"));
   var b = 0;
   var _loc3_;
   var _loc1_;
   while(b < _loc2_.buttonList.length)
   {
      var obj = _loc2_.buttonList[b];
      _loc3_ = obj.pName;
      _loc2_.attachMovie("buttonMC",_loc3_,++_loc2_.depth);
      _loc1_ = _loc2_[_loc3_];
      _loc2_.buttons.push(_loc1_);
      _loc1_.pName = _loc3_;
      if(_loc3_ == "nextlevelButton")
      {
         _loc1_._visible = false;
         _loc1_.buttonFunction = obj.myFunction;
      }
      else
      {
         _loc1_.onRelease = obj.myFunction;
      }
      _loc1_.message.htmlText = obj.message;
      _loc1_._x = _root.sideBar._width / 2;
      _loc1_._y = 80 + b * (_loc1_._height + 6);
      b++;
   }
};
obj.setTimer = function(maximum)
{
   var _loc1_ = this;
   var numseconds = int(maximum / 1000);
   _loc1_.time = _loc1_.createEmptyMovieClip("time",1000);
   _loc1_.time.starting = 0;
   _loc1_.time.maximum = maximum;
   var _loc2_ = getTimer() - _loc1_.time.starting;
   _loc1_.time.remaining = _loc1_.time.maximum - _loc2_;
   _loc1_.ticking = 0;
   _loc1_.toggleTo("on");
};
obj.buttonsOff = function()
{
   var _loc3_ = this;
   var _loc2_ = _loc3_.buttons.length;
   var _loc1_ = 0;
   while(_loc1_ < _loc2_)
   {
      delete _loc3_.buttons[_loc1_].onRelease;
      _loc1_ = _loc1_ + 1;
   }
};
obj.toggleTo = function(state)
{
   var _loc1_ = this;
   var _loc3_ = _root;
   _loc1_.state = state;
   if(_loc1_.state == "on")
   {
      _loc1_.time.starting = getTimer();
      _loc1_.onEnterFrame = function()
      {
         var _loc1_ = this;
         var _loc3_ = _root;
         var _loc2_ = getTimer() - _loc1_.time.starting;
         _loc1_.time.remaining = _loc1_.time.maximum - _loc2_;
         if(_loc1_.time.remaining <= 0)
         {
            _loc3_.buzzerSound.start();
            _loc1_.toggleTo("off");
            _loc1_.time.remaining = 0;
            if(_loc3_.GAMESCORE.show() >= _loc3_.ROUNDSCORE.show())
            {
               Game.endRound();
            }
            else
            {
               delete _loc1_.scrambleButton.onRelease;
               delete _loc1_.enterButton.onRelease;
               delete _loc1_.cancelButton.onRelease;
               Game.end("timeout");
            }
         }
         _loc1_.showTime();
      };
   }
   else if(_loc1_.state == "off")
   {
      _loc1_.onEnterFrame = undefined;
   }
};
obj.createTicker = function()
{
   var _loc1_ = this;
   var _loc2_ = _loc1_.createEmptyMovieClip("tickDown",_loc1_.tickDownDepth);
   var time = _loc1_.time.remaining;
   _loc2_.pTime = int(time / 1000);
   _loc2_.onEnterFrame = function()
   {
      var _loc1_ = this;
      var _loc2_;
      if(_loc1_.pTime == 1)
      {
         _loc1_.removeMovieClip();
      }
      else
      {
         _loc2_ = int(_loc1_._parent.time.remaining / 1000);
         if(_loc1_.pTime != _loc2_)
         {
            _loc1_.pTime = _loc2_;
            _root.tickSound.start();
         }
      }
   };
};
obj.refreshDisplay = function()
{
   this.showScore();
   this.showTime();
};
obj.timeFormat = function(time)
{
   var _loc2_ = time;
   _loc2_ = int(_loc2_ / 1000);
   var minutes = int(_loc2_ / 60);
   var _loc1_ = String(_loc2_ % 60);
   if(_loc1_.length == 1)
   {
      _loc1_ = "0" + _loc1_;
   }
   var _loc3_ = minutes + ":" + _loc1_;
   return _loc3_;
};
obj.showTime = function()
{
   var _loc1_ = this;
   _loc1_.tTime = "<P ALIGN=\'LEFT\'>" + _root.IDS_TIME_SB_TXT + _loc1_.timeFormat(_loc1_.time.remaining) + "</P>";
   var _loc2_ = int(_loc1_.time.remaining / 1000);
   if(_loc2_ == 6)
   {
      if(!_loc1_.ticking)
      {
         _loc1_.ticking = 1;
         _loc1_.createTicker();
      }
   }
};
obj.showScore = function()
{
   var _loc1_ = this;
   var _loc2_ = _root;
   _loc1_.tScore = "<P ALIGN=\'LEFT\'>" + _loc2_.IDS_SCORE_SB_TXT + _loc2_.GAMESCORE.show() + "</P>";
   var pts_left = Math.max(0,_loc2_.ROUNDSCORE.show() - _loc2_.GAMESCORE.show());
   _loc1_.POINTSLEFT.changeTo(pts_left);
   _loc2_.PTSLEFT.changeTo(pts_left);
   _loc1_.tRoundScore = "<P ALIGN=\'CENTER\'>" + _loc2_.IDS_REQ_SB_TXT + pts_left + "</P>";
   var _loc3_ = _loc1_.nextlevelButton;
   if(_loc1_.POINTSLEFT.show() <= 0 and _loc3_._visible == false)
   {
      _loc2_.nextLevelSound.start();
      _loc3_.onRelease = _loc3_.buttonFunction;
      _loc3_._visible = true;
   }
};
Object.registerClass("scoreBoardMC",scoreBoardObject);
