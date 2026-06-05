this.init = function()
{
   this.onEnterFrame = this.waitForBios;
   return 1;
};
this.waitForBios = function()
{
   var _loc2_ = this;
   trace("waitForBios");
   var _loc3_ = int(_loc2_.getBytesLoaded() / _loc2_.getBytesTotal() * 100);
   if(_loc3_ < 100)
   {
      trace("...still loading bios p " + _loc3_);
   }
   else
   {
      trace("!! bios loaded");
      _loc2_.onEnterFrame = undefined;
      _loc2_.endInit();
   }
};
this.endInit = function()
{
   var _loc3_ = this;
   if(_parent == _level0)
   {
      trace("BIOS must be loaded by another file!");
      stop();
      return -1;
   }
   _loc3_.copyInProps();
   _loc3_.addProtoCode();
   var _loc4_;
   var _loc5_;
   if(getIncludePercentLoaded() == 100)
   {
      _loc3_._parent._visible = 0;
      _loc3_.finish();
   }
   else
   {
      _loc4_ = "http://images.neopets.com/games/high_scores/include_movie.swf";
      _loc5_ = 100;
      loadMovieNum(_loc4_,_loc5_);
      _loc3_.stop();
      _loc3_.onEnterFrame = waitForInclude;
   }
};
