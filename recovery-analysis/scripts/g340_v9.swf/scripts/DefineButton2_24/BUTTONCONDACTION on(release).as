on(release){
   this._parent._parent.paused = 1;
   this._parent._parent.mold.stop();
   nextFrame();
}
