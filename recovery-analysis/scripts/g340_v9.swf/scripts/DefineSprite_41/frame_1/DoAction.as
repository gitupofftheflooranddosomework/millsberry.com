this.loadingBar.myMovie = this._parent.mold;
this.loadingBar.onLoad = function()
{
   this._xscale = 0;
};
this.loadingBar.onEnterFrame = function()
{
   var _loc4_;
   var _loc3_;
   var _loc2_;
   if(++this.waitCount > 10)
   {
      _loc4_ = this.myMovie.getBytesLoaded();
      _loc3_ = this.myMovie.getBytesTotal();
      _loc2_ = _loc4_ / _loc3_ * 100;
      this._xscale = _loc2_;
      if(_loc2_ == 100)
      {
         this.onEnterFrame = undefined;
      }
   }
};
