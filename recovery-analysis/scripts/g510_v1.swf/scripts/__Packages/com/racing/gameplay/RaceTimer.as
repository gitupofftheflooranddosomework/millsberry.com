class com.racing.gameplay.RaceTimer extends MovieClip
{
   var elapsedH;
   var elapsedHours;
   var elapsedM;
   var elapsedS;
   var elapsedTime;
   var hundredths;
   var minutes;
   var remaining;
   var seconds;
   var startTime;
   var timeLeft;
   var timeLimit;
   var timing;
   var txt;
   static var __inst;
   var isWarning = false;
   var count = 4;
   function RaceTimer()
   {
      super();
      com.racing.gameplay.RaceTimer.__inst = this;
      var _loc4_ = com.racing.Application.getInstance();
      this.timeLimit = _loc4_.xmlObject.config.track[_loc4_.SESSION_DATA.curTrack - 1].course.attributes.timelimit;
      this.timing = false;
      var _loc6_ = Math.floor(this.timeLimit / 60);
      var _loc3_ = this.timeLimit % 60;
      var _loc5_ = _loc3_ >= 10 ? _loc3_.toString() : "0" + _loc3_.toString();
      this.txt.text = _loc6_ + ":" + _loc5_;
   }
   function initiateCountDown()
   {
      var _loc2_ = com.racing.gameplay.World.scenery.flag1.txt.txt;
      this.count -= 1;
      _loc2_.text = this.count;
      _loc2_._xscale = _loc2_._yscale = 259;
      _loc2_._x = (- _loc2_._width) / 2;
      _loc2_._y = (- _loc2_._height) / 2;
      com.racing.gameplay.SoundMan.playSound("beep");
      if(Number(_loc2_.text) >= 1)
      {
         gs.TweenMax.to(_loc2_,1,{_xscale:100,_yscale:100,_x:(- _loc2_._width) / 4,_y:(- _loc2_._height) / 4,ease:gs.easing.Elastic.easeIn,onComplete:com.dynamicflash.utils.Delegate.create(this,this.initiateCountDown),onCompleteScope:this});
      }
      else
      {
         _loc2_.text = "GO";
         this.startRace();
      }
   }
   function onEnterFrame()
   {
      if(this.timing)
      {
         this.elapsedTime = getTimer() - this.startTime;
         this.timeLeft = this.timeLimit * 1000 - this.elapsedTime;
         if(this.timeLeft <= 2100 && !this.isWarning)
         {
            com.racing.gameplay.SoundMan.playSound("warning");
            this.isWarning = true;
         }
         if(this.timeLeft <= 0)
         {
            trace("YOU LOSE!");
            this.timing = false;
            this.txt.text = "TIME\'S UP";
            com.racing.gameplay.SoundMan.playSound("wrong");
            com.racing.gameplay.SoundMan.playSound("skid");
            com.racing.gameplay.CoreCar.getInstance().kill();
            gs.TweenMax.delayedCall(1,com.racing.StateManager.goResults,[false],com.racing.StateManager,false);
            this.kill();
            return undefined;
         }
         this.elapsedHours = Math.floor(this.timeLeft / 3600000);
         this.remaining = this.timeLeft - this.elapsedHours * 3600000;
         this.elapsedM = Math.floor(this.remaining / 60000);
         this.remaining -= this.elapsedM * 60000;
         this.elapsedS = Math.floor(this.remaining / 1000);
         this.remaining -= this.elapsedS * 1000;
         this.elapsedH = Math.floor(this.remaining / 10);
         if(this.elapsedM < 10)
         {
            this.minutes = "0" + this.elapsedM.toString();
         }
         else
         {
            this.minutes = this.elapsedM.toString();
         }
         if(this.elapsedS < 10)
         {
            this.seconds = "0" + this.elapsedS.toString();
         }
         else
         {
            this.seconds = this.elapsedS.toString();
         }
         if(this.elapsedH < 10)
         {
            this.hundredths = "0" + this.elapsedH.toString();
         }
         else
         {
            this.hundredths = this.elapsedH.toString();
         }
         this.txt.text = this.elapsedM.toString() + ":" + this.seconds;
      }
   }
   function kill()
   {
      this.onEnterFrame = null;
   }
   function startRace()
   {
      com.racing.gameplay.World.manageQuality();
      this.startTime = getTimer();
      this.timing = true;
   }
   static function getInstance()
   {
      return com.racing.gameplay.RaceTimer.__inst;
   }
}
