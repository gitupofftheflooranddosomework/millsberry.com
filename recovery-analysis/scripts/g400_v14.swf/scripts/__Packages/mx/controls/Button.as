class mx.controls.Button extends mx.controls.SimpleButton
{
   var __height;
   var __width;
   var _iconLinkageName;
   var createEmptyObject;
   var createLabel;
   var enabled;
   var getState;
   var hitArea_mc;
   var iconName;
   var idNames;
   var initIcon;
   var initializing;
   var invalidate;
   var labelPath;
   var phase;
   var refresh;
   var removeIcons;
   var setState;
   static var symbolName = "Button";
   static var symbolOwner = mx.controls.Button;
   var className = "Button";
   static var version = "2.0.2.126";
   var btnOffset = 0;
   var _color = "buttonColor";
   var __label = "default value";
   var __labelPlacement = "right";
   var falseUpSkin = "ButtonSkin";
   var falseDownSkin = "ButtonSkin";
   var falseOverSkin = "ButtonSkin";
   var falseDisabledSkin = "ButtonSkin";
   var trueUpSkin = "ButtonSkin";
   var trueDownSkin = "ButtonSkin";
   var trueOverSkin = "ButtonSkin";
   var trueDisabledSkin = "ButtonSkin";
   var falseUpIcon = "";
   var falseDownIcon = "";
   var falseOverIcon = "";
   var falseDisabledIcon = "";
   var trueUpIcon = "";
   var trueDownIcon = "";
   var trueOverIcon = "";
   var trueDisabledIcon = "";
   var clipParameters = {labelPlacement:1,icon:1,toggle:1,selected:1,label:1};
   static var mergedClipParameters = mx.core.UIObject.mergeClipParameters(mx.controls.Button.prototype.clipParameters,mx.controls.SimpleButton.prototype.clipParameters);
   var centerContent = true;
   var borderW = 1;
   function Button()
   {
      super();
   }
   function init(Void)
   {
      super.init();
   }
   function draw()
   {
      if(this.initializing)
      {
         this.labelPath.visible = true;
      }
      super.draw();
      if(this.initIcon != undefined)
      {
         this._setIcon(this.initIcon);
      }
      delete this.initIcon;
   }
   function onRelease(Void)
   {
      super.onRelease();
   }
   function createChildren(Void)
   {
      super.createChildren();
   }
   function setSkin(tag, linkageName, initobj)
   {
      return super.setSkin(tag,linkageName,initobj);
   }
   function viewSkin(varName)
   {
      var _loc3_ = !this.getState() ? "false" : "true";
      _loc3_ += !this.enabled ? "disabled" : this.phase;
      super.viewSkin(varName,{styleName:this,borderStyle:_loc3_});
   }
   function invalidateStyle(c)
   {
      this.labelPath.invalidateStyle(c);
      super.invalidateStyle(c);
   }
   function setColor(c)
   {
      var _loc2_ = 0;
      while(_loc2_ < 8)
      {
         this[this.idNames[_loc2_]].redraw(true);
         _loc2_ = _loc2_ + 1;
      }
   }
   function setEnabled(enable)
   {
      this.labelPath.enabled = enable;
      super.setEnabled(enable);
   }
   function calcSize(tag, ref)
   {
      if(this.__width == undefined || this.__height == undefined)
      {
         return undefined;
      }
      if(tag < 7)
      {
         ref.setSize(this.__width,this.__height,true);
      }
   }
   function size(Void)
   {
      this.setState(this.getState());
      this.setHitArea(this.__width,this.__height);
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < 8)
      {
         _loc4_ = this.idNames[_loc3_];
         if(typeof this[_loc4_] == "movieclip")
         {
            this[_loc4_].setSize(this.__width,this.__height,true);
         }
         _loc3_ = _loc3_ + 1;
      }
      super.size();
   }
   function set labelPlacement(val)
   {
      this.__labelPlacement = val;
      this.invalidate();
   }
   function get labelPlacement()
   {
      return this.__labelPlacement;
   }
   function getLabelPlacement(Void)
   {
      return this.__labelPlacement;
   }
   function setLabelPlacement(val)
   {
      this.__labelPlacement = val;
      this.invalidate();
   }
   function getBtnOffset(Void)
   {
      var _loc2_;
      if(this.getState())
      {
         _loc2_ = this.btnOffset;
      }
      else if(this.phase == "down")
      {
         _loc2_ = this.btnOffset;
      }
      else
      {
         _loc2_ = 0;
      }
      return _loc2_;
   }
   function setView(offset)
   {
      var _loc16_ = !offset ? 0 : this.btnOffset;
      var _loc12_ = this.getLabelPlacement();
      var _loc7_ = 0;
      var _loc6_ = 0;
      var _loc9_ = 0;
      var _loc8_ = 0;
      var _loc5_ = 0;
      var _loc4_ = 0;
      var _loc3_ = this.labelPath;
      var _loc2_ = this.iconName;
      var _loc15_ = _loc3_.textWidth;
      var _loc14_ = _loc3_.textHeight;
      var _loc10_ = this.__width - this.borderW - this.borderW;
      var _loc11_ = this.__height - this.borderW - this.borderW;
      if(_loc2_ != undefined)
      {
         _loc7_ = _loc2_._width;
         _loc6_ = _loc2_._height;
      }
      if(_loc12_ == "left" || _loc12_ == "right")
      {
         if(_loc3_ != undefined)
         {
            _loc3_._width = _loc9_ = Math.min(_loc10_ - _loc7_,_loc15_ + 5);
            _loc3_._height = _loc8_ = Math.min(_loc11_,_loc14_ + 5);
         }
         if(_loc12_ == "right")
         {
            _loc5_ = _loc7_;
            if(this.centerContent)
            {
               _loc5_ += (_loc10_ - _loc9_ - _loc7_) / 2;
            }
            _loc2_._x = _loc5_ - _loc7_;
         }
         else
         {
            _loc5_ = _loc10_ - _loc9_ - _loc7_;
            if(this.centerContent)
            {
               _loc5_ /= 2;
            }
            _loc2_._x = _loc5_ + _loc9_;
         }
         _loc2_._y = _loc4_ = 0;
         if(this.centerContent)
         {
            _loc2_._y = (_loc11_ - _loc6_) / 2;
            _loc4_ = (_loc11_ - _loc8_) / 2;
         }
         if(!this.centerContent)
         {
            _loc2_._y += Math.max(0,(_loc8_ - _loc6_) / 2);
         }
      }
      else
      {
         if(_loc3_ != undefined)
         {
            _loc3_._width = _loc9_ = Math.min(_loc10_,_loc15_ + 5);
            _loc3_._height = _loc8_ = Math.min(_loc11_ - _loc6_,_loc14_ + 5);
         }
         _loc5_ = (_loc10_ - _loc9_) / 2;
         _loc2_._x = (_loc10_ - _loc7_) / 2;
         if(_loc12_ == "top")
         {
            _loc4_ = _loc11_ - _loc8_ - _loc6_;
            if(this.centerContent)
            {
               _loc4_ /= 2;
            }
            _loc2_._y = _loc4_ + _loc8_;
         }
         else
         {
            _loc4_ = _loc6_;
            if(this.centerContent)
            {
               _loc4_ += (_loc11_ - _loc8_ - _loc6_) / 2;
            }
            _loc2_._y = _loc4_ - _loc6_;
         }
      }
      var _loc13_ = this.borderW + _loc16_;
      _loc3_._x = _loc5_ + _loc13_;
      _loc3_._y = _loc4_ + _loc13_;
      _loc2_._x += _loc13_;
      _loc2_._y += _loc13_;
   }
   function set label(lbl)
   {
      this.setLabel(lbl);
   }
   function setLabel(label)
   {
      if(label == "")
      {
         this.labelPath.removeTextField();
         this.refresh();
         return undefined;
      }
      var _loc2_;
      if(this.labelPath == undefined)
      {
         _loc2_ = this.createLabel("labelPath",200,label);
         _loc2_._width = _loc2_.textWidth + 5;
         _loc2_._height = _loc2_.textHeight + 5;
         if(this.initializing)
         {
            _loc2_.visible = false;
         }
      }
      else
      {
         delete this.labelPath.__text;
         this.labelPath.text = label;
         this.refresh();
      }
   }
   function getLabel(Void)
   {
      return this.labelPath.__text == undefined ? this.labelPath.text : this.labelPath.__text;
   }
   function get label()
   {
      return this.getLabel();
   }
   function _getIcon(Void)
   {
      return this._iconLinkageName;
   }
   function get icon()
   {
      if(this.initializing)
      {
         return this.initIcon;
      }
      return this._iconLinkageName;
   }
   function _setIcon(linkage)
   {
      if(this.initializing)
      {
         if(linkage == "")
         {
            return undefined;
         }
         this.initIcon = linkage;
      }
      else
      {
         if(linkage == "")
         {
            this.removeIcons();
            return undefined;
         }
         super.changeIcon(0,linkage);
         super.changeIcon(1,linkage);
         super.changeIcon(3,linkage);
         super.changeIcon(4,linkage);
         super.changeIcon(5,linkage);
         this._iconLinkageName = linkage;
         this.refresh();
      }
   }
   function set icon(linkage)
   {
      this._setIcon(linkage);
   }
   function setHitArea(w, h)
   {
      if(this.hitArea_mc == undefined)
      {
         this.createEmptyObject("hitArea_mc",100);
      }
      var _loc2_ = this.hitArea_mc;
      _loc2_.clear();
      _loc2_.beginFill(16711680);
      _loc2_.drawRect(0,0,w,h);
      _loc2_.endFill();
      _loc2_.setVisible(false);
   }
}
