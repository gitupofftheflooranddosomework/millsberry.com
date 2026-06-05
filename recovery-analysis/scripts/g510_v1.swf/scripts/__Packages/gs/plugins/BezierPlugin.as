class gs.plugins.BezierPlugin extends gs.plugins.TweenPlugin
{
   var _beziers;
   var _orient;
   var _orientData;
   var _target;
   var overwriteProps;
   var propName;
   var round;
   static var VERSION = 1;
   static var API = 1;
   static var _RAD2DEG = 57.29577951308232;
   var _future = {};
   function BezierPlugin()
   {
      super();
      this.propName = "bezier";
      this.overwriteProps = [];
   }
   function onInitTween($target, $value, $tween)
   {
      if(!($value instanceof Array))
      {
         return false;
      }
      var _loc2_ = $value;
      this.init($tween,_loc2_,false);
      return true;
   }
   function init($tween, $beziers, $through)
   {
      this._target = $tween.target;
      var _loc5_ = {};
      var _loc3_;
      var _loc2_;
      if($tween.vars.orientToBezier == true)
      {
         this._orientData = [["_x","_y","_rotation",0]];
         this.overwriteProps[this.overwriteProps.length] = "_rotation";
         this._orient = true;
      }
      else if($tween.vars.orientToBezier instanceof Array)
      {
         this._orientData = $tween.vars.orientToBezier;
         _loc3_ = this._orientData.length - 1;
         while(_loc3_ > -1)
         {
            this.overwriteProps[this.overwriteProps.length] = this._orientData[_loc3_][2];
            _loc3_ = _loc3_ - 1;
         }
         this.overwriteProps[this.overwriteProps.length] = _loc2_;
         this._orient = true;
      }
      _loc3_ = 0;
      while(_loc3_ < $beziers.length)
      {
         for(_loc2_ in $beziers[_loc3_])
         {
            if(_loc5_[_loc2_] == undefined)
            {
               _loc5_[_loc2_] = [$tween.target[_loc2_]];
            }
            if(typeof $beziers[_loc3_][_loc2_] == "number")
            {
               _loc5_[_loc2_].push($beziers[_loc3_][_loc2_]);
            }
            else
            {
               _loc5_[_loc2_].push($tween.target[_loc2_] + Number($beziers[_loc3_][_loc2_]));
            }
         }
         _loc3_ = _loc3_ + 1;
      }
      for(_loc2_ in _loc5_)
      {
         this.overwriteProps[this.overwriteProps.length] = _loc2_;
         if($tween.vars[_loc2_] != undefined)
         {
            if(typeof $tween.vars[_loc2_] == "number")
            {
               _loc5_[_loc2_].push($tween.vars[_loc2_]);
            }
            else
            {
               _loc5_[_loc2_].push($tween.target[_loc2_] + Number($tween.vars[_loc2_]));
            }
            delete $tween.vars[_loc2_];
            _loc3_ = $tween.tweens.length - 1;
            while(_loc3_ > -1)
            {
               if($tween.tweens[_loc3_].name == _loc2_)
               {
                  $tween.tweens.splice(_loc3_,1);
               }
               _loc3_ = _loc3_ - 1;
            }
         }
      }
      this._beziers = gs.plugins.BezierPlugin.parseBeziers(_loc5_,$through);
   }
   static function parseBeziers($props, $through)
   {
      var _loc2_;
      var _loc1_;
      var _loc3_;
      var _loc4_;
      var _loc6_ = {};
      if($through == true)
      {
         for(_loc4_ in $props)
         {
            _loc1_ = $props[_loc4_];
            _loc6_[_loc4_] = _loc3_ = [];
            if(_loc1_.length > 2)
            {
               _loc3_[_loc3_.length] = [_loc1_[0],_loc1_[1] - (_loc1_[2] - _loc1_[0]) / 4,_loc1_[1]];
               _loc2_ = 1;
               while(_loc2_ < _loc1_.length - 1)
               {
                  _loc3_[_loc3_.length] = [_loc1_[_loc2_],_loc1_[_loc2_] + (_loc1_[_loc2_] - _loc3_[_loc2_ - 1][1]),_loc1_[_loc2_ + 1]];
                  _loc2_ = _loc2_ + 1;
               }
            }
            else
            {
               _loc3_[_loc3_.length] = [_loc1_[0],(_loc1_[0] + _loc1_[1]) / 2,_loc1_[1]];
            }
         }
      }
      else
      {
         for(_loc4_ in $props)
         {
            _loc1_ = $props[_loc4_];
            _loc6_[_loc4_] = _loc3_ = [];
            if(_loc1_.length > 3)
            {
               _loc3_[_loc3_.length] = [_loc1_[0],_loc1_[1],(_loc1_[1] + _loc1_[2]) / 2];
               _loc2_ = 2;
               while(_loc2_ < _loc1_.length - 2)
               {
                  _loc3_[_loc3_.length] = [_loc3_[_loc2_ - 2][2],_loc1_[_loc2_],(_loc1_[_loc2_] + _loc1_[_loc2_ + 1]) / 2];
                  _loc2_ = _loc2_ + 1;
               }
               _loc3_[_loc3_.length] = [_loc3_[_loc3_.length - 1][2],_loc1_[_loc1_.length - 2],_loc1_[_loc1_.length - 1]];
            }
            else if(_loc1_.length == 3)
            {
               _loc3_[_loc3_.length] = [_loc1_[0],_loc1_[1],_loc1_[2]];
            }
            else if(_loc1_.length == 2)
            {
               _loc3_[_loc3_.length] = [_loc1_[0],(_loc1_[0] + _loc1_[1]) / 2,_loc1_[1]];
            }
         }
      }
      return _loc6_;
   }
   function killProps($lookup)
   {
      for(var _loc5_ in this._beziers)
      {
         if($lookup[_loc5_] != undefined)
         {
            delete this._beziers[_loc5_];
         }
      }
      var _loc3_;
      if(this._orient)
      {
         _loc3_ = this._orientData.length - 1;
         while(_loc3_ > -1)
         {
            if($lookup[this._orientData[_loc3_][2]] != undefined)
            {
               this._orientData.splice(_loc3_,1);
            }
            _loc3_ = _loc3_ - 1;
         }
      }
      super.killProps($lookup);
   }
   function set changeFactor($n)
   {
      var _loc3_;
      var _loc4_;
      var _loc2_;
      var _loc5_;
      var _loc7_;
      if($n == 1)
      {
         for(_loc4_ in this._beziers)
         {
            _loc3_ = this._beziers[_loc4_].length - 1;
            this._target[_loc4_] = this._beziers[_loc4_][_loc3_][2];
         }
      }
      else
      {
         for(_loc4_ in this._beziers)
         {
            _loc7_ = this._beziers[_loc4_].length;
            if($n < 0)
            {
               _loc3_ = 0;
            }
            else if($n >= 1)
            {
               _loc3_ = _loc7_ - 1;
            }
            else
            {
               _loc3_ = _loc7_ * $n >> 0;
            }
            _loc5_ = ($n - _loc3_ * (1 / _loc7_)) * _loc7_;
            _loc2_ = this._beziers[_loc4_][_loc3_];
            if(this.round)
            {
               this._target[_loc4_] = Math.round(_loc2_[0] + _loc5_ * (2 * (1 - _loc5_) * (_loc2_[1] - _loc2_[0]) + _loc5_ * (_loc2_[2] - _loc2_[0])));
            }
            else
            {
               this._target[_loc4_] = _loc2_[0] + _loc5_ * (2 * (1 - _loc5_) * (_loc2_[1] - _loc2_[0]) + _loc5_ * (_loc2_[2] - _loc2_[0]));
            }
         }
      }
      var _loc12_;
      var _loc13_;
      var _loc10_;
      var _loc9_;
      var _loc6_;
      var _loc11_;
      if(this._orient)
      {
         _loc12_ = this._target;
         _loc13_ = this.round;
         this._target = this._future;
         this.round = false;
         this._orient = false;
         this.changeFactor = $n + 0.01;
         this._target = _loc12_;
         this.round = _loc13_;
         this._orient = true;
         _loc3_ = 0;
         while(_loc3_ < this._orientData.length)
         {
            _loc6_ = this._orientData[_loc3_];
            _loc11_ = _loc6_[3] || 0;
            _loc10_ = this._future[_loc6_[0]] - this._target[_loc6_[0]];
            _loc9_ = this._future[_loc6_[1]] - this._target[_loc6_[1]];
            this._target[_loc6_[2]] = Math.atan2(_loc9_,_loc10_) * gs.plugins.BezierPlugin._RAD2DEG + _loc11_;
            _loc3_ = _loc3_ + 1;
         }
      }
   }
}
