class com.racing.screens.Results extends com.racing.screens.ScreenBase
{
   var __shell;
   var btnBtm;
   var btnTop;
   var dly;
   var errMsg;
   var losePanel;
   var prizePanel;
   var trackCompleted;
   var trackResult;
   var winPanel;
   static var __inst;
   var score = 0;
   function Results(mc)
   {
      super();
      com.racing.screens.Results.__inst = this;
      this.__shell = mc;
      this.init();
      this.hide();
   }
   function init()
   {
      this.btnBtm = this.__shell.btnBtm;
      this.btnTop = this.__shell.btnTop;
      this.errMsg = this.__shell.errMsg;
      this.losePanel = this.__shell.losePanel;
      this.winPanel = this.__shell.winPanel;
      this.prizePanel = this.__shell.prizePanel;
      this.defineCoords(this.btnBtm);
      this.defineCoords(this.btnTop);
      this.defineCoords(this.errMsg);
      this.defineCoords(this.losePanel);
      this.defineCoords(this.winPanel);
      this.defineCoords(this.prizePanel);
   }
   function show(success)
   {
      this.dly = 0.5;
      this.trackCompleted = com.racing.Application.getInstance().SESSION_DATA.curTrack;
      com.racing.Logo.update("results",0);
      this.trackResult = !success ? "lose" : "win";
      if(this.trackCompleted == 1)
      {
         this.resetScore();
      }
      this.getContent();
   }
   function hide()
   {
      var _loc2_ = Stage.width;
      gs.TweenMax.to(this.winPanel,0.5,{_x:_loc2_ + 400,_y:this.winPanel.Y + 200,ease:gs.easing.Cubic.easeInOut,onComplete:this.onHideComplete,onCompleteParams:[this.winPanel]});
      gs.TweenMax.to(this.losePanel,0.5,{_x:_loc2_ + 400,_y:this.losePanel.Y + 200,ease:gs.easing.Cubic.easeInOut,onComplete:this.onHideComplete,onCompleteParams:[this.losePanel]});
      gs.TweenMax.to(this.btnBtm,0.5,{_x:-200,_y:this.btnBtm.Y + 200,ease:gs.easing.Back.easeInOut,onComplete:this.onHideComplete,onCompleteParams:[this.btnBtm]});
      gs.TweenMax.to(this.btnTop,0.6,{_x:-200,_y:this.btnTop.Y - 200,ease:gs.easing.Back.easeInOut,onComplete:this.onHideComplete,onCompleteParams:[this.btnTop]});
      gs.TweenMax.to(this.errMsg,0.6,{_x:-200,_y:this.errMsg.Y - 500,ease:gs.easing.Back.easeInOut,onComplete:this.onHideComplete,onCompleteParams:[this.errMsg]});
      gs.TweenMax.to(this.prizePanel,0.5,{_x:_loc2_ + 400,_y:this.prizePanel.Y - 200,ease:gs.easing.Cubic.easeInOut,onComplete:this.onHideComplete,onCompleteParams:[this.prizePanel]});
   }
   function showPrize()
   {
      this.hide();
      this.dly = 0.2;
      this.showItem(this.prizePanel,0);
      gs.TweenMax.killTweensOf(this.btnTop);
      gs.TweenMax.to(this.btnTop,0.6,{_x:this.btnTop.X,_y:this.btnTop.Y - 50,ease:gs.easing.Back.easeInOut});
      this.setPlayAgain();
   }
   function getContent()
   {
      var _loc2_ = com.racing.Application.getInstance();
      var _loc3_ = this.__shell[this.trackResult + "Panel"];
      var _loc5_ = _loc2_.xmlObject.config.track[this.trackCompleted].name.value;
      this.showItem(_loc3_,0.6);
      _loc3_.gotoAndStop(this.trackCompleted);
      _loc3_.raceName.text = _loc5_;
      var _loc4_ = this.trackResult != "win" ? 1 : this.tallyScore();
      if(_loc2_.isLive)
      {
         com.racing.MB8Controller.changeScoreBy(_loc4_);
      }
      this.score = !_loc2_.isLive ? _loc4_ + this.score : com.racing.MB8Controller.getScore();
      _loc3_.score.text = this.score;
      if(this.trackResult == "win" && this.trackCompleted < 3)
      {
         this.btnTop.lbl.text = "KEEP PLAYING";
         this.btnTop.onRelease = com.dynamicflash.utils.Delegate.create(com.racing.StateManager,com.racing.StateManager.goRace,com.racing.screens.Results.__inst);
      }
      else
      {
         this.setPlayAgain();
      }
      if(_loc2_.isLive)
      {
         if(this.isSessionValid())
         {
            this.btnBtm.lbl.text = "SUBMIT SCORE";
            this.btnBtm.onRelease = com.dynamicflash.utils.Delegate.create(this,this.submitScore);
            this.showItem(this.btnBtm,0.07);
         }
      }
      this.showItem(this.btnTop,0);
   }
   function isSessionValid()
   {
      var _loc2_ = "";
      if(_level0._MB8_GAME_DATA.iVerifiedAct == 0)
      {
         _loc2_ = "Your game session failed verification. You can not submit your score";
      }
      else if(_level0._MB8_GAME_DATA.sUsername == "guest_user_account")
      {
         _loc2_ = "You are not logged in. You can not submit your score.";
      }
      else if(_level0._MB8_GAME_DATA.iScorePosts >= 3)
      {
         _loc2_ = "You have reached your maximum score submits for the day. You can not submit your score.";
      }
      if(_loc2_ != "")
      {
         this.showErrorMess(_loc2_);
         return false;
      }
      return true;
   }
   function showErrorMess(str)
   {
      this.errMsg.txt.autoSize = "center";
      this.errMsg.txt.text = str;
      this.errMsg.panel._width = this.errMsg.txt._width + 20;
      this.showItem(this.errMsg,0.07);
   }
   function setPlayAgain()
   {
      this.btnTop.lbl.text = "PLAY AGAIN";
      this.btnTop.onRelease = com.dynamicflash.utils.Delegate.create(com.racing.StateManager,com.racing.StateManager.goHome,com.racing.screens.Results.__inst);
   }
   function submitScore()
   {
      var _loc2_ = this.trackResult != "win" ? false : true;
      com.racing.MB8Controller.submitScore(_loc2_);
      this.prizePanel.prize.text = com.racing.MB8Controller.getPrize(this.score);
      this.prizePanel.bucks.text = com.racing.MB8Controller.getMillsbucks() + " MILLSBUCKS";
      this.showPrize();
   }
   function resetScore()
   {
      com.racing.MB8Controller.changeScoreBy(- this.score);
      this.score = 0;
      this.losePanel.score.text = 0;
      this.winPanel.score.text = 0;
      com.racing.MB8Controller.resetScore();
   }
   function tallyScore()
   {
      var _loc1_ = Number(com.racing.gameplay.RaceTimer.getInstance().seconds);
      if(_loc1_ == 0)
      {
         _loc1_ = 0.5;
      }
      _loc1_ *= 30;
      return _loc1_;
   }
   static function getInstance()
   {
      if(com.racing.screens.Results.__inst == undefined)
      {
         com.racing.screens.Results.__inst = new com.racing.screens.Results();
      }
      return com.racing.screens.Results.__inst;
   }
}
