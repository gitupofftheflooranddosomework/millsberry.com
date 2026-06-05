class mx.styles.CSSStyleDeclaration
{
   var _tf;
   static var classConstructed = mx.styles.CSSStyleDeclaration.classConstruct();
   static var CSSTextStylesDependency = mx.styles.CSSTextStyles;
   function CSSStyleDeclaration()
   {
   }
   function __getTextFormat(tf, bAll)
   {
      var _loc5_ = false;
      var _loc2_;
      var _loc3_;
      if(this._tf != undefined)
      {
         for(_loc2_ in mx.styles.StyleManager.TextFormatStyleProps)
         {
            if(bAll || mx.styles.StyleManager.TextFormatStyleProps[_loc2_])
            {
               if(tf[_loc2_] == undefined)
               {
                  _loc3_ = this._tf[_loc2_];
                  if(_loc3_ != undefined)
                  {
                     tf[_loc2_] = _loc3_;
                  }
                  else
                  {
                     _loc5_ = true;
                  }
               }
            }
         }
      }
      else
      {
         _loc5_ = true;
      }
      return _loc5_;
   }
   function getStyle(styleProp)
   {
      var _loc2_ = this[styleProp];
      var _loc3_ = mx.styles.StyleManager.getColorName(_loc2_);
      return _loc3_ != undefined ? _loc3_ : _loc2_;
   }
   static function classConstruct()
   {
      mx.styles.CSSTextStyles.addTextStyles(mx.styles.CSSStyleDeclaration.prototype,true);
      return true;
   }
}
