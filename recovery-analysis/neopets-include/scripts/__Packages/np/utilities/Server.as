class np.utilities.Server
{
   static var IMAGES_SERVER_BASE_URL_STR;
   static var WEB_SERVER_BASE_URL_STR;
   static var IMAGES = "http://images.neopets.com";
   function Server()
   {
   }
   static function get WEB_SERVER_BASE_URL()
   {
      if(!np.utilities.Server.isFileOnline())
      {
         if(np.utilities.Server.isFileInUSOffice())
         {
            np.utilities.Server.WEB_SERVER_BASE_URL_STR = "http://dev.neopets.com";
         }
         else
         {
            np.utilities.Server.WEB_SERVER_BASE_URL_STR = "http://webdev.neopets.com";
         }
      }
      else if(_level0.FG_SCRIPT_BASE == undefined)
      {
         np.utilities.Server.WEB_SERVER_BASE_URL_STR = "http://www.neopets.com";
      }
      else
      {
         np.utilities.Server.WEB_SERVER_BASE_URL_STR = _level0.FG_SCRIPT_BASE;
      }
      return np.utilities.Server.WEB_SERVER_BASE_URL_STR;
   }
   static function get IMAGES_SERVER_BASE_URL()
   {
      if(!np.utilities.Server.isFileOnline())
      {
         np.utilities.Server.IMAGES_SERVER_BASE_URL_STR = "http://images50.neopets.com";
      }
      else if(_level0.FG_GAME_BASE == undefined)
      {
         np.utilities.Server.IMAGES_SERVER_BASE_URL_STR = np.utilities.Server.IMAGES;
      }
      else
      {
         np.utilities.Server.IMAGES_SERVER_BASE_URL_STR = _level0.FG_GAME_BASE;
      }
      return np.utilities.Server.IMAGES_SERVER_BASE_URL_STR;
   }
   static function isFileOnline()
   {
      return Boolean(String(_level0._url).indexOf("file://") != 0);
   }
   static function isFileInUSOffice()
   {
      return Boolean(String(_level0._url).indexOf("file://\\Neoserver") != 0);
   }
   static function addAllowedURL(scriptURL_str)
   {
      var _loc2_ = scriptURL_str.split("/",3);
      var _loc1_ = String(_loc2_[2]).toUpperCase();
      np.utilities.Server.addAllowedDomain(_loc1_);
   }
   static function addAllowedDomain(tDomain_str)
   {
      System.security.allowDomain("neopets.com","*.neopets.com","www.neopets.com","dev.neopets.com","webdev.neopets.com","images.neopets.com","images50.neopets.com","swf.neopets.com","neoadmin.neopets.com","system.neopets.com","millsberry.com","*.millsberry.com","www.millsberry.com","64.191.225.25","64.191.225.20","dev.millsberry.com","gmidev.neopets.com","graphics.millsberry.com","devgraphics.millsberry.com",tDomain_str);
   }
   static function addAllAllowedDomains(DONT_PASS_ANYTHING)
   {
      if(DONT_PASS_ANYTHING != undefined)
      {
         trace("ERROR: Server.addAllAllowedDomains() does not accept parameters");
      }
      np.utilities.Server.addAllowedDomain("");
   }
}
