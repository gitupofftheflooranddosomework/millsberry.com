this.init = function()
{
   this.onEnterFrame = this.waitForBios;
   return 1;
};
this.waitForBios = function()
{
   var _loc2_ = this;
   trace("waitForBios");
   var _loc1_ = int(_loc2_.getBytesLoaded() / _loc2_.getBytesTotal() * 100);
   if(_loc1_ < 100)
   {
      trace("...still loading bios p " + _loc1_);
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
   var _loc1_ = this;
   if(_parent == _level0)
   {
      trace("BIOS must be loaded by another file!");
      stop();
      return -1;
   }
   _loc1_.copyInProps();
   _loc1_.addProtoCode();
   var _loc2_;
   var _loc3_;
   if(getIncludePercentLoaded() == 100)
   {
      _loc1_._parent._visible = 0;
      _loc1_.finish();
   }
   else
   {
      _loc2_ = "http://images.neopets.com/games/high_scores/include_movie.swf";
      _loc3_ = 100;
      loadMovieNum(_loc2_,_loc3_);
      _loc1_.stop();
      _loc1_.onEnterFrame = waitForInclude;
   }
};
