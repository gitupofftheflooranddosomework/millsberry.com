onClipEvent(load){
   this.videoMC = this._parent._parent._parent;
   this.globalsound = new Sound(this.videoMC);
   this.volume = 100;
   this.leftLimit = this._parent.sliderBG._x + this._width / 2;
   this.rightLimit = this._parent.sliderBG._x + this._parent.sliderBG._width - this._width / 2;
   this.limitAmount = this.rightLimit - this.leftLimit;
   this.pcnt = 100 / this.limitAmount;
   this._x = this.rightLimit;
   this.scrubbing = 0;
   this.useHandCursor = 0;
   this.onPress = function()
   {
      this.scrubbing = 1;
   };
   this.onRelease = this.onReleaseOutside = function()
   {
      this.scrubbing = 0;
      stopDrag();
   };
}
