onClipEvent(enterFrame){
   if(this._x >= this.endDrag)
   {
      trace(">=endDrag");
      this._parent.paused = 1;
      this.myMovie.gotoAndStop(1);
      this.videoMC.controller.pl.gotoAndStop("pauseButton");
      this._parent._parent.pOnDone();
   }
   if(!this.scrubbing)
   {
      var movie_Clip = this.myMovie;
      var newX = movie_Clip._currentframe / movie_Clip._totalframes * (this.endDrag - this.beginDrag);
      newX += this.beginDrag;
      this._x = newX;
   }
   else
   {
      this.startDrag(false,this.beginDrag,0,this.endDrag,0);
   }
}
