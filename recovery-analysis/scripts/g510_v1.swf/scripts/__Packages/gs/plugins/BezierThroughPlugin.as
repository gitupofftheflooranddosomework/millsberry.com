class gs.plugins.BezierThroughPlugin extends gs.plugins.BezierPlugin
{
   var init;
   var propName;
   static var VERSION = 1;
   static var API = 1;
   function BezierThroughPlugin()
   {
      super();
      this.propName = "bezierThrough";
   }
   function onInitTween($target, $value, $tween)
   {
      if(!($value instanceof Array))
      {
         return false;
      }
      var _loc2_ = $value;
      this.init($tween,_loc2_,true);
      return true;
   }
}
