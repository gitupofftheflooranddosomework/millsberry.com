class mx.managers.FocusManager extends mx.core.UIComponent
{
   var __defaultPushButton;
   var _alpha;
   var _firstNode;
   var _firstObj;
   var _foundList;
   var _height;
   var _lastNode;
   var _lastObj;
   var _lastTarget;
   var _lastx;
   var _needPrev;
   var _nextIsNext;
   var _nextNode;
   var _nextObj;
   var _parent;
   var _prevNode;
   var _prevObj;
   var _searchKey;
   var _visible;
   var _width;
   var _x;
   var _y;
   var cancelAllDoLaters;
   var defPushButton;
   var doLater;
   var form;
   var lastFocus;
   var lastMouse;
   var lastSelFocus;
   var lastTabFocus;
   var move;
   var tabCapture;
   var watch;
   static var symbolName = "FocusManager";
   static var symbolOwner = mx.managers.FocusManager;
   static var version = "2.0.2.126";
   var className = "FocusManager";
   var bNeedFocus = false;
   var bDrawFocus = false;
   var defaultPushButtonEnabled = true;
   var activated = true;
   static var initialized = false;
   static var UIObjectExtensionsDependency = mx.core.ext.UIObjectExtensions;
   function FocusManager()
   {
      super();
   }
   function get defaultPushButton()
   {
      return this.__defaultPushButton;
   }
   function set defaultPushButton(x)
   {
      if(x != this.__defaultPushButton)
      {
         this.__defaultPushButton.emphasized = false;
         this.__defaultPushButton = x;
         this.defPushButton = x;
         x.emphasized = true;
      }
   }
   function getMaxTabIndex(o)
   {
      var _loc3_ = 0;
      var _loc6_;
      var _loc2_;
      var _loc4_;
      for(_loc6_ in o)
      {
         _loc2_ = o[_loc6_];
         if(_loc2_._parent == o)
         {
            if(_loc2_.tabIndex != undefined)
            {
               if(_loc2_.tabIndex > _loc3_)
               {
                  _loc3_ = _loc2_.tabIndex;
               }
            }
            if(_loc2_.tabChildren == true)
            {
               _loc4_ = this.getMaxTabIndex(_loc2_);
               if(_loc4_ > _loc3_)
               {
                  _loc3_ = _loc4_;
               }
            }
         }
      }
      return _loc3_;
   }
   function getNextTabIndex(Void)
   {
      return this.getMaxTabIndex(this.form) + 1;
   }
   function get nextTabIndex()
   {
      return this.getNextTabIndex();
   }
   function relocate(Void)
   {
      var _loc2_ = mx.managers.SystemManager.screen;
      this.move(_loc2_.x - 1,_loc2_.y - 1);
   }
   function init(Void)
   {
      super.init();
      this.tabEnabled = false;
      this._width = this._height = 1;
      this._x = this._y = -1;
      this._alpha = 0;
      this._parent.focusManager = this;
      this._parent.tabChildren = true;
      this._parent.tabEnabled = false;
      this.form = this._parent;
      this._parent.addEventListener("hide",this);
      this._parent.addEventListener("reveal",this);
      mx.managers.SystemManager.init();
      mx.managers.SystemManager.addFocusManager(this.form);
      this.tabCapture.tabIndex = 0;
      this.watch("enabled",this.enabledChanged);
      Selection.addListener(this);
      this.lastMouse = new Object();
      _global.ASSetPropFlags(this._parent,"focusManager",1);
      _global.ASSetPropFlags(this._parent,"tabChildren",1);
      _global.ASSetPropFlags(this._parent,"tabEnabled",1);
   }
   function enabledChanged(id, oldValue, newValue)
   {
      this._visible = newValue;
      return newValue;
   }
   function activate(Void)
   {
      Key.addListener(this);
      this.activated = this._visible = true;
      if(this.lastFocus != undefined)
      {
         this.bNeedFocus = true;
         if(!mx.managers.SystemManager.isMouseDown)
         {
            this.doLater(this,"restoreFocus");
         }
      }
   }
   function deactivate(Void)
   {
      Key.removeListener(this);
      this.activated = this._visible = false;
      var _loc2_ = this.getSelectionFocus();
      var _loc3_ = this.getActualFocus(_loc2_);
      if(this.isOurFocus(_loc3_))
      {
         this.lastSelFocus = _loc2_;
         this.lastFocus = _loc3_;
      }
      this.cancelAllDoLaters();
   }
   function isOurFocus(o)
   {
      if(o.focusManager == this)
      {
         return true;
      }
      while(o != undefined)
      {
         if(o.focusManager != undefined)
         {
            return false;
         }
         if(o._parent == this._parent)
         {
            return true;
         }
         o = o._parent;
      }
      return false;
   }
   function onSetFocus(o, n)
   {
      var _loc2_;
      if(n == null)
      {
         if(this.activated)
         {
            this.bNeedFocus = true;
         }
      }
      else
      {
         _loc2_ = this.getFocus();
         if(this.isOurFocus(_loc2_))
         {
            this.bNeedFocus = false;
            this.lastFocus = _loc2_;
            this.lastSelFocus = n;
         }
      }
   }
   function restoreFocus(Void)
   {
      var _loc2_ = this.lastSelFocus.hscroll;
      var _loc5_;
      var _loc4_;
      if(_loc2_ != undefined)
      {
         _loc5_ = this.lastSelFocus.scroll;
         _loc4_ = this.lastSelFocus.background;
      }
      this.lastFocus.setFocus();
      var _loc3_ = Selection;
      Selection.setSelection(_loc3_.lastBeginIndex,_loc3_.lastEndIndex);
      if(_loc2_ != undefined)
      {
         this.lastSelFocus.scroll = _loc5_;
         this.lastSelFocus.hscroll = _loc2_;
         this.lastSelFocus.background = _loc4_;
      }
   }
   function onUnload(Void)
   {
      mx.managers.SystemManager.removeFocusManager(this.form);
   }
   function setFocus(o)
   {
      if(o == null)
      {
         Selection.setFocus(null);
      }
      else if(o.setFocus == undefined)
      {
         Selection.setFocus(o);
      }
      else
      {
         o.setFocus();
      }
   }
   function getActualFocus(o)
   {
      var _loc1_ = o._parent;
      while(_loc1_ != undefined)
      {
         if(_loc1_.focusTextField != undefined)
         {
            while(_loc1_.focusTextField != undefined)
            {
               o = _loc1_;
               _loc1_ = _loc1_._parent;
               if(_loc1_ == undefined)
               {
                  return undefined;
               }
               if(_loc1_.focusTextField == undefined)
               {
                  return o;
               }
            }
         }
         if(_loc1_.tabEnabled != true)
         {
            return o;
         }
         o = _loc1_;
         _loc1_ = o._parent;
      }
      return undefined;
   }
   function getSelectionFocus()
   {
      var m = Selection.getFocus();
      var o = eval(m);
      return o;
   }
   function getFocus(Void)
   {
      var _loc2_ = this.getSelectionFocus();
      return this.getActualFocus(_loc2_);
   }
   function walkTree(p, index, groupName, dir, lookup, firstChild)
   {
      var _loc5_ = true;
      var _loc11_;
      var _loc2_;
      var _loc3_;
      var _loc7_;
      for(_loc11_ in p)
      {
         _loc2_ = p[_loc11_];
         if(_loc2_._parent == p && _loc2_.enabled != false && _loc2_._visible != false && (_loc2_.tabEnabled == true || _loc2_.tabEnabled != false && (_loc2_.onPress != undefined || _loc2_.onRelease != undefined || _loc2_.onReleaseOutside != undefined || _loc2_.onDragOut != undefined || _loc2_.onDragOver != undefined || _loc2_.onRollOver != undefined || _loc2_.onRollOut != undefined || _loc2_ instanceof TextField)))
         {
            if(_loc2_._searchKey == this._searchKey)
            {
               continue;
            }
            _loc2_._searchKey = this._searchKey;
            if(_loc2_ != this._lastTarget)
            {
               if((_loc2_.groupName != undefined || groupName != undefined) && _loc2_.groupName == groupName)
               {
                  continue;
               }
               if(_loc2_ instanceof TextField && _loc2_.selectable == false)
               {
                  continue;
               }
               if(_loc5_ || _loc2_.groupName != undefined && _loc2_.groupName == this._firstNode.groupName && _loc2_.selected == true)
               {
                  if(firstChild)
                  {
                     this._firstNode = _loc2_;
                     firstChild = false;
                  }
               }
               if(this._nextIsNext == true)
               {
                  if(_loc2_.groupName != undefined && _loc2_.groupName == this._nextNode.groupName && _loc2_.selected == true || this._nextNode == undefined && (_loc2_.groupName == undefined || _loc2_.groupName != undefined && _loc2_.groupName != groupName))
                  {
                     this._nextNode = _loc2_;
                  }
               }
               if(_loc2_.groupName == undefined || groupName != _loc2_.groupName)
               {
                  if(!(this._lastx.groupName != undefined && _loc2_.groupName == this._lastx.groupName && this._lastx.selected == true))
                  {
                     this._lastx = _loc2_;
                  }
               }
            }
            else
            {
               this._prevNode = this._lastx;
               this._needPrev = false;
               this._nextIsNext = true;
            }
            if(_loc2_.tabIndex != undefined)
            {
               if(_loc2_.tabIndex == index)
               {
                  if(this._foundList[_loc2_._name] == undefined)
                  {
                     if(this._needPrev)
                     {
                        this._prevObj = _loc2_;
                        this._needPrev = false;
                     }
                     this._nextObj = _loc2_;
                  }
               }
               if(dir && _loc2_.tabIndex > index)
               {
                  if(this._nextObj == undefined || this._nextObj.tabIndex > _loc2_.tabIndex && (_loc2_.groupName == undefined || this._nextObj.groupName == undefined || _loc2_.groupName != this._nextObj.groupName) || this._nextObj.groupName != undefined && this._nextObj.groupName == _loc2_.groupName && this._nextObj.selected != true && (_loc2_.selected == true || this._nextObj.tabIndex > _loc2_.tabIndex))
                  {
                     this._nextObj = _loc2_;
                  }
               }
               else if(!dir && _loc2_.tabIndex < index)
               {
                  if(this._prevObj == undefined || this._prevObj.tabIndex < _loc2_.tabIndex && (_loc2_.groupName == undefined || this._prevObj.groupName == undefined || _loc2_.groupName != this._prevObj.groupName) || this._prevObj.groupName != undefined && this._prevObj.groupName == _loc2_.groupName && this._prevObj.selected != true && (_loc2_.selected == true || this._prevObj.tabIndex < _loc2_.tabIndex))
                  {
                     this._prevObj = _loc2_;
                  }
               }
               if(this._firstObj == undefined || _loc2_.tabIndex < this._firstObj.tabIndex && (_loc2_.groupName == undefined || this._firstObj.groupName == undefined || _loc2_.groupName != this._firstObj.groupName) || this._firstObj.groupName != undefined && this._firstObj.groupName == _loc2_.groupName && this._firstObj.selected != true && (_loc2_.selected == true || _loc2_.tabIndex < this._firstObj.tabIndex))
               {
                  this._firstObj = _loc2_;
               }
               if(this._lastObj == undefined || _loc2_.tabIndex > this._lastObj.tabIndex && (_loc2_.groupName == undefined || this._lastObj.groupName == undefined || _loc2_.groupName != this._lastObj.groupName) || this._lastObj.groupName != undefined && this._lastObj.groupName == _loc2_.groupName && this._lastObj.selected != true && (_loc2_.selected == true || _loc2_.tabIndex > this._lastObj.tabIndex))
               {
                  this._lastObj = _loc2_;
               }
            }
            if(_loc2_.tabChildren)
            {
               this.getTabCandidateFromChildren(_loc2_,index,groupName,dir,_loc5_ && firstChild);
            }
            _loc5_ = false;
         }
         else if(_loc2_._parent == p && _loc2_.tabChildren == true && _loc2_._visible != false)
         {
            if(_loc2_ == this._lastTarget)
            {
               if(_loc2_._searchKey == this._searchKey)
               {
                  continue;
               }
               _loc2_._searchKey = this._searchKey;
               if(this._prevNode == undefined)
               {
                  _loc3_ = this._lastx;
                  _loc7_ = false;
                  while(_loc3_ != undefined)
                  {
                     if(_loc3_ == _loc2_)
                     {
                        _loc7_ = true;
                        break;
                     }
                     _loc3_ = _loc3_._parent;
                  }
                  if(_loc7_ == false)
                  {
                     this._prevNode = this._lastx;
                  }
               }
               this._needPrev = false;
               if(this._nextNode == undefined)
               {
                  this._nextIsNext = true;
               }
            }
            else if(!(_loc2_.focusManager != undefined && _loc2_.focusManager._parent == _loc2_))
            {
               if(_loc2_._searchKey == this._searchKey)
               {
                  continue;
               }
               _loc2_._searchKey = this._searchKey;
               this.getTabCandidateFromChildren(_loc2_,index,groupName,dir,_loc5_ && firstChild);
            }
            _loc5_ = false;
         }
      }
      this._lastNode = this._lastx;
      if(lookup)
      {
         if(p._parent != undefined)
         {
            if(p != this._parent)
            {
               if(this._prevNode == undefined && dir)
               {
                  this._needPrev = true;
               }
               else if(this._nextNode == undefined && !dir)
               {
                  this._nextIsNext = false;
               }
               this._lastTarget = this._lastTarget._parent;
               this.getTabCandidate(p._parent,index,groupName,dir,true);
            }
         }
      }
   }
   function getTabCandidate(o, index, groupName, dir, firstChild)
   {
      var _loc2_;
      var _loc3_ = true;
      if(o == this._parent)
      {
         _loc2_ = o;
         _loc3_ = false;
      }
      else
      {
         _loc2_ = o._parent;
         if(_loc2_ == undefined)
         {
            _loc2_ = o;
            _loc3_ = false;
         }
      }
      this.walkTree(_loc2_,index,groupName,dir,_loc3_,firstChild);
   }
   function getTabCandidateFromChildren(o, index, groupName, dir, firstChild)
   {
      this.walkTree(o,index,groupName,dir,false,firstChild);
   }
   function getFocusManagerFromObject(o)
   {
      while(o != undefined)
      {
         if(o.focusManager != undefined)
         {
            return o.focusManager;
         }
         o = o._parent;
      }
      return undefined;
   }
   function tabHandler(Void)
   {
      this.bDrawFocus = true;
      var _loc5_ = this.getSelectionFocus();
      var _loc4_ = this.getActualFocus(_loc5_);
      if(_loc4_ != _loc5_)
      {
         _loc5_ = _loc4_;
      }
      if(this.getFocusManagerFromObject(_loc5_) != this)
      {
         _loc5_ == undefined;
      }
      if(_loc5_ == undefined)
      {
         _loc5_ = this.form;
      }
      else if(_loc5_.tabIndex != undefined)
      {
         if(this._foundList != undefined || this._foundList.tabIndex != _loc5_.tabIndex)
         {
            this._foundList = new Object();
            this._foundList.tabIndex = _loc5_.tabIndex;
         }
         this._foundList[_loc5_._name] = _loc5_;
      }
      var _loc3_ = Key.isDown(16) != true;
      this._searchKey = getTimer();
      this._needPrev = true;
      this._nextIsNext = false;
      this._lastx = undefined;
      this._firstNode = undefined;
      this._lastNode = undefined;
      this._nextNode = undefined;
      this._prevNode = undefined;
      this._firstObj = undefined;
      this._lastObj = undefined;
      this._nextObj = undefined;
      this._prevObj = undefined;
      this._lastTarget = _loc5_;
      var _loc6_ = _loc5_;
      this.getTabCandidate(_loc6_,_loc5_.tabIndex != undefined ? _loc5_.tabIndex : 0,_loc5_.groupName,_loc3_,true);
      var _loc2_;
      if(_loc3_)
      {
         if(this._nextObj != undefined)
         {
            _loc2_ = this._nextObj;
         }
         else
         {
            _loc2_ = this._firstObj;
         }
      }
      else if(this._prevObj != undefined)
      {
         _loc2_ = this._prevObj;
      }
      else
      {
         _loc2_ = this._lastObj;
      }
      if(_loc2_.tabIndex != _loc5_.tabIndex)
      {
         this._foundList = new Object();
         this._foundList.tabIndex = _loc2_.tabIndex;
         this._foundList[_loc2_._name] = _loc2_;
      }
      else
      {
         if(this._foundList == undefined)
         {
            this._foundList = new Object();
            this._foundList.tabIndex = _loc2_.tabIndex;
         }
         this._foundList[_loc2_._name] = _loc2_;
      }
      if(_loc2_ == undefined)
      {
         if(_loc3_ == false)
         {
            if(this._nextNode != undefined)
            {
               _loc2_ = this._nextNode;
            }
            else
            {
               _loc2_ = this._firstNode;
            }
         }
         else if(this._prevNode == undefined || _loc5_ == this.form)
         {
            _loc2_ = this._lastNode;
         }
         else
         {
            _loc2_ = this._prevNode;
         }
      }
      if(_loc2_ == undefined)
      {
         return undefined;
      }
      this.lastTabFocus = _loc2_;
      this.setFocus(_loc2_);
      if(_loc2_.emphasized != undefined)
      {
         if(this.defPushButton != undefined)
         {
            _loc5_ = this.defPushButton;
            this.defPushButton = _loc2_;
            _loc5_.emphasized = false;
            _loc2_.emphasized = true;
         }
      }
      else if(this.defPushButton != undefined && this.defPushButton != this.__defaultPushButton)
      {
         _loc5_ = this.defPushButton;
         this.defPushButton = this.__defaultPushButton;
         _loc5_.emphasized = false;
         this.__defaultPushButton.emphasized = true;
      }
   }
   function onKeyDown(Void)
   {
      mx.managers.SystemManager.idleFrames = 0;
      if(this.defaultPushButtonEnabled)
      {
         if(Key.getCode() == 13)
         {
            if(this.defaultPushButton != undefined)
            {
               this.doLater(this,"sendDefaultPushButtonEvent");
            }
         }
      }
   }
   function sendDefaultPushButtonEvent(Void)
   {
      this.defPushButton.dispatchEvent({type:"click"});
   }
   function getMousedComponentFromChildren(x, y, o)
   {
      var _loc2_;
      var _loc3_;
      for(var _loc7_ in o)
      {
         _loc2_ = o[_loc7_];
         if(_loc2_._visible && _loc2_.enabled && _loc2_._parent == o && _loc2_._searchKey != this._searchKey)
         {
            _loc2_._searchKey = this._searchKey;
            if(_loc2_.hitTest(x,y,true))
            {
               if(_loc2_.onPress != undefined || _loc2_.onRelease != undefined)
               {
                  return _loc2_;
               }
               _loc3_ = this.getMousedComponentFromChildren(x,y,_loc2_);
               if(_loc3_ != undefined)
               {
                  return _loc3_;
               }
               return _loc2_;
            }
         }
      }
      return undefined;
   }
   function mouseActivate(Void)
   {
      if(!this.bNeedFocus)
      {
         return undefined;
      }
      this._searchKey = getTimer();
      var _loc2_ = this.getMousedComponentFromChildren(this.lastMouse.x,this.lastMouse.y,this.form);
      if(_loc2_ instanceof mx.core.UIComponent)
      {
         return undefined;
      }
      _loc2_ = this.findFocusFromObject(_loc2_);
      if(_loc2_ == this.lastFocus)
      {
         return undefined;
      }
      if(_loc2_ == undefined)
      {
         this.doLater(this,"restoreFocus");
         return undefined;
      }
      var _loc3_ = _loc2_.hscroll;
      var _loc6_;
      var _loc5_;
      if(_loc3_ != undefined)
      {
         _loc6_ = _loc2_.scroll;
         _loc5_ = _loc2_.background;
      }
      this.setFocus(_loc2_);
      var _loc4_ = Selection;
      Selection.setSelection(_loc4_.lastBeginIndex,_loc4_.lastEndIndex);
      if(_loc3_ != undefined)
      {
         _loc2_.scroll = _loc6_;
         _loc2_.hscroll = _loc3_;
         _loc2_.background = _loc5_;
      }
   }
   function _onMouseDown(Void)
   {
      this.bDrawFocus = false;
      if(this.lastFocus != undefined)
      {
         this.lastFocus.drawFocus(false);
      }
      mx.managers.SystemManager.idleFrames = 0;
      var _loc3_ = Selection;
      _loc3_.lastBeginIndex = Selection.getBeginIndex();
      _loc3_.lastEndIndex = Selection.getEndIndex();
      this.lastMouse.x = _root._xmouse;
      this.lastMouse.y = _root._ymouse;
      _root.localToGlobal(this.lastMouse);
   }
   function onMouseUp(Void)
   {
      if(this._visible)
      {
         this.doLater(this,"mouseActivate");
      }
   }
   function handleEvent(e)
   {
      if(e.type == "reveal")
      {
         mx.managers.SystemManager.activate(this.form);
      }
      else
      {
         mx.managers.SystemManager.deactivate(this.form);
      }
   }
   static function enableFocusManagement()
   {
      if(!mx.managers.FocusManager.initialized)
      {
         mx.managers.FocusManager.initialized = true;
         Object.registerClass("FocusManager",mx.managers.FocusManager);
         if(_root.focusManager == undefined)
         {
            _root.createClassObject(mx.managers.FocusManager,"focusManager",mx.managers.DepthManager.highestDepth--);
         }
      }
   }
}
