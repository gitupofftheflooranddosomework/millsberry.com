class com.racing.gameplay.World
{
   var __shell;
   var _alpha;
   static var LAPSREQUIRED;
   static var scenery;
   static var FLEN = 20;
   static var CLIPDIST = 500;
   static var NUM_WAYPOINTS = 16;
   static var NUM_CPOINTS = 4;
   static var BASEDEPTH = 20000;
   var stripes = 90;
   var numtrees = 11;
   var numenemies = 3;
   var numsigns = 11;
   var initx = 385;
   var inity = -80;
   var offsetX = 1.78;
   var offsetY = 1.94;
   var showBlimp = true;
   function World(clip)
   {
      this.__shell = clip;
      var _loc2_ = com.racing.Application.getInstance();
      com.racing.gameplay.World.LAPSREQUIRED = _loc2_.xmlObject.config.track[_loc2_.SESSION_DATA.curTrack - 1].course.attributes.lapsrequired;
      com.racing.gameplay.World.scenery = this.__shell.createEmptyMovieClip("scenery",1);
      com.racing.gameplay.World.scenery.createEmptyMovieClip("carp",1);
      com.racing.gameplay.World.scenery.carp.swapDepths(-11);
      com.racing.gameplay.World.scenery._x = 0;
      com.racing.gameplay.World.scenery._y = 90;
      this.init();
      if(this.__shell.dashboard.btnCover)
      {
         this.initStatCover();
      }
      this.changeMusic(_loc2_.SESSION_DATA.curTrack);
   }
   function initStatCover()
   {
      this.__shell.dashboard.btnCover.onRelease = function()
      {
         this._alpha = this._alpha != 0 ? 0 : 100;
      };
      this.__shell.dashboard.btnCover.useHandCursor = false;
   }
   function traceParent(c)
   {
      if(c._parent)
      {
         trace(c._parent + " :: " + c._parent._xscale + ", " + c._parent._yscale);
         this.traceParent(c._parent);
      }
   }
   function init()
   {
      var _loc4_;
      var _loc3_;
      var _loc5_;
      var _loc2_;
      var _loc6_;
      var _loc8_;
      var _loc7_ = 2.9;
      var _loc11_ = -80;
      var _loc10_ = 240;
      this.__shell.mapp.map.gotoAndStop(2);
      _loc2_ = 1;
      while(_loc2_ <= this.stripes)
      {
         _loc4_ = this.__shell.scenery.attachMovie("track01","t0" + _loc2_,_loc2_);
         _loc4_._x = 200;
         _loc4_._y = 300;
         _loc6_ = _loc2_ / 70;
         _loc4_._yscale = _loc4_._xscale = _loc2_ * 15 * _loc6_;
         _loc3_ = this.__shell.attachMovie("mask","mask" + _loc2_,com.racing.gameplay.World.scenery.getNextHighestDepth());
         _loc3_._height = _loc2_ * _loc6_ * _loc7_;
         _loc3_._x = _loc11_;
         _loc3_._y = _loc10_ + _loc2_ * _loc6_ * _loc7_;
         _loc3_.swapDepths(this.__shell.marker1);
         _loc3_.swapDepths(this.__shell.marker2);
         _loc3_.swapDepths(this.__shell.marker3);
         _loc3_.swapDepths(this.__shell.marker4);
         _loc3_.swapDepths(this.__shell.dashboard);
         _loc3_.swapDepths(this.__shell.mapp);
         _loc4_.setMask(_loc3_);
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 1;
      while(_loc2_ <= this.numtrees)
      {
         _loc5_ = this.__shell.scenery.attachMovie("tree","tree" + _loc2_,this.__shell.scenery.getNextHighestDepth(),{_visible:false});
         _loc8_ = Math.ceil(_loc5_._totalframes * Math.random());
         _loc5_.gotoAndStop(_loc8_);
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 1;
      while(_loc2_ <= this.numsigns)
      {
         _loc5_ = this.__shell.scenery.attachMovie("sign","sign" + _loc2_,this.__shell.scenery.getNextHighestDepth(),{_visible:false});
         _loc2_ = _loc2_ + 1;
      }
      this.__shell.scenery.attachMovie("flag","flag1",this.__shell.scenery.getNextHighestDepth(),{_visible:false});
      if(com.racing.Application.getInstance().xmlObject.config.track[com.racing.Application.getInstance().SESSION_DATA.curTrack - 1].course.billboard.attributes.status == "on")
      {
         this.__shell.scenery.attachMovie("billboard","bill1",this.__shell.scenery.getNextHighestDepth(),{_visible:false});
      }
      _loc2_ = 1;
      while(_loc2_ <= this.numenemies)
      {
         this.__shell.scenery.attachMovie("opp" + _loc2_,"enemy" + _loc2_,this.__shell.scenery.getNextHighestDepth(),{_visible:false});
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 1;
      while(_loc2_ <= this.stripes)
      {
         this.__shell.scenery["t0" + _loc2_]._rotation = com.racing.gameplay.CoreCar.getInstance().rotationZ;
         this.__shell.scenery["t0" + _loc2_].map._y = this.initx;
         this.__shell.scenery["t0" + _loc2_].map._x = this.inity;
         _loc2_ = _loc2_ + 1;
      }
      if(this.__shell.isNight)
      {
         this.__shell.scenery.attachMovie("night","night",this.__shell.scenery.getNextHighestDepth(),{_y:-90});
      }
      this.__shell.scenery.carp.swapDepths(this.__shell.scenery.getNextHighestDepth());
      this.__shell.scenery.carp._x = 200;
      this.__shell.dashboard.warning._visible = false;
      this.__shell.scenery.onEnterFrame = com.dynamicflash.utils.Delegate.create(this,this.renderWorld);
   }
   function go()
   {
      com.racing.gameplay.World.scenery.carp.car.gotoAndPlay(5);
      com.racing.gameplay.RaceTimer.getInstance().initiateCountDown();
   }
   function changeMusic(k)
   {
      var _loc1_ = 1;
      while(_loc1_ <= 3)
      {
         com.racing.gameplay.SoundMan.stopSound("bg" + _loc1_);
         if(_loc1_ == k)
         {
            com.racing.gameplay.SoundMan.playSound("bg" + _loc1_,true);
         }
         _loc1_ = _loc1_ + 1;
      }
   }
   function renderWorld()
   {
      var _loc2_;
      var _loc5_ = com.racing.gameplay.CoreCar.getInstance().rotationZ;
      var _loc8_ = this.__shell.mapp.map.fov;
      var _loc10_ = _loc8_._x * this.offsetX;
      var _loc9_ = _loc8_._y * this.offsetY;
      var _loc3_ = {x:- _loc10_,y:- _loc9_};
      var _loc4_;
      _loc2_ = 1;
      while(_loc2_ <= this.stripes)
      {
         _loc4_ = this.__shell.scenery["t0" + _loc2_];
         _loc4_._rotation = _loc5_;
         _loc4_.map._x = _loc3_.x;
         _loc4_.map._y = _loc3_.y;
         if(_loc2_ == 76)
         {
            trace(_loc2_);
            trace("LAST STRIPE r == " + _loc5_);
            trace("LAST STRIPE x == " + _loc3_.x);
            trace("LAST STRIPE y == " + _loc3_.y);
            trace("--");
         }
         _loc2_ = _loc2_ + 1;
      }
      this.__shell.skyline.ground._x = _loc5_ * 4;
      this.__shell.skyline.clouds._x = _loc5_ * 6;
      var _loc7_;
      var _loc6_;
      if(this.showBlimp)
      {
         _loc7_ = 1;
         _loc6_ = this.__shell.skyline.blimp.balloon;
         this.__shell.skyline.blimp._x = _loc5_ * 7;
         _loc6_._x -= _loc7_;
         if(_loc6_._x < - _loc6_._width)
         {
            _loc6_._y -= _loc7_;
         }
         if(_loc6_._y < -200 && _loc6_._x < - _loc6_._width)
         {
            _loc6_._x = 1200;
         }
         if(_loc6_._y < 15 && _loc6_._x > 800)
         {
            _loc6_._y += _loc7_;
         }
      }
      else
      {
         this.__shell.skyline.blimp._visible = this.showBlimp = false;
      }
   }
   static function manageQuality()
   {
      var _loc1_ = Number(com.racing.gameplay.World.scenery._parent.dashboard.fpsMeter.FPS.text.substr(5));
      com.racing.gameplay.World.scenery._parent.dashboard.fpsMeter.kill();
      if(_loc1_ <= 14)
      {
         _quality = "LOW";
      }
      else if(_loc1_ > 14 && _loc1_ <= 21)
      {
         _quality = "MEDIUM";
      }
      else if(_loc1_ > 21 && _loc1_ <= 29)
      {
         _quality = "HIGH";
      }
      else if(_loc1_ > 29)
      {
         _quality = "BEST";
      }
   }
}
