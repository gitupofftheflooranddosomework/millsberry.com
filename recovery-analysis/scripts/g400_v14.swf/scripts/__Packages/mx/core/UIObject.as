class mx.core.UIObject extends MovieClip
{
   var __height;
   var __width;
   var _endInit;
   var _minHeight;
   var _minWidth;
   var _tf;
   var buildDepthTable;
   var childrenCreated;
   var className;
   var color;
   var createAccessibilityImplementation;
   var dispatchEvent;
   var embedFonts;
   var findNextAvailableDepth;
   var fontFamily;
   var fontSize;
   var fontStyle;
   var fontWeight;
   var hasOwnProperty;
   var idNames;
   var ignoreClassStyleDeclaration;
   var initProperties;
   var marginLeft;
   var marginRight;
   var methodTable;
   var onEnterFrame;
   var styleName;
   var stylecache;
   var textAlign;
   var textDecoration;
   var textIndent;
   var tfList;
   var validateNow;
   static var symbolName = "UIObject";
   static var symbolOwner = mx.core.UIObject;
   static var version = "2.0.2.126";
   static var textColorList = {color:1,disabledColor:1};
   var invalidateFlag = false;
   var lineWidth = 1;
   var lineColor = 0;
   var tabEnabled = false;
   var clipParameters = {visible:1,minHeight:1,minWidth:1,maxHeight:1,maxWidth:1,preferredHeight:1,preferredWidth:1};
   function UIObject()
   {
      super();
      this.constructObject();
   }
   function get width()
   {
      return this._width;
   }
   function get height()
   {
      return this._height;
   }
   function get left()
   {
      return this._x;
   }
   function get x()
   {
      return this._x;
   }
   function get top()
   {
      return this._y;
   }
   function get y()
   {
      return this._y;
   }
   function get right()
   {
      return this._parent.width - (this._x + this.width);
   }
   function get bottom()
   {
      return this._parent.height - (this._y + this.height);
   }
   function getMinHeight(Void)
   {
      return this._minHeight;
   }
   function setMinHeight(h)
   {
      this._minHeight = h;
   }
   function get minHeight()
   {
      return this.getMinHeight();
   }
   function set minHeight(h)
   {
      this.setMinHeight(h);
   }
   function getMinWidth(Void)
   {
      return this._minWidth;
   }
   function setMinWidth(w)
   {
      this._minWidth = w;
   }
   function get minWidth()
   {
      return this.getMinWidth();
   }
   function set minWidth(w)
   {
      this.setMinWidth(w);
   }
   function setVisible(x, noEvent)
   {
      if(x != this._visible)
      {
         this._visible = x;
         if(noEvent != true)
         {
            this.dispatchEvent({type:(!x ? "hide" : "reveal")});
         }
      }
   }
   function get visible()
   {
      return this._visible;
   }
   function set visible(x)
   {
      this.setVisible(x,false);
   }
   function get scaleX()
   {
      return this._xscale;
   }
   function set scaleX(x)
   {
      this._xscale = x;
   }
   function get scaleY()
   {
      return this._yscale;
   }
   function set scaleY(y)
   {
      this._yscale = y;
   }
   function doLater(obj, fn)
   {
      if(this.methodTable == undefined)
      {
         this.methodTable = new Array();
      }
      this.methodTable.push({obj:obj,fn:fn});
      this.onEnterFrame = this.doLaterDispatcher;
   }
   function doLaterDispatcher(Void)
   {
      delete this.onEnterFrame;
      if(this.invalidateFlag)
      {
         this.redraw();
      }
      var _loc3_ = this.methodTable;
      this.methodTable = new Array();
      var _loc2_;
      if(_loc3_.length > 0)
      {
         while((_loc2_ = _loc3_.shift()) != undefined)
         {
            _loc2_.obj[_loc2_.fn]();
         }
      }
   }
   function cancelAllDoLaters(Void)
   {
      delete this.onEnterFrame;
      this.methodTable = new Array();
   }
   function invalidate(Void)
   {
      this.invalidateFlag = true;
      this.onEnterFrame = this.doLaterDispatcher;
   }
   function invalidateStyle(Void)
   {
      this.invalidate();
   }
   function redraw(bAlways)
   {
      var _loc2_;
      if(this.invalidateFlag || bAlways)
      {
         this.invalidateFlag = false;
         for(_loc2_ in this.tfList)
         {
            this.tfList[_loc2_].draw();
         }
         this.draw();
         this.dispatchEvent({type:"draw"});
      }
   }
   function draw(Void)
   {
   }
   function move(x, y, noEvent)
   {
      var _loc3_ = this._x;
      var _loc2_ = this._y;
      this._x = x;
      this._y = y;
      if(noEvent != true)
      {
         this.dispatchEvent({type:"move",oldX:_loc3_,oldY:_loc2_});
      }
   }
   function setSize(w, h, noEvent)
   {
      var _loc2_ = this.__width;
      var _loc3_ = this.__height;
      this.__width = w;
      this.__height = h;
      this.size();
      if(noEvent != true)
      {
         this.dispatchEvent({type:"resize",oldWidth:_loc2_,oldHeight:_loc3_});
      }
   }
   function size(Void)
   {
      this._width = this.__width;
      this._height = this.__height;
   }
   function drawRect(x1, y1, x2, y2)
   {
      this.moveTo(x1,y1);
      this.lineTo(x2,y1);
      this.lineTo(x2,y2);
      this.lineTo(x1,y2);
      this.lineTo(x1,y1);
   }
   function createLabel(name, depth, text)
   {
      this.createTextField(name,depth,0,0,0,0);
      var _loc2_ = this[name];
      _loc2_._color = mx.core.UIObject.textColorList;
      _loc2_._visible = false;
      _loc2_.__text = text;
      if(this.tfList == undefined)
      {
         this.tfList = new Object();
      }
      this.tfList[name] = _loc2_;
      _loc2_.invalidateStyle();
      this.invalidate();
      _loc2_.styleName = this;
      return _loc2_;
   }
   function createObject(linkageName, id, depth, initobj)
   {
      return this.attachMovie(linkageName,id,depth,initobj);
   }
   function createClassObject(className, id, depth, initobj)
   {
      var _loc3_ = className.symbolName == undefined;
      if(_loc3_)
      {
         Object.registerClass(className.symbolOwner.symbolName,className);
      }
      var _loc4_ = this.createObject(className.symbolOwner.symbolName,id,depth,initobj);
      if(_loc3_)
      {
         Object.registerClass(className.symbolOwner.symbolName,className.symbolOwner);
      }
      return _loc4_;
   }
   function createEmptyObject(id, depth)
   {
      return this.createClassObject(mx.core.UIObject,id,depth);
   }
   function destroyObject(id)
   {
      var _loc2_ = this[id];
      var _loc4_;
      var _loc5_;
      var _loc3_;
      if(_loc2_.getDepth() < 0)
      {
         _loc4_ = this.buildDepthTable();
         _loc5_ = this.findNextAvailableDepth(0,_loc4_,"up");
         _loc3_ = _loc5_;
         _loc2_.swapDepths(_loc3_);
      }
      _loc2_.removeMovieClip();
      delete this[id];
   }
   function getSkinIDName(tag)
   {
      return this.idNames[tag];
   }
   function setSkin(tag, linkageName, initObj)
   {
      if(_global.skinRegistry[linkageName] == undefined)
      {
         mx.skins.SkinElement.registerElement(linkageName,mx.skins.SkinElement);
      }
      return this.createObject(linkageName,this.getSkinIDName(tag),tag,initObj);
   }
   function createSkin(tag)
   {
      var _loc2_ = this.getSkinIDName(tag);
      this.createEmptyObject(_loc2_,tag);
      return this[_loc2_];
   }
   function createChildren(Void)
   {
   }
   function _createChildren(Void)
   {
      this.createChildren();
      this.childrenCreated = true;
   }
   function constructObject(Void)
   {
      if(this._name == undefined)
      {
         return undefined;
      }
      this.init();
      this._createChildren();
      this.createAccessibilityImplementation();
      this._endInit();
      if(this.validateNow)
      {
         this.redraw(true);
      }
      else
      {
         this.invalidate();
      }
   }
   function initFromClipParameters(Void)
   {
      var _loc4_ = false;
      var _loc2_;
      for(_loc2_ in this.clipParameters)
      {
         if(this.hasOwnProperty(_loc2_))
         {
            _loc4_ = true;
            this["def_" + _loc2_] = this[_loc2_];
            delete this[_loc2_];
         }
      }
      var _loc3_;
      if(_loc4_)
      {
         for(_loc2_ in this.clipParameters)
         {
            _loc3_ = this["def_" + _loc2_];
            if(_loc3_ != undefined)
            {
               this[_loc2_] = _loc3_;
            }
         }
      }
   }
   function init(Void)
   {
      this.__width = this._width;
      this.__height = this._height;
      if(this.initProperties == undefined)
      {
         this.initFromClipParameters();
      }
      else
      {
         this.initProperties();
      }
      if(_global.cascadingStyles == true)
      {
         this.stylecache = new Object();
      }
   }
   function getClassStyleDeclaration(Void)
   {
      var _loc4_ = this;
      var _loc3_ = this.className;
      while(_loc3_ != undefined)
      {
         if(this.ignoreClassStyleDeclaration[_loc3_] == undefined)
         {
            if(_global.styles[_loc3_] != undefined)
            {
               return _global.styles[_loc3_];
            }
         }
         _loc4_ = _loc4_.__proto__;
         _loc3_ = _loc4_.className;
      }
   }
   function setColor(color)
   {
   }
   function __getTextFormat(tf, bAll)
   {
      var _loc8_ = this.stylecache.tf;
      var _loc3_;
      if(_loc8_ != undefined)
      {
         for(_loc3_ in mx.styles.StyleManager.TextFormatStyleProps)
         {
            if(bAll || mx.styles.StyleManager.TextFormatStyleProps[_loc3_])
            {
               if(tf[_loc3_] == undefined)
               {
                  tf[_loc3_] = _loc8_[_loc3_];
               }
            }
         }
         return false;
      }
      var _loc6_ = false;
      var _loc5_;
      for(_loc3_ in mx.styles.StyleManager.TextFormatStyleProps)
      {
         if(bAll || mx.styles.StyleManager.TextFormatStyleProps[_loc3_])
         {
            if(tf[_loc3_] == undefined)
            {
               _loc5_ = this._tf[_loc3_];
               if(_loc5_ != undefined)
               {
                  tf[_loc3_] = _loc5_;
               }
               else if(_loc3_ == "font" && this.fontFamily != undefined)
               {
                  tf[_loc3_] = this.fontFamily;
               }
               else if(_loc3_ == "size" && this.fontSize != undefined)
               {
                  tf[_loc3_] = this.fontSize;
               }
               else if(_loc3_ == "color" && this.color != undefined)
               {
                  tf[_loc3_] = this.color;
               }
               else if(_loc3_ == "leftMargin" && this.marginLeft != undefined)
               {
                  tf[_loc3_] = this.marginLeft;
               }
               else if(_loc3_ == "rightMargin" && this.marginRight != undefined)
               {
                  tf[_loc3_] = this.marginRight;
               }
               else if(_loc3_ == "italic" && this.fontStyle != undefined)
               {
                  tf[_loc3_] = this.fontStyle == _loc3_;
               }
               else if(_loc3_ == "bold" && this.fontWeight != undefined)
               {
                  tf[_loc3_] = this.fontWeight == _loc3_;
               }
               else if(_loc3_ == "align" && this.textAlign != undefined)
               {
                  tf[_loc3_] = this.textAlign;
               }
               else if(_loc3_ == "indent" && this.textIndent != undefined)
               {
                  tf[_loc3_] = this.textIndent;
               }
               else if(_loc3_ == "underline" && this.textDecoration != undefined)
               {
                  tf[_loc3_] = this.textDecoration == _loc3_;
               }
               else if(_loc3_ == "embedFonts" && this.embedFonts != undefined)
               {
                  tf[_loc3_] = this.embedFonts;
               }
               else
               {
                  _loc6_ = true;
               }
            }
         }
      }
      var _loc9_;
      if(_loc6_)
      {
         _loc9_ = this.styleName;
         if(_loc9_ != undefined)
         {
            if(typeof _loc9_ != "string")
            {
               _loc6_ = _loc9_.__getTextFormat(tf,true,this);
            }
            else if(_global.styles[_loc9_] != undefined)
            {
               _loc6_ = _global.styles[_loc9_].__getTextFormat(tf,true,this);
            }
         }
      }
      var _loc10_;
      if(_loc6_)
      {
         _loc10_ = this.getClassStyleDeclaration();
         if(_loc10_ != undefined)
         {
            _loc6_ = _loc10_.__getTextFormat(tf,true,this);
         }
      }
      if(_loc6_)
      {
         if(_global.cascadingStyles)
         {
            if(this._parent != undefined)
            {
               _loc6_ = this._parent.__getTextFormat(tf,false);
            }
         }
      }
      if(_loc6_)
      {
         _loc6_ = _global.style.__getTextFormat(tf,true,this);
      }
      return _loc6_;
   }
   function _getTextFormat(Void)
   {
      var _loc2_ = this.stylecache.tf;
      if(_loc2_ != undefined)
      {
         return _loc2_;
      }
      _loc2_ = new TextFormat();
      this.__getTextFormat(_loc2_,true);
      this.stylecache.tf = _loc2_;
      var _loc3_;
      if(this.enabled == false)
      {
         _loc3_ = this.getStyle("disabledColor");
         _loc2_.color = _loc3_;
      }
      return _loc2_;
   }
   function getStyleName(Void)
   {
      var _loc2_ = this.styleName;
      if(_loc2_ != undefined)
      {
         if(typeof _loc2_ != "string")
         {
            return _loc2_.getStyleName();
         }
         return _loc2_;
      }
      if(this._parent != undefined)
      {
         return this._parent.getStyleName();
      }
      return undefined;
   }
   function getStyle(styleProp)
   {
      var _loc3_;
      _global.getStyleCounter = _global.getStyleCounter + 1;
      if(this[styleProp] != undefined)
      {
         return this[styleProp];
      }
      var _loc6_ = this.styleName;
      var _loc7_;
      if(_loc6_ != undefined)
      {
         if(typeof _loc6_ != "string")
         {
            _loc3_ = _loc6_.getStyle(styleProp);
         }
         else
         {
            _loc7_ = _global.styles[_loc6_];
            _loc3_ = _loc7_.getStyle(styleProp);
         }
      }
      if(_loc3_ != undefined)
      {
         return _loc3_;
      }
      _loc7_ = this.getClassStyleDeclaration();
      if(_loc7_ != undefined)
      {
         _loc3_ = _loc7_[styleProp];
      }
      if(_loc3_ != undefined)
      {
         return _loc3_;
      }
      var _loc5_;
      if(_global.cascadingStyles)
      {
         if(mx.styles.StyleManager.isInheritingStyle(styleProp) || mx.styles.StyleManager.isColorStyle(styleProp))
         {
            _loc5_ = this.stylecache;
            if(_loc5_ != undefined)
            {
               if(_loc5_[styleProp] != undefined)
               {
                  return _loc5_[styleProp];
               }
            }
            if(this._parent != undefined)
            {
               _loc3_ = this._parent.getStyle(styleProp);
            }
            else
            {
               _loc3_ = _global.style[styleProp];
            }
            if(_loc5_ != undefined)
            {
               _loc5_[styleProp] = _loc3_;
            }
            return _loc3_;
         }
      }
      if(_loc3_ == undefined)
      {
         _loc3_ = _global.style[styleProp];
      }
      return _loc3_;
   }
   static function mergeClipParameters(o, p)
   {
      for(var _loc3_ in p)
      {
         o[_loc3_] = p[_loc3_];
      }
      return true;
   }
}
