class gs.plugins.GlowFilterPlugin extends gs.plugins.FilterPlugin
{
   var _target;
   var _type;
   var initFilter;
   var overwriteProps;
   var propName;
   static var VERSION = 1;
   static var API = 1;
   function GlowFilterPlugin()
   {
      super();
      this.propName = "glowFilter";
      this.overwriteProps = ["glowFilter"];
   }
   function onInitTween($target, $value, $tween)
   {
      this._target = $target;
      this._type = flash.filters.GlowFilter;
      this.initFilter($value,new flash.filters.GlowFilter(16777215,0,0,0,$value.strength || 1,$value.quality || 2,$value.inner,$value.knockout));
      return true;
   }
}
