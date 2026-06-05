class mx.controls.SimpleButton extends mx.core.UIComponent
{
   var __emphaticStyleName;
   var __height;
   var __width;
   var _height;
   var _width;
   var autoRepeat;
   var boundingBox_mc;
   var createLabel;
   var destroyObject;
   var dispatchEvent;
   var enabled;
   var getStyle;
   var iconName;
   var interval;
   var invalidate;
   var invalidateStyle;
   var linkLength;
   var preset;
   var skinName;
   var styleName;
   var useHandCursor;
   static var emphasizedStyleDeclaration;
   static var symbolName = "SimpleButton";
   static var symbolOwner = mx.controls.SimpleButton;
   static var version = "2.0.2.126";
   var className = "SimpleButton";
   var style3dInset = 4;
   var btnOffset = 1;
   var __toggle = false;
   var __state = false;
   var __emphasized = false;
   var __emphatic = false;
   static var falseUp = 0;
   static var falseDown = 1;
   static var falseOver = 2;
   static var falseDisabled = 3;
   static var trueUp = 4;
   static var trueDown = 5;
   static var trueOver = 6;
   static var trueDisabled = 7;
   var falseUpSkin = "SimpleButtonUp";
   var falseDownSkin = "SimpleButtonIn";
   var falseOverSkin = "";
   var falseDisabledSkin = "SimpleButtonUp";
   var trueUpSkin = "SimpleButtonIn";
   var trueDownSkin = "";
   var trueOverSkin = "";
   var trueDisabledSkin = "SimpleButtonIn";
   var falseUpIcon = "";
   var falseDownIcon = "";
   var falseOverIcon = "";
   var falseDisabledIcon = "";
   var trueUpIcon = "";
   var trueDownIcon = "";
   var trueOverIcon = "";
   var trueDisabledIcon = "";
   var phase = "up";
   var fui = "falseUpIcon";
   var fus = "falseUpSkin";
   var fdi = "falseDownIcon";
   var fds = "falseDownSkin";
   var frs = "falseOverSkin";
   var fri = "falseOverIcon";
   var dfi = "falseDisabledIcon";
   var dfs = "falseDisabledSkin";
   var tui = "trueUpIcon";
   var tus = "trueUpSkin";
   var tdi = "trueDownIcon";
   var tds = "trueDownSkin";
   var trs = "trueOverSkin";
   var tri = "trueOverIcon";
   var dts = "trueDisabledSkin";
   var dti = "trueDisabledIcon";
   var rolloverSkin = mx.controls.SimpleButton.prototype.frs;
   var rolloverIcon = mx.controls.SimpleButton.prototype.fri;
   var upSkin = mx.controls.SimpleButton.prototype.fus;
   var downSkin = mx.controls.SimpleButton.prototype.fds;
   var disabledSkin = mx.controls.SimpleButton.prototype.dfs;
   var upIcon = mx.controls.SimpleButton.prototype.fui;
   var downIcon = mx.controls.SimpleButton.prototype.fdi;
   var disabledIcon = mx.controls.SimpleButton.prototype.dfi;
   var initializing = true;
   var idNames = ["fus","fds","frs","dfs","tus","tds","trs","dts","fui","fdi","fri","dfi","tui","tdi","tri","dti"];
   var stateNames = ["falseUp","falseDown","falseOver","falseDisabled","trueUp","trueDown","trueOver","trueDisabled"];
   var refNames = ["upSkin","downSkin","rolloverSkin","disabledSkin"];
   var tagMap = {falseUpSkin:0,falseDownSkin:1,falseOverSkin:2,falseDisabledSkin:3,trueUpSkin:4,trueDownSkin:5,trueOverSkin:6,trueDisabledSkin:7,falseUpIcon:0,falseDownIcon:1,falseOverIcon:2,falseDisabledIcon:3,trueUpIcon:4,trueDownIcon:5,trueOverIcon:6,trueDisabledIcon:7};
   function SimpleButton()
   {
      super();
   }
   function init(Void)
   {
      super.init();
      if(this.preset == undefined)
      {
         this.boundingBox_mc._visible = false;
         this.boundingBox_mc._width = this.boundingBox_mc._height = 0;
      }
      this.useHandCursor = false;
   }
   function createChildren(Void)
   {
      var _loc2_;
      if(this.preset != undefined)
      {
         _loc2_ = this[this.idNames[this.preset]];
         this[this.refNames[this.preset]] = _loc2_;
         this.skinName = _loc2_;
         if(this.falseOverSkin.length == 0)
         {
            this.rolloverSkin = this.fus;
         }
         if(this.falseOverIcon.length == 0)
         {
            this.rolloverIcon = this.fui;
         }
         this.initializing = false;
      }
      else if(this.__state == true)
      {
         this.setStateVar(true);
      }
      else
      {
         if(this.falseOverSkin.length == 0)
         {
            this.rolloverSkin = this.fus;
         }
         if(this.falseOverIcon.length == 0)
         {
            this.rolloverIcon = this.fui;
         }
      }
   }
   function setIcon(tag, linkageName)
   {
      return this.setSkin(tag + 8,linkageName);
   }
   function changeIcon(tag, linkageName)
   {
      this.linkLength = linkageName.length;
      var _loc2_ = this.stateNames[tag] + "Icon";
      this[_loc2_] = linkageName;
      this[this.idNames[tag + 8]] = _loc2_;
      this.setStateVar(this.getState());
   }
   function changeSkin(tag, linkageName)
   {
      var _loc2_ = this.stateNames[tag] + "Skin";
      this[_loc2_] = linkageName;
      this[this.idNames[tag]] = _loc2_;
      this.setStateVar(this.getState());
   }
   function viewIcon(varName)
   {
      var _loc4_ = varName + "Icon";
      var _loc3_ = this[_loc4_];
      var _loc5_;
      if(typeof _loc3_ == "string")
      {
         _loc5_ = _loc3_;
         if(this.__emphasized)
         {
            if(this[_loc3_ + "Emphasized"].length > 0)
            {
               _loc3_ += "Emphasized";
            }
         }
         if(this[_loc3_].length == 0)
         {
            return undefined;
         }
         _loc3_ = this.setIcon(this.tagMap[_loc5_],this[_loc3_]);
         if(_loc3_ == undefined && _global.isLivePreview)
         {
            _loc3_ = this.setIcon(0,"ButtonIcon");
         }
         this[_loc4_] = _loc3_;
      }
      this.iconName._visible = false;
      this.iconName = _loc3_;
      this.iconName._visible = true;
   }
   function removeIcons()
   {
      var _loc3_ = 0;
      var _loc2_;
      while(_loc3_ < 2)
      {
         _loc2_ = 8;
         while(_loc2_ < 16)
         {
            this.destroyObject(this.idNames[_loc2_]);
            this[this.stateNames[_loc2_ - 8] + "Icon"] = "";
            _loc2_ = _loc2_ + 1;
         }
         _loc3_ = _loc3_ + 1;
      }
      this.refresh();
   }
   function setSkin(tag, linkageName, initobj)
   {
      var _loc3_ = super.setSkin(tag,linkageName,initobj == undefined ? {styleName:this} : initobj);
      this.calcSize(tag,_loc3_);
      return _loc3_;
   }
   function calcSize(Void)
   {
      this.__width = this._width;
      this.__height = this._height;
   }
   function viewSkin(varName, initObj)
   {
      var _loc3_ = varName + "Skin";
      var _loc2_ = this[_loc3_];
      var _loc4_;
      if(typeof _loc2_ == "string")
      {
         _loc4_ = _loc2_;
         if(this.__emphasized)
         {
            if(this[_loc2_ + "Emphasized"].length > 0)
            {
               _loc2_ += "Emphasized";
            }
         }
         if(this[_loc2_].length == 0)
         {
            return undefined;
         }
         _loc2_ = this.setSkin(this.tagMap[_loc4_],this[_loc2_],initObj == undefined ? {styleName:this} : initObj);
         this[_loc3_] = _loc2_;
      }
      this.skinName._visible = false;
      this.skinName = _loc2_;
      this.skinName._visible = true;
   }
   function showEmphasized(e)
   {
      if(e && !this.__emphatic)
      {
         if(mx.controls.SimpleButton.emphasizedStyleDeclaration != undefined)
         {
            this.__emphaticStyleName = this.styleName;
            this.styleName = mx.controls.SimpleButton.emphasizedStyleDeclaration;
         }
         this.__emphatic = true;
      }
      else
      {
         if(this.__emphatic)
         {
            this.styleName = this.__emphaticStyleName;
         }
         this.__emphatic = false;
      }
   }
   function refresh(Void)
   {
      var _loc2_ = this.getState();
      if(this.enabled == false)
      {
         this.viewIcon("disabled");
         this.viewSkin("disabled");
      }
      else
      {
         this.viewSkin(this.phase);
         this.viewIcon(this.phase);
      }
      this.setView(this.phase == "down");
      this.iconName.enabled = this.enabled;
   }
   function setView(offset)
   {
      if(this.iconName == undefined)
      {
         return undefined;
      }
      var _loc2_ = !offset ? 0 : this.btnOffset;
      this.iconName._x = (this.__width - this.iconName._width) / 2 + _loc2_;
      this.iconName._y = (this.__height - this.iconName._height) / 2 + _loc2_;
   }
   function setStateVar(state)
   {
      if(state)
      {
         if(this.trueOverSkin.length == 0)
         {
            this.rolloverSkin = this.tus;
         }
         else
         {
            this.rolloverSkin = this.trs;
         }
         if(this.trueOverIcon.length == 0)
         {
            this.rolloverIcon = this.tui;
         }
         else
         {
            this.rolloverIcon = this.tri;
         }
         this.upSkin = this.tus;
         this.downSkin = this.tds;
         this.disabledSkin = this.dts;
         this.upIcon = this.tui;
         this.downIcon = this.tdi;
         this.disabledIcon = this.dti;
      }
      else
      {
         if(this.falseOverSkin.length == 0)
         {
            this.rolloverSkin = this.fus;
         }
         else
         {
            this.rolloverSkin = this.frs;
         }
         if(this.falseOverIcon.length == 0)
         {
            this.rolloverIcon = this.fui;
         }
         else
         {
            this.rolloverIcon = this.fri;
         }
         this.upSkin = this.fus;
         this.downSkin = this.fds;
         this.disabledSkin = this.dfs;
         this.upIcon = this.fui;
         this.downIcon = this.fdi;
         this.disabledIcon = this.dfi;
      }
      this.__state = state;
   }
   function setState(state)
   {
      if(state != this.__state)
      {
         this.setStateVar(state);
         this.invalidate();
      }
   }
   function size(Void)
   {
      this.refresh();
   }
   function draw(Void)
   {
      if(this.initializing)
      {
         this.initializing = false;
         this.skinName.visible = true;
         this.iconName.visible = true;
      }
      this.size();
   }
   function getState(Void)
   {
      return this.__state;
   }
   function setToggle(val)
   {
      this.__toggle = val;
      if(this.__toggle == false)
      {
         this.setState(false);
      }
   }
   function getToggle(Void)
   {
      return this.__toggle;
   }
   function set toggle(val)
   {
      this.setToggle(val);
   }
   function get toggle()
   {
      return this.getToggle();
   }
   function set value(val)
   {
      this.setSelected(val);
   }
   function get value()
   {
      return this.getSelected();
   }
   function set selected(val)
   {
      this.setSelected(val);
   }
   function get selected()
   {
      return this.getSelected();
   }
   function setSelected(val)
   {
      if(this.__toggle)
      {
         this.setState(val);
      }
      else
      {
         this.setState(!this.initializing ? this.__state : val);
      }
   }
   function getSelected()
   {
      return this.__state;
   }
   function setEnabled(val)
   {
      if(this.enabled != val)
      {
         super.setEnabled(val);
         this.invalidate();
      }
   }
   function onPress(Void)
   {
      this.pressFocus();
      this.phase = "down";
      this.refresh();
      this.dispatchEvent({type:"buttonDown"});
      if(this.autoRepeat)
      {
         this.interval = setInterval(this,"onPressDelay",this.getStyle("repeatDelay"));
      }
   }
   function onPressDelay(Void)
   {
      this.dispatchEvent({type:"buttonDown"});
      if(this.autoRepeat)
      {
         clearInterval(this.interval);
         this.interval = setInterval(this,"onPressRepeat",this.getStyle("repeatInterval"));
      }
   }
   function onPressRepeat(Void)
   {
      this.dispatchEvent({type:"buttonDown"});
      updateAfterEvent();
   }
   function onRelease(Void)
   {
      this.releaseFocus();
      this.phase = "rollover";
      if(this.interval != undefined)
      {
         clearInterval(this.interval);
         delete this.interval;
      }
      if(this.getToggle())
      {
         this.setState(!this.getState());
      }
      else
      {
         this.refresh();
      }
      this.dispatchEvent({type:"click"});
   }
   function onDragOut(Void)
   {
      this.phase = "up";
      this.refresh();
      this.dispatchEvent({type:"buttonDragOut"});
   }
   function onDragOver(Void)
   {
      if(this.phase != "up")
      {
         this.onPress();
         return undefined;
      }
      this.phase = "down";
      this.refresh();
   }
   function onReleaseOutside(Void)
   {
      this.releaseFocus();
      this.phase = "up";
      if(this.interval != undefined)
      {
         clearInterval(this.interval);
         delete this.interval;
      }
   }
   function onRollOver(Void)
   {
      this.phase = "rollover";
      this.refresh();
   }
   function onRollOut(Void)
   {
      this.phase = "up";
      this.refresh();
   }
   function getLabel(Void)
   {
      return this.fui.text;
   }
   function setLabel(val)
   {
      if(typeof this.fui == "string")
      {
         this.createLabel("fui",8,val);
         this.fui.styleName = this;
      }
      else
      {
         this.fui.text = val;
      }
      var _loc4_ = this.fui._getTextFormat();
      var _loc2_ = _loc4_.getTextExtent2(val);
      this.fui._width = _loc2_.width + 5;
      this.fui._height = _loc2_.height + 5;
      this.iconName = this.fui;
      this.setView(this.__state);
   }
   function get emphasized()
   {
      return this.__emphasized;
   }
   function set emphasized(val)
   {
      this.__emphasized = val;
      var _loc2_ = 0;
      while(_loc2_ < 8)
      {
         this[this.idNames[_loc2_]] = this.stateNames[_loc2_] + "Skin";
         if(typeof this[this.idNames[_loc2_ + 8]] == "movieclip")
         {
            this[this.idNames[_loc2_ + 8]] = this.stateNames[_loc2_] + "Icon";
         }
         _loc2_ = _loc2_ + 1;
      }
      this.showEmphasized(this.__emphasized);
      this.setStateVar(this.__state);
      this.invalidateStyle();
   }
   function keyDown(e)
   {
      if(e.code == 32)
      {
         this.onPress();
      }
   }
   function keyUp(e)
   {
      if(e.code == 32)
      {
         this.onRelease();
      }
   }
   function onKillFocus(newFocus)
   {
      super.onKillFocus();
      if(this.phase != "up")
      {
         this.phase = "up";
         this.refresh();
      }
   }
}
