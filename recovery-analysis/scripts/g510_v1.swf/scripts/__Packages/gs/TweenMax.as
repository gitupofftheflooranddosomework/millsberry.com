class gs.TweenMax extends gs.TweenLite
{
   var _hasPlugins;
   var _hasUpdate;
   var _repeatCount;
   var _thisReverseEase;
   var _timeScale;
   var _tweenID;
   var activate;
   var active;
   var combinedTimeScale;
   var delay;
   var duration;
   var ease;
   var initTime;
   var initted;
   var killVars;
   var pauseTime;
   var startTime;
   var started;
   var target;
   var tweens;
   var vars;
   static var version = 10.05;
   static var _activatedPlugins = gs.plugins.TweenPlugin.activate([gs.plugins.TintPlugin,gs.plugins.RemoveTintPlugin,gs.plugins.FramePlugin,gs.plugins.AutoAlphaPlugin,gs.plugins.VisiblePlugin,gs.plugins.VolumePlugin,gs.plugins.EndArrayPlugin,gs.plugins.HexColorsPlugin,gs.plugins.BlurFilterPlugin,gs.plugins.ColorMatrixFilterPlugin,gs.plugins.BevelFilterPlugin,gs.plugins.DropShadowFilterPlugin,gs.plugins.GlowFilterPlugin,gs.plugins.RoundPropsPlugin,gs.plugins.BezierPlugin,gs.plugins.BezierThroughPlugin,gs.plugins.ShortRotationPlugin]);
   static var _versionCheck = gs.TweenLite.version >= 10.05 ? true : (trace("TweenMax error! Please update your TweenLite class or try deleting your ASO files. TweenMax requires a more recent version. Download updates at http://www.TweenMax.com."),§§push(undefined),undefined);
   static var killTweensOf = gs.TweenLite.killTweensOf;
   static var killDelayedCallsTo = gs.TweenLite.killTweensOf;
   static var removeTween = gs.TweenLite.removeTween;
   static var _idCount = -16000;
   static var _overwriteMode = !gs.OverwriteManager.enabled ? gs.OverwriteManager.init() : gs.OverwriteManager.mode;
   static var _pausedTweens = {};
   static var _globalTimeScale = 1;
   function TweenMax($target, $duration, $vars)
   {
      super($target,$duration,$vars);
      gs.TweenMax._idCount++;
      this._tweenID = "t" + gs.TweenMax._idCount;
      this._thisReverseEase = mx.utils.Delegate.create(this,this.reverseEase);
      this._repeatCount = 0;
      if(this.combinedTimeScale != 1 && this.target instanceof gs.TweenMax)
      {
         this._timeScale = 1;
         this.combinedTimeScale = gs.TweenMax._globalTimeScale;
      }
      else
      {
         this._timeScale = this.combinedTimeScale;
         this.combinedTimeScale *= gs.TweenMax._globalTimeScale;
      }
      if(this.combinedTimeScale != 1 && this.delay != 0)
      {
         this.startTime = this.initTime + this.delay * (1000 / this.combinedTimeScale);
      }
      if(!isNaN(this.vars.yoyo) || !isNaN(this.vars.loop))
      {
         this.vars.persist = true;
      }
   }
   function initTweenVals()
   {
      if(this.vars.startAt != undefined)
      {
         this.vars.startAt.overwrite = 0;
         new gs.TweenMax(this.target,0,this.vars.startAt);
      }
      super.initTweenVals();
      var _loc8_;
      var _loc4_;
      var _loc5_;
      var _loc7_;
      var _loc9_;
      var _loc6_;
      var _loc3_;
      if(this.vars.roundProps instanceof Array && gs.TweenLite.plugins.roundProps != undefined)
      {
         _loc9_ = this.vars.roundProps;
         _loc8_ = _loc9_.length - 1;
         while(_loc8_ > -1)
         {
            _loc5_ = _loc9_[_loc8_];
            _loc4_ = this.tweens.length - 1;
            while(_loc4_ > -1)
            {
               _loc3_ = this.tweens[_loc4_];
               if(_loc3_.name == _loc5_)
               {
                  if(_loc3_.isPlugin)
                  {
                     _loc3_.target.round = true;
                  }
                  else if(_loc6_ == null)
                  {
                     _loc6_ = new gs.TweenLite.plugins.roundProps();
                     _loc6_.add(_loc3_.target,_loc5_,_loc3_.start,_loc3_.change);
                     this._hasPlugins = true;
                     this.tweens[_loc4_] = new gs.utils.tween.TweenInfo(_loc6_,"changeFactor",0,1,_loc5_,true);
                  }
                  else
                  {
                     _loc6_.add(_loc3_.target,_loc5_,_loc3_.start,_loc3_.change);
                     this.tweens.splice(_loc4_,1);
                  }
               }
               else if(_loc3_.isPlugin && _loc3_.name == "_MULTIPLE_" && !_loc3_.target.round)
               {
                  _loc7_ = " " + _loc3_.target.overwriteProps.join(" ") + " ";
                  if(_loc7_.indexOf(" " + _loc5_ + " ") != -1)
                  {
                     _loc3_.target.round = true;
                  }
               }
               _loc4_ = _loc4_ - 1;
            }
            _loc8_ = _loc8_ - 1;
         }
      }
   }
   function render($t)
   {
      var _loc5_ = ($t - this.startTime) * 0.001 * this.combinedTimeScale;
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
   function pause()
   {
      if(isNaN(this.pauseTime))
      {
         this.pauseTime = gs.TweenLite.currentTime;
         this.startTime = 999999999999999;
         this.enabled = false;
         gs.TweenMax._pausedTweens[this._tweenID] = this;
      }
   }
   function resume()
   {
      this.enabled = true;
      if(!isNaN(this.pauseTime))
      {
         this.initTime += gs.TweenLite.currentTime - this.pauseTime;
         this.startTime = this.initTime + this.delay * (1000 / this.combinedTimeScale);
         this.pauseTime = NaN;
         if(!this.started && gs.TweenLite.currentTime >= this.startTime)
         {
            this.activate();
         }
         else
         {
            this.active = this.started;
         }
         delete gs.TweenMax._pausedTweens[this._tweenID];
      }
   }
   function restart($includeDelay)
   {
      if($includeDelay == true)
      {
         this.initTime = gs.TweenLite.currentTime;
         this.startTime = gs.TweenLite.currentTime + this.delay * (1000 / this.combinedTimeScale);
      }
      else
      {
         this.startTime = gs.TweenLite.currentTime;
         this.initTime = gs.TweenLite.currentTime - this.delay * (1000 / this.combinedTimeScale);
      }
      this._repeatCount = 0;
      if(this.target != this.vars.onComplete)
      {
         this.render(this.startTime);
      }
      this.pauseTime = NaN;
      delete gs.TweenMax._pausedTweens[this._tweenID];
      this.enabled = true;
   }
   function reverse($adjustDuration, $forcePlay)
   {
      this.ease = this.vars.ease != this.ease ? this.vars.ease : this._thisReverseEase;
      var _loc2_ = this.progress;
      if($adjustDuration != false && _loc2_ > 0)
      {
         this.startTime = gs.TweenLite.currentTime - (1 - _loc2_) * this.duration * 1000 / this.combinedTimeScale;
         this.initTime = this.startTime - this.delay * (1000 / this.combinedTimeScale);
      }
      if($forcePlay != false)
      {
         if(_loc2_ < 1)
         {
            this.resume();
         }
         else
         {
            this.restart();
         }
      }
   }
   function reverseEase($t, $b, $c, $d)
   {
      return this.vars.ease($d - $t,$b,$c,$d);
   }
   function invalidate($adjustStartValues)
   {
      var _loc2_;
      if(this.initted)
      {
         _loc2_ = this.progress;
         if($adjustStartValues != true && _loc2_ != 0)
         {
            this.progress = 0;
         }
         this.tweens = [];
         this.initTweenVals();
         this._timeScale = this.vars.timeScale || 1;
         this.combinedTimeScale = this._timeScale * gs.TweenMax._globalTimeScale;
         this.delay = this.vars.delay || 0;
         if(isNaN(this.pauseTime))
         {
            this.startTime = this.initTime + this.delay * 1000 / this.combinedTimeScale;
         }
         if(_loc2_ != 0)
         {
            if($adjustStartValues)
            {
               this.adjustStartValues();
            }
            else
            {
               this.progress = _loc2_;
            }
         }
      }
   }
   function setDestination($property, $value, $adjustStartValues)
   {
      var _loc9_ = this.progress;
      var _loc2_;
      var _loc8_;
      var _loc11_;
      var _loc10_;
      var _loc5_;
      var _loc6_;
      var _loc3_;
      var _loc4_;
      if(this.initted)
      {
         if($adjustStartValues == false && _loc9_ != 0)
         {
            _loc2_ = this.tweens.length - 1;
            while(_loc2_ > -1)
            {
               if(this.tweens[_loc2_].name == $property)
               {
                  this.tweens[_loc2_].target[this.tweens[_loc2_].property] = this.tweens[_loc2_].start;
               }
               _loc2_ = _loc2_ - 1;
            }
         }
         _loc8_ = this.vars;
         _loc11_ = this.tweens;
         _loc10_ = this._hasPlugins;
         this.tweens = [];
         this.vars = {};
         this.vars[$property] = $value;
         this.initTweenVals();
         if(this.ease != this._thisReverseEase && typeof _loc8_.ease == "function")
         {
            this.ease = _loc8_.ease;
         }
         if($adjustStartValues != false && _loc9_ != 0)
         {
            this.adjustStartValues();
         }
         _loc5_ = this.tweens;
         this.vars = _loc8_;
         this.tweens = _loc11_;
         _loc6_ = {};
         _loc2_ = _loc5_.length - 1;
         while(_loc2_ > -1)
         {
            if(_loc5_[_loc2_].name == "_MULTIPLE_")
            {
               _loc4_ = _loc5_[_loc2_].target.overwriteProps;
               _loc3_ = _loc4_.length - 1;
               while(_loc3_ > -1)
               {
                  _loc6_[_loc4_[_loc3_]] = true;
                  _loc3_ = _loc3_ - 1;
               }
            }
            else
            {
               _loc6_[_loc5_[_loc2_].name] = true;
            }
            _loc2_ = _loc2_ - 1;
         }
         this.killVars(_loc6_);
         this.tweens = this.tweens.concat(_loc5_);
         this._hasPlugins = Boolean(_loc10_ || this._hasPlugins);
      }
      this.vars[$property] = $value;
   }
   function adjustStartValues()
   {
      var _loc7_ = this.progress;
      var _loc6_;
      var _loc5_;
      var _loc3_;
      var _loc2_;
      var _loc4_;
      if(_loc7_ != 0)
      {
         _loc6_ = this.ease(_loc7_,0,1,1);
         _loc5_ = 1 / (1 - _loc6_);
         _loc4_ = this.tweens.length - 1;
         while(_loc4_ > -1)
         {
            _loc2_ = this.tweens[_loc4_];
            _loc3_ = _loc2_.start + _loc2_.change;
            if(_loc2_.isPlugin)
            {
               _loc2_.change = (_loc3_ - _loc6_) * _loc5_;
            }
            else
            {
               _loc2_.change = (_loc3_ - _loc2_.target[_loc2_.property]) * _loc5_;
            }
            _loc2_.start = _loc3_ - _loc2_.change;
            _loc4_ = _loc4_ - 1;
         }
      }
   }
   function killProperties($names)
   {
      var _loc4_ = {};
      var _loc2_;
      _loc2_ = $names.length - 1;
      while(_loc2_ > -1)
      {
         _loc4_[$names[_loc2_]] = true;
         _loc2_ = _loc2_ - 1;
      }
      this.killVars(_loc4_);
   }
   function complete($skipRender)
   {
      if(!isNaN(this.vars.yoyo) && (this._repeatCount < this.vars.yoyo || this.vars.yoyo == 0) || !isNaN(this.vars.loop) && (this._repeatCount < this.vars.loop || this.vars.loop == 0))
      {
         this._repeatCount = this._repeatCount + 1;
         if(!isNaN(this.vars.yoyo))
         {
            this.ease = this.vars.ease != this.ease ? this.vars.ease : this.reverseEase;
         }
         this.startTime = !$skipRender ? gs.TweenLite.currentTime : this.startTime + this.duration * (1000 / this.combinedTimeScale);
         this.initTime = this.startTime - this.delay * (1000 / this.combinedTimeScale);
      }
      else if(this.vars.persist == true)
      {
         this.pause();
      }
      super.complete($skipRender);
   }
   static function to($target, $duration, $vars)
   {
      return new gs.TweenMax($target,$duration,$vars);
   }
   static function from($target, $duration, $vars)
   {
      $vars.runBackwards = true;
      return new gs.TweenMax($target,$duration,$vars);
   }
   static function delayedCall($delay, $onComplete, $onCompleteParams, $onCompleteScope, $persist)
   {
      return new gs.TweenMax($onComplete,0,{delay:$delay,onComplete:$onComplete,onCompleteParams:$onCompleteParams,onCompleteScope:$onCompleteScope,persist:$persist,overwrite:0});
   }
   static function getTweensOf($target)
   {
      var _loc3_ = gs.TweenLite.masterList[gs.TweenLite.getID($target,true)].tweens;
      var _loc2_ = [];
      var _loc1_;
      if(_loc3_ != undefined)
      {
         _loc1_ = _loc3_.length - 1;
         while(_loc1_ > -1)
         {
            if(!_loc3_[_loc1_].gc)
            {
               _loc2_[_loc2_.length] = _loc3_[_loc1_];
            }
            _loc1_ = _loc1_ - 1;
         }
      }
      for(var _loc5_ in gs.TweenMax._pausedTweens)
      {
         if(gs.TweenMax._pausedTweens[_loc5_].target == $target)
         {
            _loc2_[_loc2_.length] = gs.TweenMax._pausedTweens[_loc5_];
         }
      }
      return _loc2_;
   }
   static function setGlobalTimeScale($scale)
   {
      if($scale < 0.00001)
      {
         $scale = 0.00001;
      }
      var _loc3_ = gs.TweenLite.masterList;
      var _loc4_;
      var _loc1_;
      var _loc2_;
      gs.TweenMax._globalTimeScale = $scale;
      for(_loc4_ in _loc3_)
      {
         _loc2_ = _loc3_[_loc4_].tweens;
         _loc1_ = _loc2_.length - 1;
         while(_loc1_ > -1)
         {
            if(_loc2_[_loc1_] instanceof gs.TweenMax)
            {
               _loc2_[_loc1_].timeScale *= 1;
            }
            _loc1_ = _loc1_ - 1;
         }
      }
   }
   static function isTweening($target)
   {
      var _loc2_ = gs.TweenMax.getTweensOf($target);
      var _loc1_ = 0;
      while(_loc1_ < _loc2_.length)
      {
         if(_loc2_[_loc1_].active && !_loc2_[_loc1_].gc)
         {
            return true;
         }
         _loc1_ = _loc1_ + 1;
      }
      return false;
   }
   static function getAllTweens()
   {
      var _loc5_ = gs.TweenLite.masterList;
      var _loc3_ = [];
      var _loc2_;
      var _loc4_;
      var _loc1_;
      for(_loc4_ in _loc5_)
      {
         _loc2_ = _loc5_[_loc4_].tweens;
         _loc1_ = _loc2_.length - 1;
         while(_loc1_ > -1)
         {
            if(!_loc2_[_loc1_].gc)
            {
               _loc3_[_loc3_.length] = _loc2_[_loc1_];
            }
            _loc1_ = _loc1_ - 1;
         }
      }
      for(_loc4_ in gs.TweenMax._pausedTweens)
      {
         _loc3_[_loc3_.length] = gs.TweenMax._pausedTweens[_loc4_];
      }
      return _loc3_;
   }
   static function killAllTweens($complete)
   {
      gs.TweenMax.killAll($complete,true,false);
   }
   static function killAllDelayedCalls($complete)
   {
      gs.TweenMax.killAll($complete,false,true);
   }
   static function killAll($complete, $tweens, $delayedCalls)
   {
      if($tweens == undefined)
      {
         $tweens = true;
      }
      if($delayedCalls == undefined)
      {
         $delayedCalls = false;
      }
      var _loc2_ = gs.TweenMax.getAllTweens();
      var _loc3_;
      var _loc1_ = _loc2_.length - 1;
      while(_loc1_ > -1)
      {
         _loc3_ = _loc2_[_loc1_].target == _loc2_[_loc1_].vars.onComplete;
         if(_loc3_ == $delayedCalls || _loc3_ != $tweens)
         {
            if($complete)
            {
               _loc2_[_loc1_].complete(false);
               _loc2_[_loc1_].clear();
            }
            else
            {
               gs.TweenLite.removeTween(_loc2_[_loc1_],true);
            }
         }
         _loc1_ = _loc1_ - 1;
      }
   }
   static function pauseAll($tweens, $delayedCalls)
   {
      gs.TweenMax.changePause(true,$tweens,$delayedCalls);
   }
   static function resumeAll($tweens, $delayedCalls)
   {
      gs.TweenMax.changePause(false,$tweens,$delayedCalls);
   }
   static function changePause($pause, $tweens, $delayedCalls)
   {
      if($pause == undefined)
      {
         $pause = true;
      }
      if($tweens == undefined)
      {
         $tweens = true;
      }
      if($delayedCalls == undefined)
      {
         $delayedCalls = false;
      }
      var _loc2_ = gs.TweenMax.getAllTweens();
      var _loc3_;
      var _loc1_ = _loc2_.length - 1;
      while(_loc1_ > -1)
      {
         _loc3_ = _loc2_[_loc1_].target == _loc2_[_loc1_].vars.onComplete;
         if(_loc2_[_loc1_] instanceof gs.TweenMax && (_loc3_ == $delayedCalls || _loc3_ != $tweens))
         {
            _loc2_[_loc1_].paused = $pause;
         }
         _loc1_ = _loc1_ - 1;
      }
   }
   function get paused()
   {
      return isNaN(this.pauseTime);
   }
   function set paused($b)
   {
      if($b)
      {
         this.pause();
      }
      else
      {
         this.resume();
      }
   }
   function get reversed()
   {
      return this.ease == this._thisReverseEase;
   }
   function set reversed($b)
   {
      if(this.reversed != $b)
      {
         this.reverse();
      }
   }
   function get timeScale()
   {
      return this._timeScale;
   }
   function set timeScale($n)
   {
      var _loc0_;
      if($n < 0.00001)
      {
         $n = this._timeScale = 0.00001;
      }
      else
      {
         this._timeScale = $n;
         $n *= gs.TweenMax._globalTimeScale;
      }
      this.initTime = gs.TweenLite.currentTime - (gs.TweenLite.currentTime - this.initTime - this.delay * (1000 / this.combinedTimeScale)) * this.combinedTimeScale * (1 / $n) - this.delay * (1000 / $n);
      if(this.startTime != 999999999999999)
      {
         this.startTime = this.initTime + this.delay * (1000 / $n);
      }
      this.combinedTimeScale = $n;
   }
   function set enabled($b)
   {
      if(!$b)
      {
         delete gs.TweenMax._pausedTweens[this._tweenID];
      }
      super.enabled = $b;
      if($b)
      {
         this.combinedTimeScale = this._timeScale * gs.TweenMax._globalTimeScale;
      }
   }
   static function set globalTimeScale($n)
   {
      gs.TweenMax.setGlobalTimeScale($n);
   }
   static function get globalTimeScale()
   {
      return gs.TweenMax._globalTimeScale;
   }
   function get progress()
   {
      var _loc3_ = isNaN(this.pauseTime) ? gs.TweenLite.currentTime : this.pauseTime;
      var _loc2_ = ((_loc3_ - this.initTime) * 0.001 - this.delay / this.combinedTimeScale) / this.duration * this.combinedTimeScale;
      if(_loc2_ > 1)
      {
         return 1;
      }
      if(_loc2_ < 0)
      {
         return 0;
      }
      return _loc2_;
   }
   function set progress($n)
   {
      this.startTime = gs.TweenLite.currentTime - this.duration * $n * 1000;
      this.initTime = this.startTime - this.delay * (1000 / this.combinedTimeScale);
      if(!this.started)
      {
         this.activate();
      }
      this.render(gs.TweenLite.currentTime);
      if(!isNaN(this.pauseTime))
      {
         this.pauseTime = gs.TweenLite.currentTime;
         this.startTime = 999999999999999;
         this.active = false;
      }
   }
}
