class gs.easing.Back
{
   function Back()
   {
   }
   static function easeIn(t, b, c, d, s)
   {
      if(s == undefined)
      {
         s = 1.70158;
      }
      return c * (t /= d) * t * ((s + 1) * t - s) + b;
   }
   static function easeOut(t, b, c, d, s)
   {
      if(s == undefined)
      {
         s = 1.70158;
      }
      return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
   }
   static function easeInOut(t, b, c, d, s)
   {
      if(s == undefined)
      {
         s = 1.70158;
      }
      if((t /= d / 2) < 1)
      {
         return c / 2 * (t * t * (((s *= 1.5250000000000001) + 1) * t - s)) + b;
      }
      return c / 2 * ((t -= 2) * t * (((s *= 1.5250000000000001) + 1) * t + s) + 2) + b;
   }
}
