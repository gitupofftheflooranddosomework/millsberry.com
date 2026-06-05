function FUIComponentClass()
{
   this.init();
}
FUIComponentClass.prototype = new MovieClip();
FUIComponentClass.prototype.init = function()
{
   var _loc1_ = this;
   var _loc3_ = _global;
   _loc1_.enable = true;
   _loc1_.focused = false;
   _loc1_.useHandCursor = false;
   _loc1_._accImpl = new Object();
   _loc1_._accImpl.stub = true;
   _loc1_.styleTable = new Array();
   if(_loc3_.globalStyleFormat == undefined)
   {
      _loc3_.globalStyleFormat = new FStyleFormat();
      globalStyleFormat.isGlobal = true;
      _loc3_._focusControl = new Object();
      _loc3_._focusControl.onSetFocus = function(oldFocus, newFocus)
      {
         oldFocus.myOnKillFocus();
         newFocus.myOnSetFocus();
      };
      Selection.addListener(_loc3_._focusControl);
   }
   if(_loc1_._name != undefined)
   {
      _loc1_._focusrect = false;
      _loc1_.tabEnabled = true;
      _loc1_.focusEnabled = true;
      _loc1_.tabChildren = false;
      _loc1_.tabFocused = true;
      if(_loc1_.hostStyle == undefined)
      {
         globalStyleFormat.addListener(_loc1_);
      }
      else
      {
         _loc1_.styleTable = _loc1_.hostStyle;
      }
      _loc1_.deadPreview._visible = false;
      _loc1_.deadPreview._width = _loc1_.deadPreview._height = 1;
      _loc1_.methodTable = new Object();
      _loc1_.keyListener = new Object();
      _loc1_.keyListener.controller = _loc1_;
      _loc1_.keyListener.onKeyDown = function()
      {
         this.controller.myOnKeyDown();
      };
      _loc1_.keyListener.onKeyUp = function()
      {
         this.controller.myOnKeyUp();
      };
      for(var _loc2_ in _loc1_.styleFormat_prm)
      {
         _loc1_.setStyleProperty(_loc2_,_loc1_.styleFormat_prm[_loc2_]);
      }
   }
};
FUIComponentClass.prototype.setEnabled = function(enabledFlag)
{
   var _loc1_ = this;
   _loc1_.enable = arguments.length <= 0 ? true : enabledFlag;
   _loc1_.tabEnabled = _loc1_.focusEnabled = enabledFlag;
   if(!_loc1_.enable && _loc1_.focused)
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
   var _loc1_ = this;
   _loc1_.width = w;
   _loc1_.height = h;
   _loc1_.focusRect.removeMovieClip();
};
FUIComponentClass.prototype.setChangeHandler = function(chng, obj)
{
   var _loc1_ = this;
   _loc1_.handlerObj = obj != undefined ? obj : _loc1_._parent;
   _loc1_.changeHandler = chng;
};
FUIComponentClass.prototype.invalidate = function(methodName)
{
   var _loc1_ = this;
   _loc1_.methodTable[methodName] = true;
   _loc1_.onEnterFrame = _loc1_.cleanUI;
};
FUIComponentClass.prototype.cleanUI = function()
{
   var _loc1_ = this;
   if(_loc1_.methodTable.setSize)
   {
      _loc1_.setSize(_loc1_.width,_loc1_.height);
   }
   else
   {
      _loc1_.cleanUINotSize();
   }
   _loc1_.methodTable = new Object();
   delete _loc1_.onEnterFrame;
};
FUIComponentClass.prototype.cleanUINotSize = function()
{
   var _loc1_ = this;
   for(var _loc2_ in _loc1_.methodTable)
   {
      _loc1_[_loc2_]();
   }
};
FUIComponentClass.prototype.drawRect = function(x, y, w, h)
{
   var _loc1_ = this;
   var _loc2_ = y;
   var _loc3_ = x;
   var inner = _loc1_.styleTable.focusRectInner.value;
   var outer = _loc1_.styleTable.focusRectOuter.value;
   if(inner == undefined)
   {
      inner = 16777215;
   }
   if(outer == undefined)
   {
      outer = 0;
   }
   _loc1_.createEmptyMovieClip("focusRect",1000);
   _loc1_.focusRect.controller = _loc1_;
   _loc1_.focusRect.lineStyle(1,outer);
   _loc1_.focusRect.moveTo(_loc3_,_loc2_);
   _loc1_.focusRect.lineTo(_loc3_ + w,_loc2_);
   _loc1_.focusRect.lineTo(_loc3_ + w,_loc2_ + h);
   _loc1_.focusRect.lineTo(_loc3_,_loc2_ + h);
   _loc1_.focusRect.lineTo(_loc3_,_loc2_);
   _loc1_.focusRect.lineStyle(1,inner);
   _loc1_.focusRect.moveTo(_loc3_ + 1,_loc2_ + 1);
   _loc1_.focusRect.lineTo(_loc3_ + w - 1,_loc2_ + 1);
   _loc1_.focusRect.lineTo(_loc3_ + w - 1,_loc2_ + h - 1);
   _loc1_.focusRect.lineTo(_loc3_ + 1,_loc2_ + h - 1);
   _loc1_.focusRect.lineTo(_loc3_ + 1,_loc2_ + 1);
};
FUIComponentClass.prototype.pressFocus = function()
{
   var _loc1_ = this;
   _loc1_.tabFocused = false;
   _loc1_.focusRect.removeMovieClip();
   Selection.setFocus(_loc1_);
};
FUIComponentClass.prototype.drawFocusRect = function()
{
   var _loc1_ = this;
   _loc1_.drawRect(-2,-2,_loc1_.width + 4,_loc1_.height + 4);
};
FUIComponentClass.prototype.myOnSetFocus = function()
{
   var _loc1_ = this;
   _loc1_.focused = true;
   Key.addListener(_loc1_.keyListener);
   if(_loc1_.tabFocused)
   {
      _loc1_.drawFocusRect();
   }
};
FUIComponentClass.prototype.myOnKillFocus = function()
{
   var _loc1_ = this;
   _loc1_.tabFocused = true;
   _loc1_.focused = false;
   _loc1_.focusRect.removeMovieClip();
   Key.removeListener(_loc1_.keyListener);
};
FUIComponentClass.prototype.executeCallBack = function()
{
   var _loc1_ = this;
   _loc1_.handlerObj[_loc1_.changeHandler](_loc1_);
};
FUIComponentClass.prototype.updateStyleProperty = function(styleFormat, propName)
{
   this.setStyleProperty(propName,styleFormat[propName],styleFormat.isGlobal);
};
FUIComponentClass.prototype.setStyleProperty = function(propName, value, isGlobal)
{
   var _loc1_ = this;
   var _loc2_ = propName;
   var _loc3_;
   if(value != "")
   {
      var tmpValue = parseInt(value);
      if(!isNaN(tmpValue))
      {
         value = tmpValue;
      }
      var global = arguments.length <= 2 ? false : isGlobal;
      if(_loc1_.styleTable[_loc2_] == undefined)
      {
         _loc1_.styleTable[_loc2_] = new Object();
         _loc1_.styleTable[_loc2_].useGlobal = true;
      }
      if(_loc1_.styleTable[_loc2_].useGlobal || !global)
      {
         _loc1_.styleTable[_loc2_].value = value;
         if(!_loc1_.setCustomStyleProperty(_loc2_,value))
         {
            if(_loc2_ == "embedFonts")
            {
               _loc1_.invalidate("setSize");
            }
            else if(_loc2_.substring(0,4) == "text")
            {
               if(_loc1_.textStyle == undefined)
               {
                  _loc1_.textStyle = new TextFormat();
               }
               var textProp = _loc2_.substring(4,_loc2_.length);
               var firstChar = textProp.substring(0,1);
               firstChar = firstChar.toLowerCase();
               textProp = firstChar + textProp.substring(1,textProp.length);
               _loc1_.textStyle[textProp] = value;
               _loc1_.invalidate("setSize");
            }
            else
            {
               for(var j in _loc1_.styleTable[_loc2_].coloredMCs)
               {
                  _loc3_ = new Color(_loc1_.styleTable[_loc2_].coloredMCs[j]);
                  if(_loc1_.styleTable[_loc2_].value == undefined)
                  {
                     var myTObj = {ra:"100",rb:"0",ga:"100",gb:"0",ba:"100",bb:"0",aa:"100",ab:"0"};
                     _loc3_.setTransform(myTObj);
                  }
                  else
                  {
                     _loc3_.setRGB(value);
                  }
               }
            }
         }
         _loc1_.styleTable[_loc2_].useGlobal = global;
      }
   }
};
FUIComponentClass.prototype.registerSkinElement = function(skinMCRef, propName)
{
   var _loc1_ = this;
   var _loc2_ = propName;
   if(_loc1_.styleTable[_loc2_] == undefined)
   {
      _loc1_.styleTable[_loc2_] = new Object();
      _loc1_.styleTable[_loc2_].useGlobal = true;
   }
   if(_loc1_.styleTable[_loc2_].coloredMCs == undefined)
   {
      _loc1_.styleTable[_loc2_].coloredMCs = new Object();
   }
   _loc1_.styleTable[_loc2_].coloredMCs[skinMCRef] = skinMCRef;
   var _loc3_;
   if(_loc1_.styleTable[_loc2_].value != undefined)
   {
      _loc3_ = new Color(skinMCRef);
      _loc3_.setRGB(_loc1_.styleTable[_loc2_].value);
   }
};
_global.FStyleFormat = function()
{
   var _loc1_ = arguments;
   var _loc2_ = this;
   _loc2_.nonStyles = {listeners:true,isGlobal:true,isAStyle:true,addListener:true,removeListener:true,nonStyles:true,applyChanges:true};
   _loc2_.listeners = new Object();
   _loc2_.isGlobal = false;
   if(_loc1_.length > 0)
   {
      for(var _loc3_ in _loc1_[0])
      {
         _loc2_[_loc3_] = _loc1_[0][_loc3_];
      }
   }
};
_global.FStyleFormat.prototype = new Object();
FStyleFormat.prototype.addListener = function()
{
   var _loc1_ = this;
   var _loc2_ = 0;
   var _loc3_;
   while(_loc2_ < arguments.length)
   {
      _loc3_ = arguments[_loc2_];
      _loc1_.listeners[arguments[_loc2_]] = _loc3_;
      for(var i in _loc1_)
      {
         if(_loc1_.isAStyle(i))
         {
            _loc3_.updateStyleProperty(_loc1_,i.toString());
         }
      }
      _loc2_ = _loc2_ + 1;
   }
};
FStyleFormat.prototype.removeListener = function(component)
{
   var _loc1_ = this;
   var _loc2_ = component;
   _loc1_.listeners[_loc2_] = undefined;
   var _loc3_;
   for(var prop in _loc1_)
   {
      if(_loc1_.isAStyle(prop))
      {
         if(_loc2_.styleTable[prop].useGlobal == _loc1_.isGlobal)
         {
            _loc2_.styleTable[prop].useGlobal = true;
            _loc3_ = !_loc1_.isGlobal ? globalStyleFormat[prop] : undefined;
            _loc2_.setStyleProperty(prop,_loc3_,true);
         }
      }
   }
};
FStyleFormat.prototype.applyChanges = function()
{
   var _loc1_ = this;
   var _loc2_ = arguments;
   var count = 0;
   var _loc3_;
   for(var i in _loc1_.listeners)
   {
      _loc3_ = _loc1_.listeners[i];
      if(_loc2_.length > 0)
      {
         var j = 0;
         while(j < _loc2_.length)
         {
            if(_loc1_.isAStyle(_loc2_[j]))
            {
               _loc3_.updateStyleProperty(_loc1_,_loc2_[j]);
            }
            j++;
         }
      }
      else
      {
         for(var j in _loc1_)
         {
            if(_loc1_.isAStyle(j))
            {
               _loc3_.updateStyleProperty(_loc1_,j.toString());
            }
         }
      }
   }
};
FStyleFormat.prototype.isAStyle = function(name)
{
   return !this.nonStyles[name] ? true : false;
};
