class mx.skins.halo.FocusRect extends mx.skins.SkinElement
{
   var _parent;
   var _visible;
   var _xscale;
   var _yscale;
   var addEventListener;
   var beginFill;
   var boundingBox_mc;
   var clear;
   var drawRoundRect;
   var endFill;
   var getDepth;
   var getStyle;
   var height;
   var removeEventListener;
   var width;
   var x;
   var y;
   static var classConstructed = mx.skins.halo.FocusRect.classConstruct();
   static var DefaultsDependency = mx.skins.halo.Defaults;
   static var UIComponentDependency = mx.core.UIComponent;
   function FocusRect()
   {
      super();
      this.boundingBox_mc._visible = false;
      this.boundingBox_mc._width = this.boundingBox_mc._height = 0;
   }
   function draw(o)
   {
      o.adjustFocusRect();
   }
   function setSize(w, h, r, a, rectCol)
   {
      this._xscale = this._yscale = 100;
      this.clear();
      var _loc5_;
      if(typeof r == "object")
      {
         r.br = r.br <= 2 ? 0 : r.br - 2;
         r.bl = r.bl <= 2 ? 0 : r.bl - 2;
         r.tr = r.tr <= 2 ? 0 : r.tr - 2;
         r.tl = r.tl <= 2 ? 0 : r.tl - 2;
         this.beginFill(rectCol,a * 0.3);
         this.drawRoundRect(0,0,w,h,r);
         this.drawRoundRect(2,2,w - 4,h - 4,r);
         this.endFill();
         r.br = r.br <= 1 ? 0 : r.br + 1;
         r.bl = r.bl <= 1 ? 0 : r.bl + 1;
         r.tr = r.tr <= 1 ? 0 : r.tr + 1;
         r.tl = r.tl <= 1 ? 0 : r.tl + 1;
         this.beginFill(rectCol,a * 0.3);
         this.drawRoundRect(1,1,w - 2,h - 2,r);
         r.br = r.br <= 1 ? 0 : r.br - 1;
         r.bl = r.bl <= 1 ? 0 : r.bl - 1;
         r.tr = r.tr <= 1 ? 0 : r.tr - 1;
         r.tl = r.tl <= 1 ? 0 : r.tl - 1;
         this.drawRoundRect(2,2,w - 4,h - 4,r);
         this.endFill();
      }
      else
      {
         if(r != 0)
         {
            _loc5_ = r - 2;
         }
         else
         {
            _loc5_ = 0;
         }
         this.beginFill(rectCol,a * 0.3);
         this.drawRoundRect(0,0,w,h,r);
         this.drawRoundRect(2,2,w - 4,h - 4,_loc5_);
         this.endFill();
         this.beginFill(rectCol,a * 0.3);
         if(r != 0)
         {
            _loc5_ = r - 2;
            r -= 1;
         }
         else
         {
            _loc5_ = 0;
            r = 0;
         }
         this.drawRoundRect(1,1,w - 2,h - 2,r);
         this.drawRoundRect(2,2,w - 4,h - 4,_loc5_);
         this.endFill();
      }
   }
   function handleEvent(e)
   {
      if(e.type == "unload")
      {
         this._visible = true;
      }
      else if(e.type == "resize")
      {
         e.target.adjustFocusRect();
      }
      else if(e.type == "move")
      {
         e.target.adjustFocusRect();
      }
   }
   static function classConstruct()
   {
      mx.core.UIComponent.prototype.drawFocus = function(focused)
      {
         var _loc2_ = this._parent.focus_mc;
         if(!focused)
         {
            _loc2_._visible = false;
            this.removeEventListener("unload",_loc2_);
            this.removeEventListener("move",_loc2_);
            this.removeEventListener("resize",_loc2_);
         }
         else
         {
            if(_loc2_ == undefined)
            {
               _loc2_ = this._parent.createChildAtDepth("FocusRect",mx.managers.DepthManager.kTop);
               _loc2_.tabEnabled = false;
               this._parent.focus_mc = _loc2_;
            }
            else
            {
               _loc2_._visible = true;
            }
            _loc2_.draw(this);
            if(_loc2_.getDepth() < this.getDepth())
            {
               _loc2_.setDepthAbove(this);
            }
            this.addEventListener("unload",_loc2_);
            this.addEventListener("move",_loc2_);
            this.addEventListener("resize",_loc2_);
         }
      };
      mx.core.UIComponent.prototype.adjustFocusRect = function()
      {
         var _loc2_ = this.getStyle("themeColor");
         if(_loc2_ == undefined)
         {
            _loc2_ = 8453965;
         }
         var _loc3_ = this._parent.focus_mc;
         _loc3_.setSize(this.width + 4,this.height + 4,0,100,_loc2_);
         _loc3_.move(this.x - 2,this.y - 2);
      };
      TextField.prototype.drawFocus = mx.core.UIComponent.prototype.drawFocus;
      TextField.prototype.adjustFocusRect = mx.core.UIComponent.prototype.adjustFocusRect;
      mx.skins.halo.FocusRect.prototype.drawRoundRect = mx.skins.halo.Defaults.prototype.drawRoundRect;
      return true;
   }
}
