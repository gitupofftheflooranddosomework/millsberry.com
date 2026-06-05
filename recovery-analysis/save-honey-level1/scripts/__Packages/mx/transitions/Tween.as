class mx.transitions.Tween
{
   var _duration;
   var _fps;
   var _intervalID;
   var _listeners;
   var _pos;
   var _startTime;
   var _time;
   var addListener;
   var begin;
   var broadcastMessage;
   var change;
   var isPlaying;
   var looping;
   var obj;
   var prevPos;
   var prevTime;
   var prop;
   var useSeconds;
   static var version = "1.1.0.52";
   static var __initBeacon = mx.transitions.OnEnterFrameBeacon.init();
   static var __initBroadcaster = mx.transitions.BroadcasterMX.initialize(mx.transitions.Tween.prototype,true);
   function Tween(obj, prop, func, begin, finish, duration, useSeconds)
   {
      mx.transitions.OnEnterFrameBeacon.init();
      if(!arguments.length)
      {
         return;
      }
      this.obj = obj;
      this.prop = prop;
      this.begin = begin;
      this.position = begin;
      this.duration = duration;
      this.useSeconds = useSeconds;
      if(func)
      {
         this.func = func;
      }
      this.finish = finish;
      this._listeners = [];
      this.addListener(this);
      this.start();
   }
   function set time(t)
   {
      this.prevTime = this._time;
      if(t > this.duration)
      {
         if(this.looping)
         {
            this.rewind(t - this._duration);
            this.update();
            this.broadcastMessage("onMotionLooped",this);
         }
         else
         {
            if(this.useSeconds)
            {
               this._time = this._duration;
               this.update();
            }
            this.stop();
            this.broadcastMessage("onMotionFinished",this);
         }
      }
      else if(t < 0)
      {
         this.rewind();
         this.update();
      }
      else
      {
         this._time = t;
         this.update();
      }
   }
   function get time()
   {
      return this._time;
   }
   function set duration(d)
   {
      this._duration = !(d == null || d <= 0) ? d : _global.Infinity;
   }
   function get duration()
   {
      return this._duration;
   }
   function set FPS(fps)
   {
      var _loc2_ = this.isPlaying;
      this.stopEnterFrame();
      this._fps = fps;
      if(_loc2_)
      {
         this.startEnterFrame();
      }
   }
   function get FPS()
   {
      return this._fps;
   }
   function set position(p)
   {
      this.setPosition(p);
   }
   function setPosition(p)
   {
      this.prevPos = this._pos;
      this.obj[this.prop] = this._pos = p;
      this.broadcastMessage("onMotionChanged",this,this._pos);
      updateAfterEvent();
   }
   function get position()
   {
      return this.getPosition();
   }
   function getPosition(t)
   {
      if(t == undefined)
      {
         t = this._time;
      }
      return this.func(t,this.begin,this.change,this._duration);
   }
   function set finish(f)
   {
      this.change = f - this.begin;
   }
   function get finish()
   {
      return this.begin + this.change;
   }
   function continueTo(finish, duration)
   {
      this.begin = this.position;
      this.finish = finish;
      if(duration != undefined)
      {
         this.duration = duration;
      }
      this.start();
   }
   function yoyo()
   {
      this.continueTo(this.begin,this.time);
   }
   function startEnterFrame()
   {
      if(this._fps == undefined)
      {
         _global.MovieClip.addListener(this);
      }
      else
      {
         this._intervalID = setInterval(this,"onEnterFrame",1000 / this._fps);
      }
      this.isPlaying = true;
   }
   function stopEnterFrame()
   {
      if(this._fps == undefined)
      {
         _global.MovieClip.removeListener(this);
      }
      else
      {
         clearInterval(this._intervalID);
      }
      this.isPlaying = false;
   }
   function start()
   {
      this.rewind();
      this.startEnterFrame();
      this.broadcastMessage("onMotionStarted",this);
   }
   function stop()
   {
      this.stopEnterFrame();
      this.broadcastMessage("onMotionStopped",this);
   }
   function resume()
   {
      this.fixTime();
      this.startEnterFrame();
      this.broadcastMessage("onMotionResumed",this);
   }
   function rewind(t)
   {
      this._time = t != undefined ? t : 0;
      this.fixTime();
      this.update();
   }
   function fforward()
   {
      this.time = this._duration;
      this.fixTime();
   }
   function nextFrame()
   {
      if(this.useSeconds)
      {
         this.time = (getTimer() - this._startTime) / 1000;
      }
      else
      {
         this.time = this._time + 1;
      }
   }
   function onEnterFrame()
   {
      this.nextFrame();
   }
   function prevFrame()
   {
      if(!this.useSeconds)
      {
         this.time = this._time - 1;
      }
   }
   function toString()
   {
      return "[Tween]";
   }
   function fixTime()
   {
      if(this.useSeconds)
      {
         this._startTime = getTimer() - this._time * 1000;
      }
   }
   function update()
   {
      this.position = this.getPosition(this._time);
   }
   function func(t, b, c, d)
   {
      return c * t / d + b;
   }
}
