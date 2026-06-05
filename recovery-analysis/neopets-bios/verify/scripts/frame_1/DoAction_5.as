this.bLocal = false;
this.init = function()
{
   var _loc2_ = this;
   _level0.debug = _loc2_._parent.debug;
   var _loc3_ = String(_loc2_);
   var _loc4_ = _loc3_.split(".")[0];
   if(_loc3_ == "_level0")
   {
      trace("Bios: Error, load this externally!");
      stop();
      return -1;
   }
   if(_loc4_ != "_level0")
   {
      _loc2_.copyInProps();
      _loc2_.postLoading(false);
      return -1;
   }
   _loc2_.bLocal = true;
   _level0.game_lang = _loc2_._parent.game_lang;
   _level0.game_id = _loc2_._parent.game_id;
   _level0.offline = 1;
   _loc2_.onEnterFrame = _loc2_.waitForBios;
   return 1;
};
this.waitForBios = function()
{
   var _loc2_ = this;
   var _loc3_ = _loc2_.getBytesLoaded();
   var _loc4_ = _loc2_.getBytesTotal();
   var _loc5_;
   if(!isNaN(_loc4_) && _loc4_ > 0 && (!isNaN(_loc3_) && _loc3_ > 0))
   {
      _loc5_ = int(_loc3_ / _loc4_ * 100);
      if(_loc5_ >= 100)
      {
         if(_level0.debug)
         {
            trace("Bios: " + _loc5_ + "% Loaded");
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
   var _loc2_ = this;
   _loc2_.copyInProps();
   var _loc3_;
   var _loc4_;
   if(!_loc2_.bLocal)
   {
      _loc2_._parent._visible = 0;
      _loc2_.finish();
   }
   else
   {
      _level0.game_isAdmin = 1;
      _loc3_ = "http://localhost:3000/__games/gamingsystem/np6_include_v1.swf";
      if(_loc2_.liveBios_boolean != undefined && _loc2_.liveBios_boolean == false)
      {
         _loc3_ = "//Neoserver/Neoserver3/Multimedia/neopets_gaming_system_and_utilities/FLASH6/GamingSystem/np6_include_v1.swf";
         if(_level0.debug)
         {
            trace("BIOS: Loading local include_movie\n" + _loc3_);
         }
      }
      _loc4_ = 100;
      System.security.allowDomain("neopets.com");
      loadMovieNum(_loc3_,_loc4_);
      _loc2_.stop();
      _loc2_.onEnterFrame = waitForInclude;
   }
   return 1;
};
