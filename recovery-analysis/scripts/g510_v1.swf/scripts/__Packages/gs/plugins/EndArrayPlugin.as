class gs.plugins.EndArrayPlugin extends gs.plugins.TweenPlugin
{
   var _a;
   var _info;
   var overwriteProps;
   var propName;
   var round;
   static var VERSION = 1.02;
   static var API = 1;
   function EndArrayPlugin()
   {
      super();
      this.propName = "endArray";
      this.overwriteProps = ["endArray"];
      this._info = [];
   }
   function onInitTween($target, $value, $tween)
   {
      if(!($target instanceof Array) || !($value instanceof Array))
      {
         return false;
      }
      var _loc3_ = $target;
      var _loc2_ = $value;
      this.init(_loc3_,_loc2_);
      return true;
   }
   function init($start, $end)
   {
      this._a = $start;
      var _loc2_ = $end.length - 1;
      while(_loc2_ > -1)
      {
         if($start[_loc2_] != $end[_loc2_] && $start[_loc2_] != undefined)
         {
            this._info[this._info.length] = new gs.utils.tween.ArrayTweenInfo(_loc2_,this._a[_loc2_],$end[_loc2_] - this._a[_loc2_]);
         }
         _loc2_ = _loc2_ - 1;
      }
   }
   function set changeFactor($n)
   {
      var _loc3_;
      var _loc2_;
      if(this.round)
      {
         _loc3_ = this._info.length - 1;
         while(_loc3_ > -1)
         {
            _loc2_ = this._info[_loc3_];
            this._a[_loc2_.index] = Math.round(_loc2_.start + _loc2_.change * $n);
            _loc3_ = _loc3_ - 1;
         }
      }
      else
      {
         _loc3_ = this._info.length - 1;
         while(_loc3_ > -1)
         {
            _loc2_ = this._info[_loc3_];
            this._a[_loc2_.index] = _loc2_.start + _loc2_.change * $n;
            _loc3_ = _loc3_ - 1;
         }
      }
   }
}
