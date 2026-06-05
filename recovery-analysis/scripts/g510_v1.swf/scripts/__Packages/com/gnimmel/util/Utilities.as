class com.gnimmel.util.Utilities
{
   function Utilities()
   {
   }
   static function isInBrowser()
   {
      if(System.capabilities.playerType == "External")
      {
         return false;
      }
      return true;
   }
   static function isInLocalBrowser()
   {
      if(com.gnimmel.util.Utilities.isInBrowser() && com.gnimmel.util.Utilities.isLocal(_level0))
      {
         return true;
      }
      return false;
   }
   static function getFilePathPrefix($fileType, $configXmlObject)
   {
      var _loc1_ = "";
      switch($fileType)
      {
         case "swf":
            _loc1_ = !com.gnimmel.util.Utilities.isInBrowser() ? "" : $configXmlObject.config.paths.swfPath.attributes.value;
            break;
         case "xml":
         case "flv":
         case "mp3":
         case "img":
            _loc1_ = !com.gnimmel.util.Utilities.isInBrowser() ? "../" + $fileType + "/" : $configXmlObject.config.paths[$fileType + "Path"].attributes.value;
            break;
         case "rtmp":
            _loc1_ = $configXmlObject.config.paths[$fileType + "Path"].attributes.value;
            break;
         default:
            _loc1_ = "";
            trace("PATHING ASSIGNMENT ERROR");
      }
      return _loc1_;
   }
   static function isLocal($rootRef)
   {
      if(com.gnimmel.util.Utilities.getDomain($rootRef) == "file://")
      {
         return true;
      }
      return false;
   }
   static function getDomain($rootRef)
   {
      var _loc2_ = 0;
      var _loc4_ = $rootRef._url.length;
      var _loc1_;
      _loc1_ = 0;
      while(_loc1_ < _loc4_)
      {
         if($rootRef._url.charAt(_loc1_) == "/")
         {
            _loc2_ = _loc2_ + 1;
         }
         if(_loc2_ == 3)
         {
            return $rootRef._url.slice(0,_loc1_);
         }
         _loc1_ = _loc1_ + 1;
      }
   }
}
