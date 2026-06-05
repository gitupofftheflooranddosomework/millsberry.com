onClipEvent(enterFrame){
   if(this.scrubbing)
   {
      this.startDrag(false,this.leftLimit,0,this.rightLimit,0);
      var dist = this._x - this.leftLimit;
      var d = d / this.limitAmount;
      this.volume = dist * this.pcnt;
      this.globalsound.setVolume(this.volume);
   }
}
