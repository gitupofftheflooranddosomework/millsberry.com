onClipEvent(load){
   this.videoMC = this._parent._parent;
   this.myMovie = this.videoMC.mold;
   this.beginDrag = this._x;
   this.endDrag = this._parent.sliderBG._x + this._parent.sliderBG._width;
   this.scrubbing = 0;
   this.useHandCursor = false;
   this.onPress = function()
   {
      this.myMovie.stop();
      this.videoMC.controller.pl.gotoAndStop("pauseButton");
      this.scrubbing = 1;
   };
   this.onRelease = this.onReleaseOutside = function()
   {
      var _loc2_ = Math.round(this._parent.sliderBG._xmouse / (this.endDrag - this.beginDrag) * this.myMovie._totalframes);
      this.myMovie.gotoAndPlay(_loc2_);
      this.videoMC.controller.pl.gotoAndStop("playButton");
      this.scrubbing = 0;
      stopDrag();
   };
}
