class mx.transitions.OnEnterFrameBeacon
{
   static var version = "1.1.0.52";
   function OnEnterFrameBeacon()
   {
   }
   static function init()
   {
      var _loc4_ = _global.MovieClip;
      var _loc3_;
      if(!_root.__OnEnterFrameBeacon)
      {
         mx.transitions.BroadcasterMX.initialize(_loc4_);
         _loc3_ = _root.createEmptyMovieClip("__OnEnterFrameBeacon",9876);
         _loc3_.onEnterFrame = function()
         {
            _global.MovieClip.broadcastMessage("onEnterFrame");
         };
      }
   }
}
