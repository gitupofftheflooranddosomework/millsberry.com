FScrollBarClass = function()
{
   if(this._height == 4)
   {
      return undefined;
   }
   this.init();
   this.minPos = this.maxPos = this.pageSize = this.largeScroll = 0;
   this.smallScroll = 1;
   this.width = !this.horizontal ? this._height : this._width;
   this._xscale = this._yscale = 100;
   this.setScrollPosition(0);
   this.tabEnabled = false;
   if(this._targetInstanceName.length > 0)
   {
      this.setScrollTarget(this._parent[this._targetInstanceName]);
   }
   this.tabChildren = false;
   this.setSize(this.width);
};
FScrollBarClass.prototype = new FUIComponentClass();
FScrollBarClass.prototype.setHorizontal = function(flag)
{
   if(this.horizontal && !flag)
   {
      this._xscale = 100;
      this._rotation = 0;
   }
   else if(flag && !this.horizontal)
   {
      this._xscale = -100;
      this._rotation = -90;
   }
   this.horizontal = flag;
};
FScrollBarClass.prototype.setScrollProperties = function(pSize, mnPos, mxPos)
{
   if(!this.enable)
   {
      return undefined;
   }
   this.pageSize = pSize;
   this.minPos = Math.max(mnPos,0);
   this.maxPos = Math.max(mxPos,0);
   this.scrollPosition = Math.max(this.minPos,this.scrollPosition);
   this.scrollPosition = Math.min(this.maxPos,this.scrollPosition);
   var _loc2_;
   if(this.maxPos - this.minPos <= 0)
   {
      this.scrollThumb_mc.removeMovieClip();
      this.upArrow_mc.gotoAndStop(3);
      this.downArrow_mc.gotoAndStop(3);
      this.downArrow_mc.onPress = this.downArrow_mc.onRelease = this.downArrow_mc.onDragOut = null;
      this.upArrow_mc.onPress = this.upArrow_mc.onRelease = this.upArrow_mc.onDragOut = null;
      this.scrollTrack_mc.onPress = this.scrollTrack_mc.onRelease = null;
      this.scrollTrack_mc.onDragOut = this.scrollTrack_mc.onRollOut = null;
      this.scrollTrack_mc.useHandCursor = false;
   }
   else
   {
      _loc2_ = this.getScrollPosition();
      this.upArrow_mc.gotoAndStop(1);
      this.downArrow_mc.gotoAndStop(1);
      this.upArrow_mc.onPress = this.upArrow_mc.onDragOver = this.startUpScroller;
      this.upArrow_mc.onRelease = this.upArrow_mc.onDragOut = this.stopScrolling;
      this.downArrow_mc.onPress = this.downArrow_mc.onDragOver = this.startDownScroller;
      this.downArrow_mc.onRelease = this.downArrow_mc.onDragOut = this.stopScrolling;
      this.scrollTrack_mc.onPress = this.scrollTrack_mc.onDragOver = this.startTrackScroller;
      this.scrollTrack_mc.onRelease = this.stopScrolling;
      this.scrollTrack_mc.onDragOut = this.stopScrolling;
      this.scrollTrack_mc.onRollOut = this.stopScrolling;
      this.scrollTrack_mc.useHandCursor = false;
      this.attachMovie("ScrollThumb","scrollThumb_mc",3);
      this.scrollThumb_mc._x = 0;
      this.scrollThumb_mc._y = this.upArrow_mc._height;
      this.scrollThumb_mc.onPress = this.startDragThumb;
      this.scrollThumb_mc.controller = this;
      this.scrollThumb_mc.onRelease = this.scrollThumb_mc.onReleaseOutside = this.stopDragThumb;
      this.scrollThumb_mc.useHandCursor = false;
      this.thumbHeight = this.pageSize / (this.maxPos - this.minPos + this.pageSize) * this.trackSize;
      this.thumbMid_mc = this.scrollThumb_mc.mc_sliderMid;
      this.thumbTop_mc = this.scrollThumb_mc.mc_sliderTop;
      this.thumbBot_mc = this.scrollThumb_mc.mc_sliderBot;
      this.thumbHeight = Math.max(this.thumbHeight,6);
      this.midHeight = this.thumbHeight - this.thumbTop_mc._height - this.thumbBot_mc._height;
      this.thumbMid_mc._yScale = this.midHeight * 100 / this.thumbMid_mc._height;
      this.thumbMid_mc._y = this.thumbTop_mc._height;
      this.thumbBot_mc._y = this.thumbTop_mc._height + this.midHeight;
      this.scrollTop = this.scrollThumb_mc._y;
      this.trackHeight = this.trackSize - this.thumbHeight;
      this.scrollBot = this.trackHeight + this.scrollTop;
      _loc2_ = Math.min(_loc2_,this.maxPos);
      this.setScrollPosition(Math.max(_loc2_,this.minPos));
   }
};
FScrollBarClass.prototype.getScrollPosition = function()
{
   return this.scrollPosition;
};
FScrollBarClass.prototype.setScrollPosition = function(pos)
{
   this.scrollPosition = pos;
   if(this.scrollThumb_mc != undefined)
   {
      pos = Math.min(pos,this.maxPos);
      pos = Math.max(pos,this.minPos);
   }
   this.scrollThumb_mc._y = (pos - this.minPos) * this.trackHeight / (this.maxPos - this.minPos) + this.scrollTop;
   this.executeCallBack();
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
   var _loc3_ = this.enable;
   if(enabledFlag && !_loc3_)
   {
      this.enable = enabledFlag;
      if(this.textField != undefined)
      {
         this.setScrollTarget(this.textField);
      }
      else
      {
         this.setScrollProperties(this.pageSize,this.cachedMinPos,this.cachedMaxPos);
         this.setScrollPosition(this.cachedPos);
      }
      this.clickFilter = undefined;
   }
   else if(!enabledFlag && _loc3_)
   {
      this.textField.removeListener(this);
      this.cachedPos = this.getScrollPosition();
      this.cachedMinPos = this.minPos;
      this.cachedMaxPos = this.maxPos;
      if(this.clickFilter == undefined)
      {
         this.setScrollProperties(this.pageSize,0,0);
      }
      else
      {
         this.clickFilter = true;
      }
      this.enable = enabledFlag;
   }
};
FScrollBarClass.prototype.setSize = function(hgt)
{
   if(this._height == 1)
   {
      return undefined;
   }
   this.width = hgt;
   this.scrollTrack_mc._yscale = 100;
   this.scrollTrack_mc._yscale = 100 * this.width / this.scrollTrack_mc._height;
   if(this.upArrow_mc == undefined)
   {
      this.attachMovie("UpArrow","upArrow_mc",1);
      this.attachMovie("DownArrow","downArrow_mc",2);
      this.downArrow_mc.controller = this.upArrow_mc.controller = this;
      this.upArrow_mc.useHandCursor = this.downArrow_mc.useHandCursor = false;
      this.upArrow_mc._x = this.upArrow_mc._y = 0;
      this.downArrow_mc._x = 0;
   }
   this.scrollTrack_mc.controller = this;
   this.downArrow_mc._y = this.width - this.downArrow_mc._height;
   this.trackSize = this.width - 2 * this.downArrow_mc._height;
   if(this.textField != undefined)
   {
      this.onTextChanged();
   }
   else
   {
      this.setScrollProperties(this.pageSize,this.minPos,this.maxPos);
   }
};
FScrollBarClass.prototype.scrollIt = function(inc, mode)
{
   var _loc3_ = this.smallScroll;
   if(inc != "one")
   {
      _loc3_ = this.largeScroll != 0 ? this.largeScroll : this.pageSize;
   }
   var _loc2_ = this.getScrollPosition() + mode * _loc3_;
   if(_loc2_ > this.maxPos)
   {
      _loc2_ = this.maxPos;
   }
   else if(_loc2_ < this.minPos)
   {
      _loc2_ = this.minPos;
   }
   this.setScrollPosition(_loc2_);
};
FScrollBarClass.prototype.startDragThumb = function()
{
   this.lastY = this._ymouse;
   this.onMouseMove = this.controller.dragThumb;
};
FScrollBarClass.prototype.dragThumb = function()
{
   this.scrollMove = this._ymouse - this.lastY;
   this.scrollMove += this._y;
   if(this.scrollMove < this.controller.scrollTop)
   {
      this.scrollMove = this.controller.scrollTop;
   }
   else if(this.scrollMove > this.controller.scrollBot)
   {
      this.scrollMove = this.controller.scrollBot;
   }
   this._y = this.scrollMove;
   var _loc2_ = this.controller;
   _loc2_.scrollPosition = Math.round((_loc2_.maxPos - _loc2_.minPos) * (this._y - _loc2_.scrollTop) / _loc2_.trackHeight) + _loc2_.minPos;
   this.controller.isScrolling = true;
   updateAfterEvent();
   this.controller.executeCallBack();
};
FScrollBarClass.prototype.stopDragThumb = function()
{
   this.controller.isScrolling = false;
   this.onMouseMove = null;
};
FScrollBarClass.prototype.startTrackScroller = function()
{
   this.controller.trackScroller();
   this.controller.scrolling = setInterval(this.controller,"scrollInterval",500,"page",-1);
};
FScrollBarClass.prototype.scrollInterval = function(inc, mode)
{
   clearInterval(this.scrolling);
   if(inc == "page")
   {
      this.trackScroller();
   }
   else
   {
      this.scrollIt(inc,mode);
   }
   this.scrolling = setInterval(this,"scrollInterval",35,inc,mode);
};
FScrollBarClass.prototype.trackScroller = function()
{
   if(this.scrollThumb_mc._y + this.thumbHeight < this._ymouse)
   {
      this.scrollIt("page",1);
   }
   else if(this.scrollThumb_mc._y > this._ymouse)
   {
      this.scrollIt("page",-1);
   }
};
FScrollBarClass.prototype.stopScrolling = function()
{
   this.controller.downArrow_mc.gotoAndStop(1);
   this.controller.upArrow_mc.gotoAndStop(1);
   clearInterval(this.controller.scrolling);
};
FScrollBarClass.prototype.startUpScroller = function()
{
   this.controller.upArrow_mc.gotoAndStop(2);
   this.controller.scrollIt("one",-1);
   this.controller.scrolling = setInterval(this.controller,"scrollInterval",500,"one",-1);
};
FScrollBarClass.prototype.startDownScroller = function()
{
   this.controller.downArrow_mc.gotoAndStop(2);
   this.controller.scrollIt("one",1);
   this.controller.scrolling = setInterval(this.controller,"scrollInterval",500,"one",1);
};
FScrollBarClass.prototype.setScrollTarget = function(tF)
{
   if(tF == undefined)
   {
      this.textField.removeListener(this);
      delete this.textField[!this.horizontal ? "vScroller" : "hScroller"];
      if(this.textField.hScroller != undefined && this.textField.vScroller != undefined)
      {
         this.textField.unwatch("text");
         this.textField.unwatch("htmltext");
      }
   }
   this.textField = undefined;
   if(!(tF instanceof TextField))
   {
      return undefined;
   }
   this.textField = tF;
   this.textField[!this.horizontal ? "vScroller" : "hScroller"] = this;
   this.onTextChanged();
   this.onChanged = function()
   {
      this.onTextChanged();
   };
   this.onScroller = function()
   {
      if(!this.isScrolling)
      {
         if(!this.horizontal)
         {
            this.setScrollPosition(this.textField.scroll);
         }
         else
         {
            this.setScrollPosition(this.textField.hscroll);
         }
      }
   };
   this.textField.addListener(this);
   this.textField.watch("text",this.callback);
   this.textField.watch("htmlText",this.callback);
};
FScrollBarClass.prototype.callback = function(prop, oldVal, newVal)
{
   clearInterval(this.hScroller.synchScroll);
   clearInterval(this.vScroller.synchScroll);
   this.hScroller.synchScroll = setInterval(this.hScroller,"onTextChanged",50);
   this.vScroller.synchScroll = setInterval(this.vScroller,"onTextChanged",50);
   return newVal;
};
FScrollBarClass.prototype.onTextChanged = function()
{
   if(!this.enable || this.textField == undefined)
   {
      return undefined;
   }
   clearInterval(this.synchScroll);
   var _loc2_;
   var _loc3_;
   if(this.horizontal)
   {
      _loc2_ = this.textField.hscroll;
      this.setScrollProperties(this.textField._width,0,this.textField.maxhscroll);
      this.setScrollPosition(Math.min(_loc2_,this.textField.maxhscroll));
   }
   else
   {
      _loc2_ = this.textField.scroll;
      _loc3_ = this.textField.bottomScroll - this.textField.scroll;
      this.setScrollProperties(_loc3_,1,this.textField.maxscroll);
      this.setScrollPosition(Math.min(_loc2_,this.textField.maxscroll));
   }
};
FScrollBarClass.prototype.executeCallBack = function()
{
   if(this.textField == undefined)
   {
      super.executeCallBack();
   }
   else if(this.horizontal)
   {
      this.textField.hscroll = this.getScrollPosition();
   }
   else
   {
      this.textField.scroll = this.getScrollPosition();
   }
};
Object.registerClass("FScrollBarSymbol",FScrollBarClass);
