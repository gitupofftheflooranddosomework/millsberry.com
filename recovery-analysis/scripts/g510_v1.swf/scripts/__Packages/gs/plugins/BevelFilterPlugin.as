class gs.plugins.BevelFilterPlugin extends gs.plugins.FilterPlugin
{
   var _target;
   var _type;
   var initFilter;
   var overwriteProps;
   var propName;
   static var VERSION = 1;
   static var API = 1;
   function BevelFilterPlugin()
   {
      super();
      this.propName = "bevelFilter";
      this.overwriteProps = ["bevelFilter"];
   }
   function onInitTween($target, $value, $tween)
   {
      this._target = $target;
      this._type = flash.filters.BevelFilter;
      this.initFilter($value,new flash.filters.BevelFilter(0,0,16777215,0.5,0,0.5,2,2,0,$value.quality || 2));
      return true;
   }
}
