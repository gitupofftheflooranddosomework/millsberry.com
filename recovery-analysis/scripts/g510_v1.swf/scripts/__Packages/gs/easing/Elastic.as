class gs.easing.Elastic
{
   static var _2PI = 6.283185307179586;
   function Elastic()
   {
   }
   static function easeIn(t, b, c, d, a, p)
   {
      if(t == 0)
      {
         return b;
      }
      if((t /= d) == 1)
      {
         return b + c;
      }
      if(!p)
      {
         p = d * 0.3;
      }
      var _loc5_;
      if(!a || a < Math.abs(c))
      {
         a = c;
         _loc5_ = p / 4;
      }
      else
      {
         _loc5_ = p / gs.easing.Elastic._2PI * Math.asin(c / a);
      }
      return - a * Math.pow(2,10 * (t -= 1)) * Math.sin((t * d - _loc5_) * gs.easing.Elastic._2PI / p) + b;
   }
   static function easeOut(t, b, c, d, a, p)
   {
      if(t == 0)
      {
         return b;
      }
      if((t /= d) == 1)
      {
         return b + c;
      }
      if(!p)
      {
         p = d * 0.3;
      }
      var _loc5_;
      if(!a || a < Math.abs(c))
      {
         a = c;
         _loc5_ = p / 4;
      }
      else
      {
         _loc5_ = p / gs.easing.Elastic._2PI * Math.asin(c / a);
      }
      return a * Math.pow(2,-10 * t) * Math.sin((t * d - _loc5_) * gs.easing.Elastic._2PI / p) + c + b;
   }
   static function easeInOut(t, b, c, d, a, p)
   {
      if(t == 0)
      {
         return b;
      }
      if((t /= d / 2) == 2)
      {
         return b + c;
      }
      if(!p)
      {
         p = d * 0.44999999999999996;
      }
      var _loc5_;
      if(!a || a < Math.abs(c))
      {
         a = c;
         _loc5_ = p / 4;
      }
      else
      {
         _loc5_ = p / gs.easing.Elastic._2PI * Math.asin(c / a);
      }
      if(t < 1)
      {
         return -0.5 * (a * Math.pow(2,10 * (t -= 1)) * Math.sin((t * d - _loc5_) * gs.easing.Elastic._2PI / p)) + b;
      }
      return a * Math.pow(2,-10 * (t -= 1)) * Math.sin((t * d - _loc5_) * gs.easing.Elastic._2PI / p) * 0.5 + c + b;
   }
}
