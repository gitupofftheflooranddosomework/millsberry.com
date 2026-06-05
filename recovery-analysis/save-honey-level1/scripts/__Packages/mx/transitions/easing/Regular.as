class mx.transitions.easing.Regular
{
   static var version = "1.1.0.52";
   function Regular()
   {
   }
   static function easeIn(t, b, c, d)
   {
      return c * (t /= d) * t + b;
   }
   static function easeOut(t, b, c, d)
   {
      return (- c) * (t /= d) * (t - 2) + b;
   }
   static function easeInOut(t, b, c, d)
   {
      if((t /= d / 2) < 1)
      {
         return c / 2 * t * t + b;
      }
      return (- c) / 2 * ((t = t - 1) * (t - 2) - 1) + b;
   }
}
