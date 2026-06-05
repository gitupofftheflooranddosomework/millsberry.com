class gs.plugins.FilterPlugin extends gs.plugins.TweenPlugin
{
   var _filter;
   var _index;
   var _remove;
   var _target;
   var _tweens;
   var _type;
   var addTween;
   var onComplete;
   var propName;
   static var VERSION = 1.03;
   static var API = 1;
   function FilterPlugin()
   {
      super();
   }
   function initFilter($props, $default)
   {
      var _loc5_ = this._target.filters;
      var _loc2_;
      var _loc4_;
      var _loc6_;
      this._index = -1;
      if($props.index != undefined)
      {
         this._index = $props.index;
      }
      else
      {
         _loc4_ = _loc5_.length - 1;
         while(_loc4_ > -1)
         {
            if(_loc5_[_loc4_] instanceof this._type)
            {
               this._index = _loc4_;
               break;
            }
            _loc4_ = _loc4_ - 1;
         }
      }
      if(this._index == -1 || _loc5_[this._index] == undefined || $props.addFilter == true)
      {
         this._index = $props.index == undefined ? _loc5_.length : $props.index;
         _loc5_[this._index] = $default;
         this._target.filters = _loc5_;
      }
      this._filter = _loc5_[this._index];
      this._remove = Boolean($props.remove == true);
      if(this._remove)
      {
         this.onComplete = this.onCompleteTween;
      }
      var _loc3_ = $props.isTV != true ? $props : $props.exposedVars;
      for(_loc2_ in _loc3_)
      {
         if(!(this._filter[_loc2_] == undefined || this._filter[_loc2_] == _loc3_[_loc2_] || _loc2_ == "remove" || _loc2_ == "index" || _loc2_ == "addFilter"))
         {
            if(_loc2_ == "color" || _loc2_ == "highlightColor" || _loc2_ == "shadowColor")
            {
               _loc6_ = new gs.plugins.HexColorsPlugin();
               _loc6_.initColor(this._filter,_loc2_,this._filter[_loc2_],_loc3_[_loc2_]);
               this._tweens[this._tweens.length] = new gs.utils.tween.TweenInfo(_loc6_,"changeFactor",0,1,this.propName);
            }
            else if(_loc2_ == "quality" || _loc2_ == "inner" || _loc2_ == "knockout" || _loc2_ == "hideObject")
            {
               this._filter[_loc2_] = _loc3_[_loc2_];
            }
            else
            {
               this.addTween(this._filter,_loc2_,this._filter[_loc2_],_loc3_[_loc2_],this.propName);
            }
         }
      }
   }
   function onCompleteTween()
   {
      var _loc2_;
      var _loc3_;
      if(this._remove)
      {
         _loc3_ = this._target.filters;
         if(!(_loc3_[this._index] instanceof this._type))
         {
            _loc2_ = _loc3_.length - 1;
            while(_loc2_ > -1)
            {
               if(_loc3_[_loc2_] instanceof this._type)
               {
                  _loc3_.splice(_loc2_,1);
                  break;
               }
               _loc2_ = _loc2_ - 1;
            }
         }
         else
         {
            _loc3_.splice(this._index,1);
         }
         this._target.filters = _loc3_;
      }
   }
   function set changeFactor($n)
   {
      var _loc2_;
      var _loc3_;
      var _loc4_ = this._target.filters;
      _loc2_ = this._tweens.length - 1;
      while(_loc2_ > -1)
      {
         _loc3_ = this._tweens[_loc2_];
         _loc3_.target[_loc3_.property] = _loc3_.start + _loc3_.change * $n;
         _loc2_ = _loc2_ - 1;
      }
      if(!(_loc4_[this._index] instanceof this._type))
      {
         this._index = _loc4_.length - 1;
         _loc2_ = _loc4_.length - 1;
         while(_loc2_ > -1)
         {
            if(_loc4_[_loc2_] instanceof this._type)
            {
               this._index = _loc2_;
               break;
            }
            _loc2_ = _loc2_ - 1;
         }
      }
      _loc4_[this._index] = this._filter;
      this._target.filters = _loc4_;
   }
}
