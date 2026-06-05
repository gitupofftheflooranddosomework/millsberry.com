class mx.core.UIComponent extends mx.core.UIObject
{
   var __height;
   var __width;
   var _focusrect;
   var _xscale;
   var _yscale;
   var addEventListener;
   var dispatchEvent;
   var drawFocus;
   var enabled;
   var invalidate;
   var removeEventListener;
   var stylecache;
   var watch;
   static var symbolName = "UIComponent";
   static var symbolOwner = mx.core.UIComponent;
   static var version = "2.0.2.126";
   static var kStretch = 5000;
   var focusEnabled = true;
   var tabEnabled = true;
   var origBorderStyles = {themeColor:16711680};
   var clipParameters = {};
   static var mergedClipParameters = mx.core.UIObject.mergeClipParameters(mx.core.UIComponent.prototype.clipParameters,mx.core.UIObject.prototype.clipParameters);
   function UIComponent()
   {
      super();
   }
   function get width()
   {
      return this.__width;
   }
   function get height()
   {
      return this.__height;
   }
   function setVisible(x, noEvent)
   {
      super.setVisible(x,noEvent);
   }
   function enabledChanged(id, oldValue, newValue)
   {
      this.setEnabled(newValue);
      this.invalidate();
      delete this.stylecache.tf;
      return newValue;
   }
   function setEnabled(enabled)
   {
      this.invalidate();
   }
   function getFocus()
   {
      var selFocus = Selection.getFocus();
      return selFocus !== null ? eval(selFocus) : null;
   }
   function setFocus()
   {
      Selection.setFocus(this);
   }
   function getFocusManager()
   {
      var _loc2_ = this;
      while(_loc2_ != undefined)
      {
         if(_loc2_.focusManager != undefined)
         {
            return _loc2_.focusManager;
         }
         _loc2_ = _loc2_._parent;
      }
      return undefined;
   }
   function onKillFocus(newFocus)
   {
      this.removeEventListener("keyDown",this);
      this.removeEventListener("keyUp",this);
      this.dispatchEvent({type:"focusOut"});
      this.drawFocus(false);
   }
   function onSetFocus(oldFocus)
   {
      this.addEventListener("keyDown",this);
      this.addEventListener("keyUp",this);
      this.dispatchEvent({type:"focusIn"});
      if(this.getFocusManager().bDrawFocus != false)
      {
         this.drawFocus(true);
      }
   }
   function findFocusInChildren(o)
   {
      if(o.focusTextField != undefined)
      {
         return o.focusTextField;
      }
      if(o.tabEnabled == true)
      {
         return o;
      }
      return undefined;
   }
   function findFocusFromObject(o)
   {
      if(o.tabEnabled != true)
      {
         if(o._parent == undefined)
         {
            return undefined;
         }
         if(o._parent.tabEnabled == true)
         {
            o = o._parent;
         }
         else if(o._parent.tabChildren)
         {
            o = this.findFocusInChildren(o._parent);
         }
         else
         {
            o = this.findFocusFromObject(o._parent);
         }
      }
      return o;
   }
   function pressFocus()
   {
      var _loc3_ = this.findFocusFromObject(this);
      var _loc2_ = this.getFocus();
      if(_loc3_ != _loc2_)
      {
         _loc2_.drawFocus(false);
         if(this.getFocusManager().bDrawFocus != false)
         {
            _loc3_.drawFocus(true);
         }
      }
   }
   function releaseFocus()
   {
      var _loc2_ = this.findFocusFromObject(this);
      if(_loc2_ != this.getFocus())
      {
         _loc2_.setFocus();
      }
   }
   function isParent(o)
   {
      while(o != undefined)
      {
         if(o == this)
         {
            return true;
         }
         o = o._parent;
      }
      return false;
   }
   function size()
   {
   }
   function init()
   {
      super.init();
      this._xscale = 100;
      this._yscale = 100;
      this._focusrect = _global.useFocusRect == false;
      this.watch("enabled",this.enabledChanged);
      if(this.enabled == false)
      {
         this.setEnabled(false);
      }
   }
   function dispatchValueChangedEvent(value)
   {
      this.dispatchEvent({type:"valueChanged",value:value});
   }
}
