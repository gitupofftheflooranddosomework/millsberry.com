function FUIComponentClass()
{
   this.init();
}
FUIComponentClass.prototype = new MovieClip();
FUIComponentClass.prototype.init = function()
{
   this.enable = true;
   this.focused = false;
   this.useHandCursor = false;
   this._accImpl = new Object();
   this._accImpl.stub = true;
   this.styleTable = new Array();
   if(_global.globalStyleFormat == undefined)
   {
      _global.globalStyleFormat = new FStyleFormat();
      globalStyleFormat.isGlobal = true;
      _global._focusControl = new Object();
      _global._focusControl.onSetFocus = function(oldFocus, newFocus)
      {
         oldFocus.myOnKillFocus();
         newFocus.myOnSetFocus();
      };
      Selection.addListener(_global._focusControl);
   }
   if(this._name != undefined)
   {
      this._focusrect = false;
      this.tabEnabled = true;
      this.focusEnabled = true;
      this.tabChildren = false;
      this.tabFocused = true;
      if(this.hostStyle == undefined)
      {
         globalStyleFormat.addListener(this);
      }
      else
      {
         this.styleTable = this.hostStyle;
      }
      this.deadPreview._visible = false;
      this.deadPreview._width = this.deadPreview._height = 1;
      this.methodTable = new Object();
      this.keyListener = new Object();
      this.keyListener.controller = this;
      this.keyListener.onKeyDown = function()
      {
         this.controller.myOnKeyDown();
      };
      this.keyListener.onKeyUp = function()
      {
         this.controller.myOnKeyUp();
      };
      for(var _loc3_ in this.styleFormat_prm)
      {
         this.setStyleProperty(_loc3_,this.styleFormat_prm[_loc3_]);
      }
   }
};
FUIComponentClass.prototype.setEnabled = function(enabledFlag)
{
   this.enable = arguments.length <= 0 ? true : enabledFlag;
   this.tabEnabled = this.focusEnabled = enabledFlag;
   if(!this.enable && this.focused)
   {
      Selection.setFocus(undefined);
   }
};
FUIComponentClass.prototype.getEnabled = function()
{
   return this.enable;
};
FUIComponentClass.prototype.setSize = function(w, h)
{
   this.width = w;
   this.height = h;
   this.focusRect.removeMovieClip();
};
FUIComponentClass.prototype.setChangeHandler = function(chng, obj)
{
   this.handlerObj = obj != undefined ? obj : this._parent;
   this.changeHandler = chng;
};
FUIComponentClass.prototype.invalidate = function(methodName)
{
   this.methodTable[methodName] = true;
   this.onEnterFrame = this.cleanUI;
};
FUIComponentClass.prototype.cleanUI = function()
{
   if(this.methodTable.setSize)
   {
      this.setSize(this.width,this.height);
   }
   else
   {
      this.cleanUINotSize();
   }
   this.methodTable = new Object();
   delete this.onEnterFrame;
};
FUIComponentClass.prototype.cleanUINotSize = function()
{
   for(var _loc2_ in this.methodTable)
   {
      this[_loc2_]();
   }
};
FUIComponentClass.prototype.drawRect = function(x, y, w, h)
{
   var _loc4_ = this.styleTable.focusRectInner.value;
   var _loc5_ = this.styleTable.focusRectOuter.value;
   if(_loc4_ == undefined)
   {
      _loc4_ = 16777215;
   }
   if(_loc5_ == undefined)
   {
      _loc5_ = 0;
   }
   this.createEmptyMovieClip("focusRect",1000);
   this.focusRect.controller = this;
   this.focusRect.lineStyle(1,_loc5_);
   this.focusRect.moveTo(x,y);
   this.focusRect.lineTo(x + w,y);
   this.focusRect.lineTo(x + w,y + h);
   this.focusRect.lineTo(x,y + h);
   this.focusRect.lineTo(x,y);
   this.focusRect.lineStyle(1,_loc4_);
   this.focusRect.moveTo(x + 1,y + 1);
   this.focusRect.lineTo(x + w - 1,y + 1);
   this.focusRect.lineTo(x + w - 1,y + h - 1);
   this.focusRect.lineTo(x + 1,y + h - 1);
   this.focusRect.lineTo(x + 1,y + 1);
};
FUIComponentClass.prototype.pressFocus = function()
{
   this.tabFocused = false;
   this.focusRect.removeMovieClip();
   Selection.setFocus(this);
};
FUIComponentClass.prototype.drawFocusRect = function()
{
   this.drawRect(-2,-2,this.width + 4,this.height + 4);
};
FUIComponentClass.prototype.myOnSetFocus = function()
{
   this.focused = true;
   Key.addListener(this.keyListener);
   if(this.tabFocused)
   {
      this.drawFocusRect();
   }
};
FUIComponentClass.prototype.myOnKillFocus = function()
{
   this.tabFocused = true;
   this.focused = false;
   this.focusRect.removeMovieClip();
   Key.removeListener(this.keyListener);
};
FUIComponentClass.prototype.executeCallBack = function()
{
   this.handlerObj[this.changeHandler](this);
};
FUIComponentClass.prototype.updateStyleProperty = function(styleFormat, propName)
{
   this.setStyleProperty(propName,styleFormat[propName],styleFormat.isGlobal);
};
FUIComponentClass.prototype.setStyleProperty = function(propName, value, isGlobal)
{
   if(value == "")
   {
      return undefined;
   }
   var _loc17_ = parseInt(value);
   if(!isNaN(_loc17_))
   {
      value = _loc17_;
   }
   var _loc16_ = arguments.length <= 2 ? false : isGlobal;
   if(this.styleTable[propName] == undefined)
   {
      this.styleTable[propName] = new Object();
      this.styleTable[propName].useGlobal = true;
   }
   var _loc18_;
   var _loc4_;
   var _loc5_;
   if(this.styleTable[propName].useGlobal || !_loc16_)
   {
      this.styleTable[propName].value = value;
      if(!this.setCustomStyleProperty(propName,value))
      {
         if(propName == "embedFonts")
         {
            this.invalidate("setSize");
         }
         else if(propName.subString(0,4) == "text")
         {
            if(this.textStyle == undefined)
            {
               this.textStyle = new TextFormat();
            }
            _loc18_ = propName.subString(4,propName.length);
            this.textStyle[_loc18_] = value;
            this.invalidate("setSize");
         }
         else
         {
            for(var _loc15_ in this.styleTable[propName].coloredMCs)
            {
               _loc4_ = new Color(this.styleTable[propName].coloredMCs[_loc15_]);
               if(this.styleTable[propName].value == undefined)
               {
                  _loc5_ = {ra:"100",rb:"0",ga:"100",gb:"0",ba:"100",bb:"0",aa:"100",ab:"0"};
                  _loc4_.setTransform(_loc5_);
               }
               else
               {
                  _loc4_.setRGB(value);
               }
            }
         }
      }
      this.styleTable[propName].useGlobal = _loc16_;
   }
};
FUIComponentClass.prototype.registerSkinElement = function(skinMCRef, propName)
{
   if(this.styleTable[propName] == undefined)
   {
      this.styleTable[propName] = new Object();
      this.styleTable[propName].useGlobal = true;
   }
   if(this.styleTable[propName].coloredMCs == undefined)
   {
      this.styleTable[propName].coloredMCs = new Object();
   }
   this.styleTable[propName].coloredMCs[skinMCRef] = skinMCRef;
   var _loc3_;
   if(this.styleTable[propName].value != undefined)
   {
      _loc3_ = new Color(skinMCRef);
      _loc3_.setRGB(this.styleTable[propName].value);
   }
};
_global.FStyleFormat = function()
{
   this.nonStyles = {listeners:true,isGlobal:true,isAStyle:true,addListener:true,removeListener:true,nonStyles:true,applyChanges:true};
   this.listeners = new Object();
   this.isGlobal = false;
   if(arguments.length > 0)
   {
      for(var _loc3_ in arguments[0])
      {
         this[_loc3_] = arguments[0][_loc3_];
      }
   }
};
_global.FStyleFormat.prototype = new Object();
FStyleFormat.prototype.addListener = function()
{
   var _loc3_ = 0;
   var _loc4_;
   while(_loc3_ < arguments.length)
   {
      _loc4_ = arguments[_loc3_];
      this.listeners[arguments[_loc3_]] = _loc4_;
      for(var _loc5_ in this)
      {
         if(this.isAStyle(_loc5_))
         {
            _loc4_.updateStyleProperty(this,_loc5_.toString());
         }
      }
      _loc3_ = _loc3_ + 1;
   }
};
FStyleFormat.prototype.removeListener = function(component)
{
   this.listeners[component] = undefined;
   var _loc3_;
   for(var _loc4_ in this)
   {
      if(this.isAStyle(_loc4_))
      {
         if(component.styleTable[_loc4_].useGlobal == this.isGlobal)
         {
            component.styleTable[_loc4_].useGlobal = true;
            _loc3_ = !this.isGlobal ? globalStyleFormat[_loc4_] : undefined;
            component.setStyleProperty(_loc4_,_loc3_,true);
         }
      }
   }
};
FStyleFormat.prototype.applyChanges = function()
{
   var _loc6_ = 0;
   var _loc3_;
   var _loc4_;
   for(var _loc5_ in this.listeners)
   {
      _loc3_ = this.listeners[_loc5_];
      if(arguments.length > 0)
      {
         _loc4_ = 0;
         while(_loc4_ < arguments.length)
         {
            if(this.isAStyle(arguments[_loc4_]))
            {
               _loc3_.updateStyleProperty(this,arguments[_loc4_]);
            }
            _loc4_ = _loc4_ + 1;
         }
      }
      else
      {
         for(_loc4_ in this)
         {
            if(this.isAStyle(_loc4_))
            {
               _loc3_.updateStyleProperty(this,_loc4_.toString());
            }
         }
      }
   }
};
FStyleFormat.prototype.isAStyle = function(name)
{
   return !this.nonStyles[name] ? true : false;
};
