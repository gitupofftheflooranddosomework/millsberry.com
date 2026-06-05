class mx.core.ext.UIObjectExtensions
{
   var __enabled;
   var __getTextFormat;
   var __text;
   var _getTextFormat;
   var _visible;
   var align;
   var draw;
   var embedFonts;
   var enabledColor;
   var getStyle;
   var getTextFormat;
   var getValue;
   var invalidateFlag;
   var invalidateStyle;
   var setNewTextFormat;
   var setTextFormat;
   var setValue;
   var stylecache;
   var text;
   var textColor;
   var textHeight;
   var textWidth;
   static var bExtended = false;
   static var UIObjectExtended = mx.core.ext.UIObjectExtensions.Extensions();
   static var UIObjectDependency = mx.core.UIObject;
   static var SkinElementDependency = mx.skins.SkinElement;
   static var CSSTextStylesDependency = mx.styles.CSSTextStyles;
   static var UIEventDispatcherDependency = mx.events.UIEventDispatcher;
   function UIObjectExtensions()
   {
   }
   static function addGeometry(tf, ui)
   {
      tf.addProperty("width",ui.__get__width,null);
      tf.addProperty("height",ui.__get__height,null);
      tf.addProperty("left",ui.__get__left,null);
      tf.addProperty("x",ui.__get__x,null);
      tf.addProperty("top",ui.__get__top,null);
      tf.addProperty("y",ui.__get__y,null);
      tf.addProperty("right",ui.__get__right,null);
      tf.addProperty("bottom",ui.__get__bottom,null);
      tf.addProperty("visible",ui.__get__visible,ui.__set__visible);
   }
   static function Extensions()
   {
      if(mx.core.ext.UIObjectExtensions.bExtended == true)
      {
         return true;
      }
      mx.core.ext.UIObjectExtensions.bExtended = true;
      var _loc6_ = mx.core.UIObject.prototype;
      var _loc9_ = mx.skins.SkinElement.prototype;
      mx.core.ext.UIObjectExtensions.addGeometry(_loc9_,_loc6_);
      mx.events.UIEventDispatcher.initialize(_loc6_);
      var _loc13_ = mx.skins.ColoredSkinElement;
      mx.styles.CSSTextStyles.addTextStyles(_loc6_);
      var _loc5_ = MovieClip.prototype;
      _loc5_.getTopLevel = _loc6_.getTopLevel;
      _loc5_.createLabel = _loc6_.createLabel;
      _loc5_.createObject = _loc6_.createObject;
      _loc5_.createClassObject = _loc6_.createClassObject;
      _loc5_.createEmptyObject = _loc6_.createEmptyObject;
      _loc5_.destroyObject = _loc6_.destroyObject;
      _global.ASSetPropFlags(_loc5_,"getTopLevel",1);
      _global.ASSetPropFlags(_loc5_,"createLabel",1);
      _global.ASSetPropFlags(_loc5_,"createObject",1);
      _global.ASSetPropFlags(_loc5_,"createClassObject",1);
      _global.ASSetPropFlags(_loc5_,"createEmptyObject",1);
      _global.ASSetPropFlags(_loc5_,"destroyObject",1);
      _loc5_.__getTextFormat = _loc6_.__getTextFormat;
      _loc5_._getTextFormat = _loc6_._getTextFormat;
      _loc5_.getStyleName = _loc6_.getStyleName;
      _loc5_.getStyle = _loc6_.getStyle;
      _global.ASSetPropFlags(_loc5_,"__getTextFormat",1);
      _global.ASSetPropFlags(_loc5_,"_getTextFormat",1);
      _global.ASSetPropFlags(_loc5_,"getStyleName",1);
      _global.ASSetPropFlags(_loc5_,"getStyle",1);
      var _loc7_ = TextField.prototype;
      mx.core.ext.UIObjectExtensions.addGeometry(_loc7_,_loc6_);
      _loc7_.addProperty("enabled",function()
      {
         return this.__enabled;
      }
      ,function(x)
      {
         this.__enabled = x;
         this.invalidateStyle();
      }
      );
      _loc7_.move = _loc9_.move;
      _loc7_.setSize = _loc9_.setSize;
      _loc7_.invalidateStyle = function()
      {
         this.invalidateFlag = true;
      };
      _loc7_.draw = function()
      {
         var _loc2_;
         if(this.invalidateFlag)
         {
            this.invalidateFlag = false;
            _loc2_ = this._getTextFormat();
            this.setTextFormat(_loc2_);
            this.setNewTextFormat(_loc2_);
            this.embedFonts = _loc2_.embedFonts == true;
            if(this.__text != undefined)
            {
               if(this.text == "")
               {
                  this.text = this.__text;
               }
               delete this.__text;
            }
            this._visible = true;
         }
      };
      _loc7_.setColor = function(color)
      {
         this.textColor = color;
      };
      _loc7_.getStyle = _loc5_.getStyle;
      _loc7_.__getTextFormat = _loc6_.__getTextFormat;
      _loc7_.setValue = function(v)
      {
         this.text = v;
      };
      _loc7_.getValue = function()
      {
         return this.text;
      };
      _loc7_.addProperty("value",function()
      {
         return this.getValue();
      }
      ,function(v)
      {
         this.setValue(v);
      }
      );
      _loc7_._getTextFormat = function()
      {
         var _loc2_ = this.stylecache.tf;
         if(_loc2_ != undefined)
         {
            return _loc2_;
         }
         _loc2_ = new TextFormat();
         this.__getTextFormat(_loc2_);
         this.stylecache.tf = _loc2_;
         var _loc4_;
         var _loc3_;
         if(this.__enabled == false)
         {
            if(this.enabledColor == undefined)
            {
               _loc4_ = this.getTextFormat();
               this.enabledColor = _loc4_.color;
            }
            _loc3_ = this.getStyle("disabledColor");
            _loc2_.color = _loc3_;
         }
         else if(this.enabledColor != undefined)
         {
            if(_loc2_.color == undefined)
            {
               _loc2_.color = this.enabledColor;
            }
         }
         return _loc2_;
      };
      _loc7_.getPreferredWidth = function()
      {
         this.draw();
         return this.textWidth + 4;
      };
      _loc7_.getPreferredHeight = function()
      {
         this.draw();
         return this.textHeight + 4;
      };
      TextFormat.prototype.getTextExtent2 = function(s)
      {
         var _loc3_ = _root._getTextExtent;
         if(_loc3_ == undefined)
         {
            _root.createTextField("_getTextExtent",-2,0,0,1000,100);
            _loc3_ = _root._getTextExtent;
            _loc3_._visible = false;
         }
         _root._getTextExtent.text = s;
         var _loc4_ = this.align;
         this.align = "left";
         _root._getTextExtent.setTextFormat(this);
         this.align = _loc4_;
         return {width:_loc3_.textWidth,height:_loc3_.textHeight};
      };
      if(_global.style == undefined)
      {
         _global.style = new mx.styles.CSSStyleDeclaration();
         _global.cascadingStyles = true;
         _global.styles = new Object();
         _global.skinRegistry = new Object();
         if(_global._origWidth == undefined)
         {
            _global.origWidth = Stage.width;
            _global.origHeight = Stage.height;
         }
      }
      var _loc4_ = _root;
      while(_loc4_._parent != undefined)
      {
         _loc4_ = _loc4_._parent;
      }
      _loc4_.addProperty("width",function()
      {
         return Stage.width;
      }
      ,null);
      _loc4_.addProperty("height",function()
      {
         return Stage.height;
      }
      ,null);
      _global.ASSetPropFlags(_loc4_,"width",1);
      _global.ASSetPropFlags(_loc4_,"height",1);
      return true;
   }
}
