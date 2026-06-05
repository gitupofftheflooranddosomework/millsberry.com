VideoPlayerClass = function()
{
   System.security.allowDomain("swf.neopets.com","images.neopets.com","images50.neopets.com","64.191.225.20","www.millsberry.com");
   this.init();
};
var obj = VideoPlayerClass.prototype;
obj.setMovieURL = function(url_str)
{
   this.pMovieURL = url_str;
};
obj.init = function()
{
   if(_root.percent_loading_txt != undefined)
   {
      this.loadingText_str = _root.percent_loading_txt;
   }
   else if(_level0.percent_loading_txt != undefined)
   {
      this.loadingText_str = _level0.percent_loading_txt;
   }
   else
   {
      this.loadingText_str = "Loading %1 %";
   }
   this.getPercentLoaded = function()
   {
      return Math.round(this.process.pcntLoaded);
   };
   this.updateLoadProgress = function()
   {
      this.load_txt.htmlText = this.findAndReplace(this.loadingText_str,"%1",this.getPercentLoaded());
   };
   this.findAndReplace = function(§tSource_str:String§, §tFind_str:String§, §tReplace_str:String§)
   {
      var _loc2_ = tSource_str.split(tFind_str);
      var _loc3_ = "";
      var _loc1_ = 0;
      while(_loc1_ < tTokens_array.length)
      {
         tFinal_str += tTokens_array[_loc1_];
         if(_loc1_ < tTokens_array.length - 1)
         {
            tFinal_str += tReplace_str;
         }
         _loc1_ = _loc1_ + 1;
      }
      return tFinal_str;
   };
   this.load_txt.htmlText = "";
   this.countDown_mc.attachMovie(this.pCountDown_mc,"countGR",1);
   this.countDown_mc._alpha = 0;
   this.controller._visible = false;
   this.mold._visible = false;
   if(this.pMovieWidth == "_root.movieWidth")
   {
      this.pMovieWidth = _root.movieWidth;
   }
   if(this.pMovieHeight == "_root.movieHeight")
   {
      this.pMovieHeight = _root.movieHeight;
   }
   var e = eval(this.pMovieURL);
   if(e != undefined)
   {
      this.pMovieURL = e;
   }
   this.paused = 1;
   loadMovie(this.pMovieURL,this.mold);
   this.mold.stop();
   this.controller.pl.gotoAndStop("pauseButton");
   this.bg._visible = false;
   var obj = this.controller.sliderButton;
   obj.videoMC = this;
   obj.myMovie = this.mold;
   obj.beginDrag = obj._x;
   obj.endDrag = this.controller.sliderBG._x + this.controller.sliderBG._width;
   obj.scrubbing = false;
   obj.useHandCursor = false;
   obj.onPress = function()
   {
      this.myMovie.stop();
      this.videoMC.paused = 1;
      this._parent.pl.gotoAndStop("pauseButton");
      this.scrubbing = true;
   };
   obj.onRelease = obj.onReleaseOutside = function()
   {
      var _loc3_ = Math.max(1,Math.round(this._parent.sliderBG._xmouse / (this.endDrag - this.beginDrag) * this.myMovie._totalframes));
      var _loc4_ = this.myMovie._framesloaded;
      if(_loc3_ > _loc4_)
      {
         _loc3_ = _loc4_ - 12;
      }
      else if(_loc3_ < 1)
      {
         _loc3_ = 1;
      }
      this.videoMC.countDown_mc._visible = false;
      if(_root.countDown_mc)
      {
         _root.countDown_mc._visible = false;
      }
      this.videoMC.controller.pl.gotoAndStop("playButton");
      stopDrag();
      this.scrubbing = false;
      this.videoMC.paused = 0;
      this.myMovie.gotoAndPlay(_loc3_);
   };
   obj.onEnterFrame = function()
   {
      var _loc2_;
      if(!this.scrubbing)
      {
         _loc2_ = this.myMovie;
         this._x = this.beginDrag + _loc2_._currentframe / _loc2_._totalframes * (this.endDrag - this.beginDrag);
      }
      else
      {
         this.startDrag(false,this.beginDrag,0,this.endDrag,0);
      }
      if(this._x >= this.endDrag)
      {
         this.videoMC.paused = 1;
         this.myMovie.gotoAndStop(1);
         this.videoMC.controller.pl.gotoAndStop("pauseButton");
         this._parent._parent.pOnDone();
      }
   };
   var obj = this.controller.loadingBar;
   obj._xscale = 0;
   obj.video_mc = this.mold;
   obj.onEnterFrame = function()
   {
      var _loc2_ = this.video_mc.getBytesLoaded();
      var _loc4_ = this.video_mc.getBytesTotal();
      var _loc3_ = _loc2_ / _loc4_ * 100;
      this._xscale = _loc3_;
      if(_loc2_ > 100 && _loc3_ >= 100)
      {
         this.onEnterFrame = undefined;
      }
   };
   var obj = this.process;
   obj.countDown = this.countDown_mc;
   obj.fps = this.pMovieFPS;
   obj.bufferFactor = 1.2;
   obj.startTime = getTimer();
   obj.sizeObjects = function()
   {
      this._parent.resizeClips();
   };
   obj.onEnterFrame = function()
   {
      var _loc3_ = this._parent.mold.getBytesLoaded();
      var _loc4_ = this._parent.mold.getBytesTotal();
      var _loc7_ = _loc4_ - _loc3_;
      var _loc9_ = this._parent.mold._totalframes;
      var _loc8_ = this._parent.mold._framesloaded;
      var _loc12_ = getTimer() - this.startTime;
      var _loc6_ = _loc3_ / _loc12_;
      var _loc13_ = _loc9_ / this.fps;
      var _loc5_ = _loc8_ / this.fps;
      var _loc10_ = _loc7_ / 1024 / _loc6_;
      this.pcntLoaded = _loc3_ / _loc4_ * 100;
      var _loc11_;
      if(_loc3_ > 100)
      {
         if(!isNaN(pcntLoaded))
         {
            this.countDown._alpha = 100;
            this._parent.controller._visible = true;
            this._parent.mold._visible = true;
            _loc11_ = _loc10_ * this.bufferFactor;
            if(_loc5_ < _loc11_)
            {
               this.sizeObjects();
               if(this._parent.paused)
               {
                  this._parent.updateLoadProgress();
                  this._parent.mold.stop();
               }
               else
               {
                  this.countDown._alpha = 0;
                  this._parent.load_txt._visible = false;
                  this.countDown.unloadMovie();
                  this._parent.load_txt.unloadMovie();
               }
            }
            else
            {
               if(_root.countBG)
               {
                  _root.countBG._visible = false;
               }
               if(_root.countDown)
               {
                  _root.countDown._visible = false;
               }
               this._parent.load_txt._visible = false;
               this._parent.paused = 0;
               this.countDown._alpha = 0;
               this._parent.mold.play();
               this._parent.controller.pl.gotoAndStop("playButton");
               this.sizeObjects();
               this.onEnterFrame = undefined;
            }
         }
      }
   };
   var obj = this.controller.volumeControl.volumeSlider;
   obj.videoMC = this;
   obj.globalsound = new Sound(this.mold);
   obj.pVolume = 100;
   obj.globalsound.setVolume(obj.pVolume);
   obj.leftLimit = this.controller.volumeControl.sliderBG._x + obj._width / 2;
   obj.rightLimit = this.controller.volumeControl.sliderBG._x + obj._parent.sliderBG._width - obj._width / 2;
   obj.limitAmount = obj.rightLimit - obj.leftLimit;
   obj.pcnt = 100 / obj.limitAmount;
   obj._x = obj.rightLimit;
   obj.scrubbing = 0;
   obj.useHandCursor = false;
   obj.onPress = function()
   {
      this.scrubbing = 1;
   };
   obj.onRelease = obj.onReleaseOutside = function()
   {
      this.scrubbing = 0;
      stopDrag();
   };
   obj.onEnterFrame = function()
   {
      var _loc2_;
      var _loc3_;
      if(this.scrubbing)
      {
         this.startDrag(false,this.leftLimit,0,this.rightLimit,0);
         _loc2_ = this._x - this.leftLimit;
         _loc3_ = d / this.limitAmount;
         this.pVolume = _loc2_ * this.pcnt;
         this.globalsound.setVolume(this.pVolume);
      }
   };
};
obj.stopMovie = function()
{
   this.mold.gotoAndStop(1);
};
obj.resizeClips = function()
{
   var _loc3_ = this.mold;
   var _loc2_ = this.controller;
   var _loc4_ = this.countDown_mc;
   this.bg._width = this.pMovieWidth;
   this.bg._height = this.pMovieHeight;
   var _loc6_ = 160 - this.pMovieWidth / 2;
   var _loc5_ = 120 - this.pMovieHeight / 2 - _loc2_._height / 2;
   _loc3_._x = this.bg._x = _loc6_;
   _loc3_._y = this.bg._y = _loc5_;
   this.bg._visible = true;
   _loc4_._width = this.bg._width;
   _loc4_._height = this.bg._height;
   _loc4_._x = _loc3_._x;
   _loc4_._y = _loc3_._y;
   _loc2_._y = this.bg._y + this.bg._height + _loc2_._height / 2;
   _loc2_._width = this.bg._width;
   this.load_txt._x = _loc2_._x + _loc2_._width / 2 - this.load_txt._width;
   this.load_txt._y = _loc2_._y - _loc2_._height / 2 - this.load_txt._height;
   this.mask_mc._width = this.pMovieWidth;
   this.mask_mc._height = this.pMovieHeight;
   this.mask_mc._x = _loc3_._x;
   this.mask_mc._y = _loc3_._y;
};
obj.pOnDone = function()
{
   _root[this.pDoneMethod]();
};
Object.registerClass("VideoPlayerSymbol",VideoPlayerClass);
