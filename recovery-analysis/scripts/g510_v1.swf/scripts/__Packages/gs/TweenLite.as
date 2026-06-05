class gs.TweenLite
{
   var _hasPlugins;
   var _hasUpdate;
   var active;
   var combinedTimeScale;
   var delay;
   var duration;
   var ease;
   var endTargetID;
   var gc;
   var initTime;
   var initted;
   var startTime;
   var started;
   var target;
   var tweens;
   var vars;
   static var _gcInterval;
   static var _tlInitted;
   static var currentTime;
   static var overwriteManager;
   static var timerClip;
   static var version = 10.060000000000002;
   static var killDelayedCallsTo = gs.TweenLite.killTweensOf;
   static var masterList = {};
   static var plugins = {};
   static var _cnt = -16000;
   static var _reservedProps = {ease:1,delay:1,overwrite:1,onComplete:1,onCompleteParams:1,runBackwards:1,startAt:1,onUpdate:1,onUpdateParams:1,roundProps:1,onStart:1,onStartParams:1,persist:1,renderOnStart:1,proxiedEase:1,easeParams:1,yoyo:1,loop:1,onCompleteListener:1,onUpdateListener:1,onStartListener:1,orientToBezier:1};
   function TweenLite($target, $duration, $vars)
   {
      var _loc3_;
      if(gs.TweenLite.timerClip._visible != false || !gs.TweenLite._tlInitted)
      {
         gs.plugins.TweenPlugin.activate([gs.plugins.TintPlugin,gs.plugins.RemoveTintPlugin,gs.plugins.FramePlugin,gs.plugins.AutoAlphaPlugin,gs.plugins.VisiblePlugin,gs.plugins.VolumePlugin,gs.plugins.EndArrayPlugin]);
         gs.TweenLite.currentTime = getTimer();
         _loc3_ = 999;
         while(_root.getInstanceAtDepth(_loc3_) != undefined)
         {
            _loc3_ = _loc3_ + 1;
         }
         gs.TweenLite.timerClip = _root.createEmptyMovieClip("__tweenLite_mc",_loc3_);
         gs.TweenLite.timerClip._visible = false;
         clearInterval(gs.TweenLite._gcInterval);
         gs.TweenLite._gcInterval = setInterval(gs.TweenLite.killGarbage,2000);
         gs.TweenLite.timerClip.onEnterFrame = gs.TweenLite.updateAll;
         if(gs.TweenLite.overwriteManager == undefined)
         {
            gs.TweenLite.overwriteManager = {mode:1,enabled:false};
         }
         gs.TweenLite._tlInitted = true;
      }
      this.vars = $vars;
      this.duration = $duration || 0.001;
      this.delay = $vars.delay || 0;
      this.combinedTimeScale = $vars.timeScale || 1;
      this.active = Boolean($duration == 0 && this.delay == 0);
      this.target = $target;
      if(typeof this.vars.ease != "function")
      {
         this.vars.ease = gs.TweenLite.defaultEase;
      }
      if(this.vars.easeParams != undefined)
      {
         this.vars.proxiedEase = this.vars.ease;
         this.vars.ease = this.easeProxy;
      }
      this.ease = this.vars.ease;
      this.tweens = [];
      this.initted = false;
      this.initTime = gs.TweenLite.currentTime;
      this.startTime = this.initTime + this.delay * 1000;
      this.endTargetID = gs.TweenLite.getID($target,true);
      var _loc6_ = !($vars.overwrite == undefined || !gs.TweenLite.overwriteManager.enabled && $vars.overwrite > 1) ? Number($vars.overwrite) : gs.TweenLite.overwriteManager.mode;
      if(_loc6_ == 1 && $target != undefined)
      {
         delete gs.TweenLite.masterList[this.endTargetID];
         gs.TweenLite.masterList[this.endTargetID] = {target:$target,tweens:[this]};
      }
      else
      {
         gs.TweenLite.masterList[this.endTargetID].tweens.push(this);
      }
      if(this.active || this.vars.runBackwards == true && this.vars.renderOnStart != true)
      {
         this.initTweenVals();
         if(this.active)
         {
            this.render(this.startTime + 1);
         }
         else
         {
            this.render(this.startTime);
         }
         if(this.vars._visible != undefined && this.vars.runBackwards == true)
         {
            this.target._visible = this.vars._visible;
         }
      }
   }
   function initTweenVals()
   {
      var _loc2_;
      var _loc5_;
      var _loc4_;
      for(_loc2_ in this.vars)
      {
         if(gs.TweenLite._reservedProps[_loc2_] == undefined)
         {
            if(gs.TweenLite.plugins[_loc2_] != undefined)
            {
               _loc4_ = new gs.TweenLite.plugins[_loc2_]();
               if(_loc4_.onInitTween(this.target,this.vars[_loc2_],this) == false)
               {
                  this.tweens[this.tweens.length] = new gs.utils.tween.TweenInfo(this.target,_loc2_,this.target[_loc2_],typeof this.vars[_loc2_] != "number" ? Number(this.vars[_loc2_]) : this.vars[_loc2_] - this.target[_loc2_],_loc2_,false);
               }
               else
               {
                  this.tweens[this.tweens.length] = new gs.utils.tween.TweenInfo(_loc4_,"changeFactor",0,1,_loc4_.overwriteProps.length != 1 ? "_MULTIPLE_" : _loc4_.overwriteProps[0],true);
                  this._hasPlugins = true;
               }
            }
            else
            {
               this.tweens[this.tweens.length] = new gs.utils.tween.TweenInfo(this.target,_loc2_,this.target[_loc2_],typeof this.vars[_loc2_] != "number" ? Number(this.vars[_loc2_]) : this.vars[_loc2_] - this.target[_loc2_],_loc2_,false);
            }
         }
      }
      var _loc3_;
      if(this.vars.runBackwards == true)
      {
         _loc5_ = this.tweens.length - 1;
         while(_loc5_ > -1)
         {
            _loc3_ = this.tweens[_loc5_];
            _loc3_.start += _loc3_.change;
            _loc3_.change = - _loc3_.change;
            _loc5_ = _loc5_ - 1;
         }
      }
      if(this.vars.onUpdate != null)
      {
         this._hasUpdate = true;
      }
      if(gs.TweenLite.overwriteManager.enabled && gs.TweenLite.masterList[this.endTargetID] != undefined)
      {
         gs.TweenLite.overwriteManager.manageOverwrites(this,gs.TweenLite.masterList[this.endTargetID].tweens);
      }
      this.initted = true;
   }
   function activate()
   {
      this.started = this.active = true;
      if(!this.initted)
      {
         this.initTweenVals();
      }
      if(this.vars.onStart != undefined)
      {
         this.vars.onStart.apply(this.vars.onStartScope,this.vars.onStartParams);
      }
      if(this.duration == 0.001)
      {
         this.startTime -= 1;
      }
   }
   function render($t)
   {
      var _loc5_ = ($t - this.startTime) * 0.001;
      var _loc4_;
      var _loc2_;
      var _loc3_;
      if(_loc5_ >= this.duration)
      {
         _loc5_ = this.duration;
         _loc4_ = !(this.ease == this.vars.ease || this.duration == 0.001) ? 0 : 1;
      }
      else
      {
         _loc4_ = this.ease(_loc5_,0,1,this.duration);
      }
      _loc3_ = this.tweens.length - 1;
      while(_loc3_ > -1)
      {
         _loc2_ = this.tweens[_loc3_];
         _loc2_.target[_loc2_.property] = _loc2_.start + _loc4_ * _loc2_.change;
         _loc3_ = _loc3_ - 1;
      }
      if(this._hasUpdate)
      {
         this.vars.onUpdate.apply(this.vars.onUpdateScope,this.vars.onUpdateParams);
      }
      if(_loc5_ == this.duration)
      {
         this.complete(true);
      }
   }
   function complete($skipRender)
   {
      if($skipRender != true)
      {
         if(!this.initted)
         {
            this.initTweenVals();
         }
         this.startTime = gs.TweenLite.currentTime - this.duration * 1000 / this.combinedTimeScale;
         this.render(gs.TweenLite.currentTime);
         return undefined;
      }
      var _loc2_;
      if(this._hasPlugins)
      {
         _loc2_ = this.tweens.length - 1;
         while(_loc2_ > -1)
         {
            if(this.tweens[_loc2_].isPlugin == true && this.tweens[_loc2_].target.onComplete != undefined)
            {
               this.tweens[_loc2_].target.onComplete();
            }
            _loc2_ = _loc2_ - 1;
         }
      }
      if(this.vars.persist != true)
      {
         this.enabled = false;
      }
      if(this.vars.onComplete)
      {
         this.vars.onComplete.apply(this.vars.onCompleteScope,this.vars.onCompleteParams);
      }
   }
   function clear()
   {
      this.tweens = [];
      this.vars = {ease:this.vars.ease};
      this._hasUpdate = false;
   }
   function killVars($vars)
   {
      if(gs.TweenLite.overwriteManager.enabled)
      {
         gs.TweenLite.overwriteManager.killVars($vars,this.vars,this.tweens);
      }
   }
   static function to($target, $duration, $vars)
   {
      return new gs.TweenLite($target,$duration,$vars);
   }
   static function from($target, $duration, $vars)
   {
      $vars.runBackwards = true;
      return new gs.TweenLite($target,$duration,$vars);
   }
   static function delayedCall($delay, $onComplete, $onCompleteParams, $onCompleteScope)
   {
      return new gs.TweenLite($onComplete,0,{delay:$delay,onComplete:$onComplete,onCompleteParams:$onCompleteParams,onCompleteScope:$onCompleteScope,overwrite:0});
   }
   static function updateAll()
   {
      var _loc0_;
      var _loc4_ = gs.TweenLite.currentTime = getTimer();
      var _loc5_ = gs.TweenLite.masterList;
      var _loc6_;
      var _loc3_;
      var _loc2_;
      var _loc1_;
      for(_loc6_ in _loc5_)
      {
         _loc3_ = _loc5_[_loc6_].tweens;
         _loc2_ = _loc3_.length - 1;
         while(_loc2_ > -1)
         {
            _loc1_ = _loc3_[_loc2_];
            if(_loc1_.active)
            {
               _loc1_.render(_loc4_);
            }
            else if(_loc1_.gc)
            {
               _loc3_.splice(_loc2_,1);
            }
            else if(_loc4_ >= _loc1_.startTime)
            {
               _loc1_.activate();
               _loc1_.render(_loc4_);
            }
            _loc2_ = _loc2_ - 1;
         }
      }
   }
   static function getID($target, $lookup)
   {
      var _loc3_;
      var _loc1_;
      if($lookup)
      {
         _loc1_ = gs.TweenLite.masterList;
         if(typeof $target == "movieclip")
         {
            if(_loc1_[String($target)] != undefined)
            {
               return String($target);
            }
            _loc3_ = String($target);
            gs.TweenLite.masterList[_loc3_] = {target:$target,tweens:[]};
            return _loc3_;
         }
         for(var _loc4_ in _loc1_)
         {
            if(_loc1_[_loc4_].target == $target)
            {
               return _loc4_;
            }
         }
      }
      gs.TweenLite._cnt++;
      _loc3_ = "t" + gs.TweenLite._cnt;
      gs.TweenLite.masterList[_loc3_] = {target:$target,tweens:[]};
      return _loc3_;
   }
   static function removeTween($t, $clear)
   {
      if($clear != false)
      {
         $t.clear();
      }
      $t.enabled = false;
   }
   static function killTweensOf($target, $complete)
   {
      var _loc5_ = gs.TweenLite.getID($target,true);
      var _loc3_ = gs.TweenLite.masterList[_loc5_];
      var _loc2_;
      var _loc1_;
      if(_loc3_ != undefined)
      {
         _loc2_ = _loc3_.length - 1;
         while(_loc2_ > -1)
         {
            _loc1_ = _loc3_[_loc2_];
            if($complete && !_loc1_.gc)
            {
               _loc1_.complete(false);
            }
            _loc1_.clear();
            _loc2_ = _loc2_ - 1;
         }
         delete gs.TweenLite.masterList[_loc5_];
      }
   }
   static function killGarbage()
   {
      var _loc1_ = gs.TweenLite.masterList;
      var _loc2_;
      var _loc3_;
      for(_loc2_ in _loc1_)
      {
         if(_loc1_[_loc2_].tweens.length == 0)
         {
            delete _loc1_[_loc2_];
         }
      }
   }
   static function defaultEase($t, $b, $c, $d)
   {
      return (- $c) * ($t /= $d) * ($t - 2) + $b;
   }
   function easeProxy($t, $b, $c, $d)
   {
      return this.vars.proxiedEase.apply(null,arguments.concat(this.vars.easeParams));
   }
   function get enabled()
   {
      return !this.gc ? true : false;
   }
   function set enabled($b)
   {
      var _loc3_;
      var _loc4_;
      var _loc2_;
      if($b)
      {
         if(gs.TweenLite.masterList[this.endTargetID] == undefined)
         {
            gs.TweenLite.masterList[this.endTargetID] = {target:this.target,tweens:[this]};
         }
         else
         {
            _loc3_ = gs.TweenLite.masterList[this.endTargetID].tweens;
            _loc2_ = _loc3_.length - 1;
            while(_loc2_ > -1)
            {
               if(_loc3_[_loc2_] == this)
               {
                  _loc4_ = true;
                  break;
               }
               _loc2_ = _loc2_ - 1;
            }
            if(!_loc4_)
            {
               _loc3_[_loc3_.length] = this;
            }
         }
      }
      this.gc = !$b ? true : false;
      if(this.gc)
      {
         this.active = false;
      }
      else
      {
         this.active = this.started;
      }
   }
}
