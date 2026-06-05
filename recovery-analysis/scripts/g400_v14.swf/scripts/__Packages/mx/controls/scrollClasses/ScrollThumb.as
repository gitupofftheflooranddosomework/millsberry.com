class mx.controls.scrollClasses.ScrollThumb extends mx.skins.CustomBorder
{
   var _parent;
   var _y;
   var _ymouse;
   var datamax;
   var datamin;
   var gripSkin;
   var grip_mc;
   var lastY;
   var onMouseMove;
   var scrollMove;
   var setSkin;
   var useHandCursor;
   var ymax;
   var ymin;
   static var symbolOwner = mx.skins.CustomBorder.symbolOwner;
   var className = "ScrollThumb";
   var btnOffset = 0;
   var horizontal = false;
   var idNames = new Array("l_mc","m_mc","r_mc","grip_mc");
   function ScrollThumb()
   {
      super();
   }
   function createChildren(Void)
   {
      super.createChildren();
      this.useHandCursor = false;
   }
   function setRange(_ymin, _ymax, _datamin, _datamax)
   {
      this.ymin = _ymin;
      this.ymax = _ymax;
      this.datamin = _datamin;
      this.datamax = _datamax;
   }
   function dragThumb(Void)
   {
      this.scrollMove = this._ymouse - this.lastY;
      this.scrollMove += this._y;
      if(this.scrollMove < this.ymin)
      {
         this.scrollMove = this.ymin;
      }
      else if(this.scrollMove > this.ymax)
      {
         this.scrollMove = this.ymax;
      }
      this._parent.isScrolling = true;
      this._y = this.scrollMove;
      var _loc2_ = Math.round((this.datamax - this.datamin) * (this._y - this.ymin) / (this.ymax - this.ymin)) + this.datamin;
      this._parent.scrollPosition = _loc2_;
      this._parent.dispatchScrollEvent("ThumbTrack");
      updateAfterEvent();
   }
   function stopDragThumb(Void)
   {
      this._parent.isScrolling = false;
      this._parent.dispatchScrollEvent("ThumbPosition");
      this._parent.dispatchScrollChangedEvent();
      delete this.onMouseMove;
   }
   function onPress(Void)
   {
      this._parent.pressFocus();
      this.lastY = this._ymouse;
      this.onMouseMove = this.dragThumb;
      super.onPress();
   }
   function onRelease(Void)
   {
      this._parent.releaseFocus();
      this.stopDragThumb();
      super.onRelease();
   }
   function onReleaseOutside(Void)
   {
      this._parent.releaseFocus();
      this.stopDragThumb();
      super.onReleaseOutside();
   }
   function draw()
   {
      super.draw();
      if(this.grip_mc == undefined)
      {
         this.setSkin(3,this.gripSkin);
      }
   }
   function size()
   {
      super.size();
      this.grip_mc.move((this.width - this.grip_mc.width) / 2,(this.height - this.grip_mc.height) / 2);
   }
}
