function FScrollPaneClass()
{
   var _loc1_ = this;
   function boolToString(str)
   {
      var _loc1_ = str;
      if(_loc1_ == "false")
      {
         return false;
      }
      if(_loc1_ == "true")
      {
         return true;
      }
      return _loc1_;
   }
   _loc1_.init();
   _loc1_.width = _loc1_._width;
   _loc1_.height = _loc1_._height;
   _loc1_._xscale = _loc1_._yscale = 100;
   _loc1_.contentWidth = _loc1_.contentHeight = 0;
   if(_loc1_.hScroll == undefined)
   {
      _loc1_.hScroll = _loc1_.vScroll = "auto";
      _loc1_.dragContent = false;
   }
   _loc1_.offset = new Object();
   _loc1_.vScroll = boolToString(_loc1_.vScroll);
   _loc1_.hScroll = boolToString(_loc1_.hScroll);
   _loc1_.attachMovie("FScrollBarSymbol","hScrollBar_mc",100,{hostStyle:_loc1_.styleTable});
   _loc1_.hScrollBar_mc.setHorizontal(true);
   _loc1_.hScrollBar_mc.setSmallScroll(5);
   _loc1_.hScrollBar_mc.setChangeHandler("onScroll",_loc1_);
   _loc1_.attachMovie("FScrollBarSymbol","vScrollBar_mc",99,{hostStyle:_loc1_.styleTable});
   _loc1_.vScrollBar_mc.setSmallScroll(5);
   _loc1_.vScrollBar_mc.setChangeHandler("onScroll",_loc1_);
   _loc1_.setSize(_loc1_.width,_loc1_.height);
   if(_loc1_.scrollContent != "")
   {
      _loc1_.setScrollContent(_loc1_.scrollContent);
   }
   _loc1_.setDragContent(_loc1_.dragContent);
}
FScrollPaneClass.prototype = new FUIComponentClass();
Object.registerClass("FScrollPaneSymbol",FScrollPaneClass);
FScrollPaneClass.prototype.getScrollContent = function()
{
   return this.content_mc;
};
FScrollPaneClass.prototype.getPaneWidth = function()
{
   return this.width;
};
FScrollPaneClass.prototype.getPaneHeight = function()
{
   return this.height;
};
FScrollPaneClass.prototype.getScrollPosition = function()
{
   var _loc1_ = this;
   var _loc3_ = _loc1_.hScrollBar_mc != undefined ? _loc1_.hScrollBar_mc.getScrollPosition() : 0;
   var _loc2_ = _loc1_.vScrollBar_mc != undefined ? _loc1_.vScrollBar_mc.getScrollPosition() : 0;
   return {x:_loc3_,y:_loc2_};
};
FScrollPaneClass.prototype.setScrollContent = function(target)
{
   var _loc1_ = this;
   var _loc2_ = target;
   _loc1_.offset.x = 0;
   _loc1_.offset.y = 0;
   if(_loc1_.content_mc != undefined)
   {
      if(_loc2_ != _loc1_.content_mc)
      {
         _loc1_.content_mc._visible = false;
         _loc1_.content_mc.removeMovieClip();
         _loc1_.content_mc.unloadMovie();
      }
   }
   if(typeof _loc2_ == "string")
   {
      _loc1_.attachMovie(_loc2_,"tmp_mc",3);
      _loc1_.content_mc = _loc1_.tmp_mc;
   }
   else if(_loc2_ == undefined)
   {
      _loc1_.content_mc.unloadMovie();
   }
   else
   {
      _loc1_.content_mc = _loc2_;
   }
   _loc1_.localToGlobal(_loc1_.offset);
   _loc1_.content_mc._parent.globalToLocal(_loc1_.offset);
   _loc1_.content_mc._x = _loc1_.offset.x;
   _loc1_.content_mc._y = _loc1_.offset.y;
   var _loc3_ = _loc1_.content_mc.getBounds(_loc1_);
   _loc1_.offset.x = - _loc3_.xMin;
   _loc1_.offset.y = - _loc3_.yMin;
   _loc1_.localToGlobal(_loc1_.offset);
   _loc1_.content_mc._parent.globalToLocal(_loc1_.offset);
   _loc1_.content_mc._x = _loc1_.offset.x;
   _loc1_.content_mc._y = _loc1_.offset.y;
   _loc1_.contentWidth = _loc1_.content_mc._width;
   _loc1_.contentHeight = _loc1_.content_mc._height;
   _loc1_.content_mc.setMask(_loc1_.mask_mc);
   _loc1_.setSize(_loc1_.width,_loc1_.height);
};
FScrollPaneClass.prototype.setSize = function(w, h)
{
   var _loc1_ = this;
   var _loc2_ = h;
   var _loc3_ = w;
   if(!(arguments.length < 2 || isNaN(_loc3_) || isNaN(_loc2_)))
   {
      super.setSize(_loc3_,_loc2_);
      _loc1_.width = Math.max(_loc3_,60);
      _loc1_.height = Math.max(_loc2_,60);
      _loc1_.boundingBox_mc._xscale = 100;
      _loc1_.boundingBox_mc._yscale = 100;
      _loc1_.boundingBox_mc._width = _loc1_.width;
      _loc1_.boundingBox_mc._height = _loc1_.height;
      _loc1_.setHandV();
      _loc1_.initScrollBars();
      if(_loc1_.mask_mc == undefined)
      {
         _loc1_.attachMovie("FBoundingBoxSymbol","mask_mc",3000);
      }
      _loc1_.mask_mc._xscale = 100;
      _loc1_.mask_mc._yscale = 100;
      _loc1_.mask_mc._width = _loc1_.hWidth;
      _loc1_.mask_mc._height = _loc1_.vHeight;
      _loc1_.mask_mc._alpha = 0;
   }
};
FScrollPaneClass.prototype.setScrollPosition = function(x, y)
{
   var _loc1_ = this;
   var _loc2_ = y;
   var _loc3_ = x;
   _loc3_ = Math.max(_loc1_.hScrollBar_mc.minPos,_loc3_);
   _loc3_ = Math.min(_loc1_.hScrollBar_mc.maxPos,_loc3_);
   _loc2_ = Math.max(_loc1_.vScrollBar_mc.minPos,_loc2_);
   _loc2_ = Math.min(_loc1_.vScrollBar_mc.maxPos,_loc2_);
   _loc1_.hScrollBar_mc.setScrollPosition(_loc3_);
   _loc1_.vScrollBar_mc.setScrollPosition(_loc2_);
};
FScrollPaneClass.prototype.refreshPane = function()
{
   this.setScrollContent(this.content_mc);
};
FScrollPaneClass.prototype.loadScrollContent = function(url, handler, location)
{
   var _loc1_ = this;
   _loc1_.content_mc.removeMovieClip();
   _loc1_.content_mc.unloadMovie();
   _loc1_.content_mc._visible = 0;
   _loc1_.loadContent.duplicateMovieClip("loadTemp",3);
   _loc1_.dupeFlag = true;
   _loc1_.contentLoaded = function()
   {
      var _loc1_ = this;
      _loc1_.loadReady = false;
      _loc1_.content_mc = _loc1_.loadTemp;
      _loc1_.refreshPane();
      _loc1_.executeCallBack();
   };
   _loc1_.setChangeHandler(handler,location);
   _loc1_.loadTemp.loadMovie(url);
};
FScrollPaneClass.prototype.setHScroll = function(prop)
{
   var _loc1_ = this;
   _loc1_.hScroll = prop;
   _loc1_.setSize(_loc1_.width,_loc1_.height);
};
FScrollPaneClass.prototype.setVScroll = function(prop)
{
   var _loc1_ = this;
   _loc1_.vScroll = prop;
   _loc1_.setSize(_loc1_.width,_loc1_.height);
};
FScrollPaneClass.prototype.setDragContent = function(dragFlag)
{
   var _loc1_ = this;
   if(dragFlag)
   {
      _loc1_.boundingBox_mc.useHandCursor = true;
      _loc1_.boundingBox_mc.onPress = function()
      {
         this._parent.startDragLoop();
      };
      _loc1_.boundingBox_mc.tabEnabled = false;
      _loc1_.boundingBox_mc.onRelease = _loc1_.boundingBox_mc.onReleaseOutside = function()
      {
         this._parent.pressFocus();
         this._parent.onMouseMove = null;
      };
   }
   else
   {
      delete _loc1_.boundingBox_mc.onPress;
      _loc1_.boundingBox_mc.useHandCursor = false;
   }
};
FScrollPaneClass.prototype.setSmallScroll = function(x, y)
{
   this.hScrollBar_mc.setSmallScroll(x);
   this.vScrollBar_mc.setSmallScroll(y);
};
FScrollPaneClass.prototype.setHandV = function()
{
   var _loc1_ = this;
   if(_loc1_.contentHeight - _loc1_.height > 2 && _loc1_.vScroll != false || _loc1_.vScroll == true)
   {
      _loc1_.hWidth = _loc1_.width - _loc1_.vScrollBar_mc._width;
   }
   else
   {
      _loc1_.hWidth = _loc1_.width;
   }
   if(_loc1_.contentWidth - _loc1_.width > 2 && _loc1_.hScroll != false || _loc1_.hScroll == true)
   {
      _loc1_.vHeight = _loc1_.height - _loc1_.hScrollBar_mc._height;
   }
   else
   {
      _loc1_.vHeight = _loc1_.height;
   }
};
FScrollPaneClass.prototype.startDragLoop = function()
{
   var _loc1_ = this;
   _loc1_.tabFocused = false;
   _loc1_.myOnSetFocus();
   _loc1_.lastX = _loc1_._xmouse;
   _loc1_.lastY = _loc1_._ymouse;
   _loc1_.onMouseMove = function()
   {
      var _loc1_ = this;
      _loc1_.scrollXMove = _loc1_.lastX - _loc1_._xmouse;
      _loc1_.scrollYMove = _loc1_.lastY - _loc1_._ymouse;
      _loc1_.scrollXMove += _loc1_.hScrollBar_mc.getScrollPosition();
      _loc1_.scrollYMove += _loc1_.vScrollBar_mc.getScrollPosition();
      _loc1_.setScrollPosition(_loc1_.scrollXMove,_loc1_.scrollYMove);
      if(_loc1_.scrollXMove < _loc1_.hScrollBar_mc.maxPos && _loc1_.scrollXMove > _loc1_.hScrollBar_mc.minPos)
      {
         _loc1_.lastX = _loc1_._xmouse;
      }
      if(_loc1_.scrollYMove < _loc1_.vScrollBar_mc.maxPos && _loc1_.scrollYMove > _loc1_.vScrollBar_mc.minPos)
      {
         _loc1_.lastY = _loc1_._ymouse;
      }
      _loc1_.updateAfterEvent();
   };
};
FScrollPaneClass.prototype.initScrollBars = function()
{
   var _loc1_ = this;
   _loc1_.hScrollBar_mc._y = _loc1_.height - _loc1_.hScrollBar_mc._height;
   _loc1_.hScrollBar_mc.setSize(_loc1_.hWidth);
   _loc1_.hScrollBar_mc.setScrollProperties(_loc1_.hWidth,0,_loc1_.contentWidth - _loc1_.hWidth);
   _loc1_.vScrollBar_mc._visible = _loc1_.hWidth != _loc1_.width ? true : false;
   _loc1_.vScrollBar_mc._x = _loc1_.width - _loc1_.vScrollBar_mc._width;
   _loc1_.vScrollBar_mc.setSize(_loc1_.vHeight);
   _loc1_.vScrollBar_mc.setScrollProperties(_loc1_.vHeight,0,_loc1_.contentHeight - _loc1_.vHeight);
   _loc1_.hScrollBar_mc._visible = _loc1_.vHeight != _loc1_.height ? true : false;
};
FScrollPaneClass.prototype.onScroll = function(component)
{
   var _loc2_ = this;
   var _loc3_ = component;
   var _loc1_ = _loc3_.getScrollPosition();
   var XorY = _loc3_._name != "hScrollBar_mc" ? "y" : "x";
   if(_loc3_._name == "hScrollBar_mc")
   {
      _loc2_.content_mc._x = - _loc1_ + _loc2_.offset.x;
   }
   else
   {
      _loc2_.content_mc._y = - _loc1_ + _loc2_.offset.y;
   }
};
FScrollPaneClass.prototype.myOnKeyDown = function()
{
   var _loc1_ = this;
   var _loc3_ = _loc1_.hScrollBar_mc.getScrollPosition();
   var _loc2_ = _loc1_.vScrollBar_mc.getScrollPosition();
   if(_loc1_.hScrollBar_mc.maxPos > _loc1_.hScrollBar_mc.minPos)
   {
      if(Key.isDown(37))
      {
         _loc1_.setScrollPosition(_loc3_ - 3,_loc2_);
      }
      else if(Key.isDown(39))
      {
         _loc1_.setScrollPosition(_loc3_ + 3,_loc2_);
      }
   }
   if(_loc1_.vScrollBar_mc.maxPos > _loc1_.vScrollBar_mc.minPos)
   {
      if(Key.isDown(38))
      {
         _loc1_.setScrollPosition(_loc3_,_loc2_ - 3);
      }
      else if(Key.isDown(40))
      {
         _loc1_.setScrollPosition(_loc3_,_loc2_ + 3);
      }
      else if(Key.isDown(34))
      {
         _loc1_.setScrollPosition(_loc3_,_loc2_ + _loc1_.vScrollBar_mc.pageSize);
      }
      else if(Key.isDown(33))
      {
         _loc1_.setScrollPosition(_loc3_,_loc2_ - _loc1_.vScrollBar_mc.pageSize);
      }
   }
};
