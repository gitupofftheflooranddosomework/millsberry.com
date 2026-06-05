this.loadBios = function()
{
   var _loc1_ = this;
   if(_level0.FG_GAME_BASE != undefined)
   {
      _loc1_.url = _level0.FG_GAME_BASE + _loc1_.bios_url + "/bios.swf?r=" + random(99999);
   }
   else
   {
      _loc1_.url = _loc1_.bios_offline_domain + "/" + _loc1_.bios_url + "/bios.swf?r=" + random(99999);
   }
   if(_loc1_.debug == 1)
   {
   }
   System.security.allowDomain(_loc1_.allow_domain);
   _loc1_.bios.loadMovie(_loc1_.url);
};
