class gs.plugins.TintPlugin extends gs.plugins.TweenPlugin
{
   var _color;
   var _ct;
   var _tweens;
   var overwriteProps;
   var propName;
   static var VERSION = 1.01;
   static var API = 1;
   function TintPlugin()
   {
      super();
      this.propName = "tint";
      this.overwriteProps = ["tint"];
   }
   function onInitTween($target, $value, $tween)
   {
      if(typeof $target != "movieclip" && !($target instanceof TextField))
      {
         return false;
      }
      var _loc3_ = $tween.vars._alpha == undefined ? ($tween.vars.autoAlpha == undefined ? $target._alpha : $tween.vars.autoAlpha) : $tween.vars._alpha;
      var _loc6_ = !($value == null || $tween.vars.removeTint == true) ? {rb:$value >> 16,gb:$value >> 8 & 0xFF,bb:$value & 0xFF,ra:0,ga:0,ba:0,aa:_loc3_} : {rb:0,gb:0,bb:0,ab:0,ra:_loc3_,ga:_loc3_,ba:_loc3_,aa:_loc3_};
      if($tween.vars._alpha != undefined || $tween.vars.autoAlpha != undefined)
      {
         $tween.killVars({_alpha:1,autoAlpha:1});
      }
      this.init($target,_loc6_);
      return true;
   }
   function init($target, $end)
   {
      this._color = new Color($target);
      this._ct = this._color.getTransform();
      var _loc5_;
      var _loc2_;
      for(_loc2_ in $end)
      {
         if(this._ct[_loc2_] != $end[_loc2_])
         {
            this._tweens[this._tweens.length] = new gs.utils.tween.TweenInfo(this._ct,_loc2_,this._ct[_loc2_],$end[_loc2_] - this._ct[_loc2_],"tint",false);
         }
      }
   }
   function set changeFactor($n)
   {
      var _loc3_;
      var _loc2_;
      _loc3_ = this._tweens.length - 1;
      while(_loc3_ > -1)
      {
         _loc2_ = this._tweens[_loc3_];
         _loc2_.target[_loc2_.property] = _loc2_.start + _loc2_.change * $n;
         _loc3_ = _loc3_ - 1;
      }
      this._color.setTransform(this._ct);
   }
}
