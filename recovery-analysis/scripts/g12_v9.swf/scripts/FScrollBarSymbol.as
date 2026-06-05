FScrollBarClass = function()
{
   var _loc1_ = this;
   if(_loc1_._height != 4)
   {
      _loc1_.init();
      _loc1_.minPos = _loc1_.maxPos = _loc1_.pageSize = _loc1_.largeScroll = 0;
      _loc1_.smallScroll = 1;
      _loc1_.width = !_loc1_.horizontal ? _loc1_._height : _loc1_._width;
      _loc1_._xscale = _loc1_._yscale = 100;
      _loc1_.setScrollPosition(0);
      _loc1_.tabEnabled = false;
      if(_loc1_._targetInstanceName.length > 0)
      {
         _loc1_.setScrollTarget(_loc1_._parent[_loc1_._targetInstanceName]);
      }
      _loc1_.tabChildren = false;
      _loc1_.setSize(_loc1_.width);
   }
};
FScrollBarClass.prototype = new FUIComponentClass();
FScrollBarClass.prototype.setHorizontal = function(flag)
{
   var _loc1_ = this;
   var _loc2_ = flag;
   if(_loc1_.horizontal && !_loc2_)
   {
      _loc1_._xscale = 100;
      _loc1_._rotation = 0;
   }
   else if(_loc2_ && !_loc1_.horizontal)
   {
      _loc1_._xscale = -100;
      _loc1_._rotation = -90;
   }
   _loc1_.horizontal = _loc2_;
};
FScrollBarClass.prototype.setScrollProperties = function(pSize, mnPos, mxPos)
{
   var _loc1_ = this;
   var _loc2_;
   if(_loc1_.enable)
   {
      _loc1_.pageSize = pSize;
      _loc1_.minPos = Math.max(mnPos,0);
      _loc1_.maxPos = Math.max(mxPos,0);
      _loc1_.scrollPosition = Math.max(_loc1_.minPos,_loc1_.scrollPosition);
      _loc1_.scrollPosition = Math.min(_loc1_.maxPos,_loc1_.scrollPosition);
      if(_loc1_.maxPos - _loc1_.minPos <= 0)
      {
         _loc1_.scrollThumb_mc.removeMovieClip();
         _loc1_.upArrow_mc.gotoAndStop(3);
         _loc1_.downArrow_mc.gotoAndStop(3);
         _loc1_.downArrow_mc.onPress = _loc1_.downArrow_mc.onRelease = _loc1_.downArrow_mc.onDragOut = null;
         _loc1_.upArrow_mc.onPress = _loc1_.upArrow_mc.onRelease = _loc1_.upArrow_mc.onDragOut = null;
         _loc1_.scrollTrack_mc.onPress = _loc1_.scrollTrack_mc.onRelease = null;
         _loc1_.scrollTrack_mc.onDragOut = _loc1_.scrollTrack_mc.onRollOut = null;
         _loc1_.scrollTrack_mc.useHandCursor = false;
      }
      else
      {
         _loc2_ = _loc1_.getScrollPosition();
         _loc1_.upArrow_mc.gotoAndStop(1);
         _loc1_.downArrow_mc.gotoAndStop(1);
         _loc1_.upArrow_mc.onPress = _loc1_.upArrow_mc.onDragOver = _loc1_.startUpScroller;
         _loc1_.upArrow_mc.onRelease = _loc1_.upArrow_mc.onDragOut = _loc1_.stopScrolling;
         _loc1_.downArrow_mc.onPress = _loc1_.downArrow_mc.onDragOver = _loc1_.startDownScroller;
         _loc1_.downArrow_mc.onRelease = _loc1_.downArrow_mc.onDragOut = _loc1_.stopScrolling;
         _loc1_.scrollTrack_mc.onPress = _loc1_.scrollTrack_mc.onDragOver = _loc1_.startTrackScroller;
         _loc1_.scrollTrack_mc.onRelease = _loc1_.stopScrolling;
         _loc1_.scrollTrack_mc.onDragOut = _loc1_.stopScrolling;
         _loc1_.scrollTrack_mc.onRollOut = _loc1_.stopScrolling;
         _loc1_.scrollTrack_mc.useHandCursor = false;
         _loc1_.attachMovie("ScrollThumb","scrollThumb_mc",3);
         _loc1_.scrollThumb_mc._x = 0;
         _loc1_.scrollThumb_mc._y = _loc1_.upArrow_mc._height;
         _loc1_.scrollThumb_mc.onPress = _loc1_.startDragThumb;
         _loc1_.scrollThumb_mc.controller = _loc1_;
         _loc1_.scrollThumb_mc.onRelease = _loc1_.scrollThumb_mc.onReleaseOutside = _loc1_.stopDragThumb;
         _loc1_.scrollThumb_mc.useHandCursor = false;
         _loc1_.thumbHeight = _loc1_.pageSize / (_loc1_.maxPos - _loc1_.minPos + _loc1_.pageSize) * _loc1_.trackSize;
         _loc1_.thumbMid_mc = _loc1_.scrollThumb_mc.mc_sliderMid;
         _loc1_.thumbTop_mc = _loc1_.scrollThumb_mc.mc_sliderTop;
         _loc1_.thumbBot_mc = _loc1_.scrollThumb_mc.mc_sliderBot;
         _loc1_.thumbHeight = Math.max(_loc1_.thumbHeight,6);
         _loc1_.midHeight = _loc1_.thumbHeight - _loc1_.thumbTop_mc._height - _loc1_.thumbBot_mc._height;
         _loc1_.thumbMid_mc._yscale = _loc1_.midHeight * 100 / _loc1_.thumbMid_mc._height;
         _loc1_.thumbMid_mc._y = _loc1_.thumbTop_mc._height;
         _loc1_.thumbBot_mc._y = _loc1_.thumbTop_mc._height + _loc1_.midHeight;
         _loc1_.scrollTop = _loc1_.scrollThumb_mc._y;
         _loc1_.trackHeight = _loc1_.trackSize - _loc1_.thumbHeight;
         _loc1_.scrollBot = _loc1_.trackHeight + _loc1_.scrollTop;
         _loc2_ = Math.min(_loc2_,_loc1_.maxPos);
         _loc1_.setScrollPosition(Math.max(_loc2_,_loc1_.minPos));
      }
   }
};
FScrollBarClass.prototype.getScrollPosition = function()
{
   return this.scrollPosition;
};
FScrollBarClass.prototype.setScrollPosition = function(pos)
{
   var _loc1_ = this;
   var _loc2_ = pos;
   _loc1_.scrollPosition = _loc2_;
   if(_loc1_.scrollThumb_mc != undefined)
   {
      _loc2_ = Math.min(_loc2_,_loc1_.maxPos);
      _loc2_ = Math.max(_loc2_,_loc1_.minPos);
   }
   _loc1_.scrollThumb_mc._y = (_loc2_ - _loc1_.minPos) * _loc1_.trackHeight / (_loc1_.maxPos - _loc1_.minPos) + _loc1_.scrollTop;
   _loc1_.executeCallBack();
};
FScrollBarClass.prototype.setLargeScroll = function(lScroll)
{
   this.largeScroll = lScroll;
};
FScrollBarClass.prototype.setSmallScroll = function(sScroll)
{
   this.smallScroll = sScroll;
};
FScrollBarClass.prototype.setEnabled = function(enabledFlag)
{
   var _loc1_ = this;
   var _loc2_ = enabledFlag;
   var _loc3_ = _loc1_.enable;
   if(_loc2_ && !_loc3_)
   {
      _loc1_.enable = _loc2_;
      if(_loc1_.textField != undefined)
      {
         _loc1_.setScrollTarget(_loc1_.textField);
      }
      else
      {
         _loc1_.setScrollProperties(_loc1_.pageSize,_loc1_.cachedMinPos,_loc1_.cachedMaxPos);
         _loc1_.setScrollPosition(_loc1_.cachedPos);
      }
      _loc1_.clickFilter = undefined;
   }
   else if(!_loc2_ && _loc3_)
   {
      _loc1_.textField.removeListener(_loc1_);
      _loc1_.cachedPos = _loc1_.getScrollPosition();
      _loc1_.cachedMinPos = _loc1_.minPos;
      _loc1_.cachedMaxPos = _loc1_.maxPos;
      if(_loc1_.clickFilter == undefined)
      {
         _loc1_.setScrollProperties(_loc1_.pageSize,0,0);
      }
      else
      {
         _loc1_.clickFilter = true;
      }
      _loc1_.enable = _loc2_;
   }
};
FScrollBarClass.prototype.setSize = function(hgt)
{
   var _loc1_ = this;
   if(_loc1_._height != 1)
   {
      _loc1_.width = hgt;
      _loc1_.scrollTrack_mc._yscale = 100;
      _loc1_.scrollTrack_mc._yscale = 100 * _loc1_.width / _loc1_.scrollTrack_mc._height;
      if(_loc1_.upArrow_mc == undefined)
      {
         _loc1_.attachMovie("UpArrow","upArrow_mc",1);
         _loc1_.attachMovie("DownArrow","downArrow_mc",2);
         _loc1_.downArrow_mc.controller = _loc1_.upArrow_mc.controller = _loc1_;
         _loc1_.upArrow_mc.useHandCursor = _loc1_.downArrow_mc.useHandCursor = false;
         _loc1_.upArrow_mc._x = _loc1_.upArrow_mc._y = 0;
         _loc1_.downArrow_mc._x = 0;
      }
      _loc1_.scrollTrack_mc.controller = _loc1_;
      _loc1_.downArrow_mc._y = _loc1_.width - _loc1_.downArrow_mc._height;
      _loc1_.trackSize = _loc1_.width - 2 * _loc1_.downArrow_mc._height;
      if(_loc1_.textField != undefined)
      {
         _loc1_.onTextChanged();
      }
      else
      {
         _loc1_.setScrollProperties(_loc1_.pageSize,_loc1_.minPos,_loc1_.maxPos);
      }
   }
};
FScrollBarClass.prototype.scrollIt = function(inc, mode)
{
   var _loc1_ = this;
   var _loc3_ = _loc1_.smallScroll;
   if(inc != "one")
   {
      _loc3_ = _loc1_.largeScroll != 0 ? _loc1_.largeScroll : _loc1_.pageSize;
   }
   var _loc2_ = _loc1_.getScrollPosition() + mode * _loc3_;
   if(_loc2_ > _loc1_.maxPos)
   {
      _loc2_ = _loc1_.maxPos;
   }
   else if(_loc2_ < _loc1_.minPos)
   {
      _loc2_ = _loc1_.minPos;
   }
   _loc1_.setScrollPosition(_loc2_);
};
FScrollBarClass.prototype.startDragThumb = function()
{
   var _loc1_ = this;
   _loc1_.lastY = _loc1_._ymouse;
   _loc1_.onMouseMove = _loc1_.controller.dragThumb;
};
FScrollBarClass.prototype.dragThumb = function()
{
   var _loc1_ = this;
   _loc1_.scrollMove = _loc1_._ymouse - _loc1_.lastY;
   _loc1_.scrollMove += _loc1_._y;
   if(_loc1_.scrollMove < _loc1_.controller.scrollTop)
   {
      _loc1_.scrollMove = _loc1_.controller.scrollTop;
   }
   else if(_loc1_.scrollMove > _loc1_.controller.scrollBot)
   {
      _loc1_.scrollMove = _loc1_.controller.scrollBot;
   }
   _loc1_._y = _loc1_.scrollMove;
   var _loc2_ = _loc1_.controller;
   _loc2_.scrollPosition = Math.round((_loc2_.maxPos - _loc2_.minPos) * (_loc1_._y - _loc2_.scrollTop) / _loc2_.trackHeight) + _loc2_.minPos;
   _loc1_.controller.isScrolling = true;
   updateAfterEvent();
   _loc1_.controller.executeCallBack();
};
FScrollBarClass.prototype.stopDragThumb = function()
{
   this.controller.isScrolling = false;
   this.onMouseMove = null;
};
FScrollBarClass.prototype.startTrackScroller = function()
{
   var _loc1_ = this;
   _loc1_.controller.trackScroller();
   _loc1_.controller.scrolling = setInterval(_loc1_.controller,"scrollInterval",500,"page",-1);
};
FScrollBarClass.prototype.scrollInterval = function(inc, mode)
{
   var _loc1_ = this;
   var _loc2_ = inc;
   clearInterval(_loc1_.scrolling);
   if(_loc2_ == "page")
   {
      _loc1_.trackScroller();
   }
   else
   {
      _loc1_.scrollIt(_loc2_,mode);
   }
   _loc1_.scrolling = setInterval(_loc1_,"scrollInterval",35,_loc2_,mode);
};
FScrollBarClass.prototype.trackScroller = function()
{
   var _loc1_ = this;
   if(_loc1_.scrollThumb_mc._y + _loc1_.thumbHeight < _loc1_._ymouse)
   {
      _loc1_.scrollIt("page",1);
   }
   else if(_loc1_.scrollThumb_mc._y > _loc1_._ymouse)
   {
      _loc1_.scrollIt("page",-1);
   }
};
FScrollBarClass.prototype.stopScrolling = function()
{
   var _loc1_ = this;
   _loc1_.controller.downArrow_mc.gotoAndStop(1);
   _loc1_.controller.upArrow_mc.gotoAndStop(1);
   clearInterval(_loc1_.controller.scrolling);
};
FScrollBarClass.prototype.startUpScroller = function()
{
   var _loc1_ = this;
   _loc1_.controller.upArrow_mc.gotoAndStop(2);
   _loc1_.controller.scrollIt("one",-1);
   _loc1_.controller.scrolling = setInterval(_loc1_.controller,"scrollInterval",500,"one",-1);
};
FScrollBarClass.prototype.startDownScroller = function()
{
   var _loc1_ = this;
   _loc1_.controller.downArrow_mc.gotoAndStop(2);
   _loc1_.controller.scrollIt("one",1);
   _loc1_.controller.scrolling = setInterval(_loc1_.controller,"scrollInterval",500,"one",1);
};
FScrollBarClass.prototype.setScrollTarget = function(tF)
{
   var _loc1_ = this;
   var _loc2_ = tF;
   if(_loc2_ == undefined)
   {
      _loc1_.textField.removeListener(_loc1_);
      delete _loc1_.textField[!_loc1_.horizontal ? "vScroller" : "hScroller"];
      if(_loc1_.textField.hScroller != undefined && _loc1_.textField.vScroller != undefined)
      {
         _loc1_.textField.unwatch("text");
         _loc1_.textField.unwatch("htmlText");
      }
   }
   _loc1_.textField = undefined;
   if(_loc2_ instanceof TextField)
   {
      _loc1_.textField = _loc2_;
      _loc1_.textField[!_loc1_.horizontal ? "vScroller" : "hScroller"] = _loc1_;
      _loc1_.onTextChanged();
      _loc1_.onChanged = function()
      {
         this.onTextChanged();
      };
      _loc1_.onScroller = function()
      {
         var _loc1_ = this;
         if(!_loc1_.isScrolling)
         {
            if(!_loc1_.horizontal)
            {
               _loc1_.setScrollPosition(_loc1_.textField.scroll);
            }
            else
            {
               _loc1_.setScrollPosition(_loc1_.textField.hscroll);
            }
         }
      };
      _loc1_.textField.addListener(_loc1_);
      _loc1_.textField.watch("text",_loc1_.callback);
      _loc1_.textField.watch("htmlText",_loc1_.callback);
   }
};
FScrollBarClass.prototype.callback = function(prop, oldVal, newVal)
{
   var _loc1_ = this;
   clearInterval(_loc1_.hScroller.synchScroll);
   clearInterval(_loc1_.vScroller.synchScroll);
   _loc1_.hScroller.synchScroll = setInterval(_loc1_.hScroller,"onTextChanged",50);
   _loc1_.vScroller.synchScroll = setInterval(_loc1_.vScroller,"onTextChanged",50);
   return newVal;
};
FScrollBarClass.prototype.onTextChanged = function()
{
   var _loc1_ = this;
   var _loc2_;
   var _loc3_;
   if(!(!_loc1_.enable || _loc1_.textField == undefined))
   {
      clearInterval(_loc1_.synchScroll);
      if(_loc1_.horizontal)
      {
         _loc2_ = _loc1_.textField.hscroll;
         _loc1_.setScrollProperties(_loc1_.textField._width,0,_loc1_.textField.maxhscroll);
         _loc1_.setScrollPosition(Math.min(_loc2_,_loc1_.textField.maxhscroll));
      }
      else
      {
         _loc2_ = _loc1_.textField.scroll;
         _loc3_ = _loc1_.textField.bottomScroll - _loc1_.textField.scroll;
         _loc1_.setScrollProperties(_loc3_,1,_loc1_.textField.maxscroll);
         _loc1_.setScrollPosition(Math.min(_loc2_,_loc1_.textField.maxscroll));
      }
   }
};
FScrollBarClass.prototype.executeCallBack = function()
{
   var _loc1_ = this;
   if(_loc1_.textField == undefined)
   {
      super.executeCallBack();
   }
   else if(_loc1_.horizontal)
   {
      _loc1_.textField.hscroll = _loc1_.getScrollPosition();
   }
   else
   {
      _loc1_.textField.scroll = _loc1_.getScrollPosition();
   }
};
Object.registerClass("FScrollBarSymbol",FScrollBarClass);
