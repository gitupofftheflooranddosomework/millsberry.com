class core.lang.TranslatableTextFieldInstance extends TextField
{
   var htmlText_str;
   var instance_str;
   var target;
   var embedFonts_boolean = false;
   var font_str = undefined;
   var useHTMLFontFace_boolean = undefined;
   var thisObjectgivenInvalidValueError_boolean = false;
   static var allObjectsInvalidValueErrorCount_num = 0;
   function TranslatableTextFieldInstance(tTextFieldInstanceOrString, tTarget, aSuppressRefresh_boolean)
   {
      var _loc1_ = this;
      var _loc2_ = aSuppressRefresh_boolean;
      super();
      if(!(tTextFieldInstanceOrString == undefined && tTarget == undefined))
      {
         _loc1_.setInstanceString(tTextFieldInstanceOrString);
         _loc1_.setTarget(tTarget);
         _loc1_.isPositionHinted_boolean = false;
         _loc1_.setUseHTMLFontFace(false,_loc2_);
         _loc1_.init();
         _loc1_.setEmbedFonts(_loc1_.getInstance().embedFonts,_loc2_);
         _loc1_.setFont(_loc1_.getInstance().getTextFormat().font,_loc2_);
      }
   }
   function setTarget(tValue)
   {
      this.target = tValue;
   }
   function getTarget()
   {
      return this.target;
   }
   function setInstanceString(tValue)
   {
      var _loc1_ = tValue;
      _loc1_ = String(_loc1_);
      var _loc2_;
      if(_loc1_.charAt(0) == "_")
      {
         _loc2_ = _loc1_.indexOf(".");
         _loc1_ = _loc1_.substring(_loc2_ + 1);
      }
      this.instance_str = String(_loc1_);
   }
   function getInstanceString()
   {
      return this.instance_str;
   }
   function getInstance()
   {
      return eval(String(String(this.getTarget()) + "." + this.getInstanceString()));
   }
   function setEmbedFonts(tValue, aSuppressRefresh_boolean)
   {
      this.embedFonts_boolean = tValue;
      if(!aSuppressRefresh_boolean)
      {
         this.refresh();
      }
   }
   function getEmbedFonts()
   {
      return this.embedFonts_boolean;
   }
   function setFont(tValue, aSuppressRefresh_boolean)
   {
      this.font_str = tValue;
      if(!aSuppressRefresh_boolean)
      {
         this.refresh();
      }
   }
   function getFont()
   {
      return this.font_str;
   }
   function setUseHTMLFontFace(tValue, aSuppressRefresh_boolean)
   {
      this.useHTMLFontFace_boolean = tValue;
      if(!aSuppressRefresh_boolean)
      {
         this.refresh();
      }
   }
   function getUseHTMLFontFace()
   {
      return this.useHTMLFontFace_boolean;
   }
   function init()
   {
      var _loc1_ = this;
      _loc1_.getInstance().multiline = true;
      _loc1_.getInstance().selectable = false;
      _loc1_.getInstance().editable = false;
      _loc1_.getInstance().wordWrap = true;
      _loc1_.getInstance().border = false;
      _loc1_.getInstance().html = true;
   }
   function setHtmlText(tHtmlText_str, aSuppressRefresh_boolean)
   {
      this.htmlText_str = tHtmlText_str;
      if(!aSuppressRefresh_boolean)
      {
         this.refresh();
      }
   }
   function getHtmlText()
   {
      return this.getInstance().htmlText;
   }
   function refresh()
   {
      var _loc1_ = this;
      var _loc2_;
      if(_loc1_.getInstance() == undefined)
      {
         if(++core.lang.TranslatableTextFieldInstance.allObjectsInvalidValueErrorCount_num > 1)
         {
            if(!_loc1_.thisObjectgivenInvalidValueError_boolean)
            {
               _loc1_.thisObjectgivenInvalidValueError_boolean = true;
               trace("TTF missing.  Use translator().removeTranslatableTextField() on last frame of a TTF\'s existence\'");
            }
         }
      }
      else
      {
         _loc1_.getInstance().embedFonts = _loc1_.getEmbedFonts();
         _loc1_.getInstance().htmlText = _loc1_.htmlText_str;
         if(!_loc1_.isPositionHinted_boolean)
         {
            _loc1_.doPositionHinting();
            _loc1_.isPositionHinted_boolean = true;
         }
         _loc2_ = new TextFormat();
         _loc2_.font = _loc1_.getFont();
         if(_loc1_.useHTMLFontFace_boolean == false)
         {
            _loc1_.getInstance().setTextFormat(_loc2_);
         }
         _loc1_.getInstance().htmlText = _loc1_.htmlText_str;
      }
   }
   function doPositionHinting()
   {
      var _loc1_ = this;
      if(_loc1_.getInstance()._x != Math.round(_loc1_.getInstance()._x))
      {
         _loc1_.getInstance()._x = Math.round(_loc1_.getInstance()._x);
      }
      if(_loc1_.getInstance()._y != Math.round(_loc1_.getInstance()._y))
      {
         _loc1_.getInstance()._y = Math.round(_loc1_.getInstance()._y);
      }
   }
}
