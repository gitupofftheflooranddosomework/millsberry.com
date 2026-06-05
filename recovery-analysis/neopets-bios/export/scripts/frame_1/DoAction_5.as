this.bLocal = false;
this.init = function()
{
   var _loc1_ = this;
   _level0.debug = _loc1_._parent.debug;
   var _loc2_ = String(_loc1_);
   var _loc3_ = _loc2_.split(".")[0];
   if(_loc2_ == "_level0")
   {
      trace("Bios: Error, load this externally!");
      stop();
      return -1;
   }
   if(_loc3_ != "_level0")
   {
      _loc1_.copyInProps();
      _loc1_.postLoading(false);
      return -1;
   }
   _loc1_.bLocal = true;
   _level0.game_lang = _loc1_._parent.game_lang;
   _level0.game_id = _loc1_._parent.game_id;
   _level0.offline = 1;
   _loc1_.onEnterFrame = _loc1_.waitForBios;
   return 1;
};
this.waitForBios = function()
{
   var _loc2_ = this;
   var _loc1_ = _loc2_.getBytesLoaded();
   var _loc3_ = _loc2_.getBytesTotal();
   if(!isNaN(_loc3_) && _loc3_ > 0 && (!isNaN(_loc1_) && _loc1_ > 0))
   {
      var p = int(_loc1_ / _loc3_ * 100);
      if(p >= 100)
      {
         if(_level0.debug)
         {
            trace("Bios: " + p + "% Loaded");
         }
         _loc2_._parent._visible = 1;
         _loc2_.onEnterFrame = undefined;
         _loc2_.endInit();
      }
   }
   return 1;
};
this.endInit = function()
{
   var _loc1_ = this;
   _loc1_.copyInProps();
   var _loc2_;
   var _loc3_;
   if(!_loc1_.bLocal)
   {
      _loc1_._parent._visible = 0;
      _loc1_.finish();
   }
   else
   {
      _level0.game_isAdmin = 1;
      _loc2_ = "http://localhost:3000/__games/gamingsystem/np6_include_v1.swf";
      if(_loc1_.liveBios_boolean != undefined && _loc1_.liveBios_boolean == false)
      {
         _loc2_ = "//Neoserver/Neoserver3/Multimedia/neopets_gaming_system_and_utilities/FLASH6/GamingSystem/np6_include_v1.swf";
         if(_level0.debug)
         {
            trace("BIOS: Loading local include_movie\n" + _loc2_);
         }
      }
      _loc3_ = 100;
      System.security.allowDomain("neopets.com");
      loadMovieNum(_loc2_,_loc3_);
      _loc1_.stop();
      _loc1_.onEnterFrame = waitForInclude;
   }
   return 1;
};
