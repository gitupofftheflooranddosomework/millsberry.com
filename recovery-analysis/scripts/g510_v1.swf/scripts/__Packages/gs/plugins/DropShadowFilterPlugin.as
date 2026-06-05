class gs.plugins.DropShadowFilterPlugin extends gs.plugins.FilterPlugin
{
   var _target;
   var _type;
   var overwriteProps;
   var propName;
   static var VERSION = 1;
   static var API = 1;
   function DropShadowFilterPlugin()
   {
      super();
      this.propName = "dropShadowFilter";
      this.overwriteProps = ["dropShadowFilter"];
   }
   function onInitTween($target, $value, $tween)
   {
      this._target = $target;
      this._type = flash.filters.DropShadowFilter;
      this.initFilter($value,new flash.filters.DropShadowFilter(0,45,0,0,0,0,1,$value.quality || 2,$value.inner,$value.knockout,$value.hideObject));
      return true;
   }
}
