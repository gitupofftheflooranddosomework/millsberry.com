class gs.plugins.BlurFilterPlugin extends gs.plugins.FilterPlugin
{
   var _target;
   var _type;
   var initFilter;
   var overwriteProps;
   var propName;
   static var VERSION = 1;
   static var API = 1;
   function BlurFilterPlugin()
   {
      super();
      this.propName = "blurFilter";
      this.overwriteProps = ["blurFilter"];
   }
   function onInitTween($target, $value, $tween)
   {
      this._target = $target;
      this._type = flash.filters.BlurFilter;
      this.initFilter($value,new flash.filters.BlurFilter(0,0,$value.quality || 2));
      return true;
   }
}
