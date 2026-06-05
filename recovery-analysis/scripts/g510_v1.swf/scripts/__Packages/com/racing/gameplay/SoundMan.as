class com.racing.gameplay.SoundMan
{
   static var _library = new Object();
   static var sControl = new Sound();
   function SoundMan()
   {
   }
   function init()
   {
   }
   static function playSound($id, $loop)
   {
      com.racing.gameplay.SoundMan._library[$id].start(0,!$loop ? 1 : 9999);
   }
   static function stopSound($id)
   {
      com.racing.gameplay.SoundMan._library[$id].stop($id);
   }
   static function registerSound($id, $c)
   {
      var _loc1_ = new Sound($c);
      _loc1_.attachSound($id);
      com.racing.gameplay.SoundMan._library[$id] = _loc1_;
   }
}
