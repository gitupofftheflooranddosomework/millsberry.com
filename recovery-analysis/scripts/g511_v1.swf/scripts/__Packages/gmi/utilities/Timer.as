class gmi.utilities.Timer extends MovieClip
{
   var _startTime;
   var _timeInterval;
   var _timeOut;
   var _timing;
   var dispatchEvent;
   var elapsedTime;
   var _pauseTime = 0;
   function Timer()
   {
      super();
      mx.events.EventDispatcher.initialize(this);
   }
   function start()
   {
      if(!this._timing)
      {
         this._timing = true;
         if(this._pauseTime)
         {
            this._startTime += getTimer() - this._pauseTime;
            this._pauseTime = 0;
         }
         else
         {
            this._startTime = getTimer();
         }
         this._timeInterval = setInterval(mx.utils.Delegate.create(this,this.checkTimeOut),10);
      }
   }
   function set time(t)
   {
      this._startTime = getTimer() - t;
   }
   function get time()
   {
      if(this._pauseTime)
      {
         return this._pauseTime - this._startTime;
      }
      var _loc2_ = getTimer();
      if(!_loc2_)
      {
         _loc2_ = 1;
      }
      return _loc2_ - this._startTime;
   }
   function updateTime()
   {
      this.elapsedTime = getTimer() - this._startTime;
      return this.elapsedTime;
   }
   function stop()
   {
      this._timing = false;
      if(!this._pauseTime)
      {
         this._pauseTime = getTimer();
      }
      clearInterval(this._timeInterval);
   }
   function reset(restart)
   {
      this._timing = false;
      clearInterval(this._timeInterval);
      this._startTime = getTimer();
      if(!this._startTime)
      {
         this._startTime = 1;
      }
      if(restart)
      {
         this._pauseTime = 0;
      }
      else
      {
         this._pauseTime = this._startTime;
      }
   }
   function get paused()
   {
      return !this._pauseTime ? false : true;
   }
   function set paused(p)
   {
      if(p == Boolean(this._pauseTime))
      {
         this._pauseTime = 0;
      }
      if(p)
      {
         this.stop();
      }
      else
      {
         this.start();
      }
   }
   function formatTime(msecs)
   {
      var _loc1_ = Math.floor(msecs / 10);
      var _loc2_ = Math.floor(_loc1_ / 100);
      var _loc3_ = Math.floor(_loc2_ / 60);
      _loc1_ %= 100;
      _loc2_ %= 60;
      _loc3_ %= 60;
      if(_loc1_ < 10)
      {
         _loc1_ = "0" + _loc1_;
      }
      if(_loc2_ < 10)
      {
         _loc2_ = "0" + _loc2_;
      }
      if(_loc3_ < 10)
      {
         _loc3_ = "0" + _loc3_;
      }
      return _loc3_ + ":" + _loc2_ + "." + _loc1_;
   }
   function unformatTime(time)
   {
      var _loc1_ = time.split(":");
      var _loc3_ = _loc1_[0].Number;
      var _loc4_ = _loc3_ * 60 + _loc1_[1].Number;
      var _loc2_ = _loc4_ * 100 + _loc1_[2].Number;
      var _loc5_ = _loc2_ * 10;
      return _loc5_;
   }
   function getMinutes(msecs)
   {
      var _loc1_ = Math.floor(msecs / 10);
      var _loc2_ = Math.floor(_loc1_ / 100);
      var _loc3_ = Math.floor(_loc2_ / 60);
      return Number(_loc3_ %= 60);
   }
   function set timeOut(timeout)
   {
      this._timeOut = timeout;
   }
   function get timeOut()
   {
      return this._timeOut;
   }
   function checkTimeOut()
   {
      if(this._timeOut != undefined && this.time > this._timeOut)
      {
         this.dispatchEvent({type:"onTimeOut",target:this,time:this.time});
         this.stop();
         this.reset();
      }
   }
}
