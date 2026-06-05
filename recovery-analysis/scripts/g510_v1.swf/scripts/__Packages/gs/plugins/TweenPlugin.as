class gs.plugins.TweenPlugin
{
   var _changeFactor;
   var _tweens;
   var overwriteProps;
   var propName;
   var round;
   static var VERSION = 1.04;
   static var API = 1;
   function TweenPlugin()
   {
      this._tweens = [];
      this._changeFactor = 0;
   }
   function onInitTween($target, $value, $tween)
   {
      this.addTween($target,this.propName,$target[this.propName],$value,this.propName);
      return true;
   }
   function addTween($object, $propName, $start, $end, $overwriteProp)
   {
      var _loc3_;
      if($end != undefined)
      {
         _loc3_ = typeof $end != "number" ? Number($end) : $end - $start;
         if(_loc3_ != 0)
         {
            this._tweens[this._tweens.length] = new gs.utils.tween.TweenInfo($object,$propName,$start,_loc3_,$overwriteProp || $propName);
         }
      }
   }
   function updateTweens($changeFactor)
   {
      var _loc3_;
      var _loc2_;
      if(this.round)
      {
         _loc3_ = this._tweens.length - 1;
         while(_loc3_ > -1)
         {
            _loc2_ = this._tweens[_loc3_];
            _loc2_.target[_loc2_.property] = Math.round(_loc2_.start + _loc2_.change * $changeFactor);
            _loc3_ = _loc3_ - 1;
         }
      }
      else
      {
         _loc3_ = this._tweens.length - 1;
         while(_loc3_ > -1)
         {
            _loc2_ = this._tweens[_loc3_];
            _loc2_.target[_loc2_.property] = _loc2_.start + _loc2_.change * $changeFactor;
            _loc3_ = _loc3_ - 1;
         }
      }
   }
   function set changeFactor($n)
   {
      this.updateTweens($n);
      this._changeFactor = $n;
   }
   function get changeFactor()
   {
      return this._changeFactor;
   }
   function killProps($lookup)
   {
      var _loc2_;
      _loc2_ = this.overwriteProps.length - 1;
      while(_loc2_ > -1)
      {
         if($lookup[this.overwriteProps[_loc2_]] != undefined)
         {
            this.overwriteProps.splice(_loc2_,1);
         }
         _loc2_ = _loc2_ - 1;
      }
      _loc2_ = this._tweens.length - 1;
      while(_loc2_ > -1)
      {
         if($lookup[this._tweens[_loc2_].name] != undefined)
         {
            this._tweens.splice(_loc2_,1);
         }
         _loc2_ = _loc2_ - 1;
      }
   }
   static function activate($plugins)
   {
      var _loc1_;
      var _loc3_;
      _loc1_ = $plugins.length - 1;
      while(_loc1_ > -1)
      {
         _loc3_ = new $plugins[_loc1_]();
         gs.TweenLite.plugins[_loc3_.propName] = $plugins[_loc1_];
         _loc1_ = _loc1_ - 1;
      }
      return true;
   }
}
