on(press){
   if(_parent.autoScroll == 1)
   {
      _parent.gotoAndStop(1);
      _parent.autoScroll = 0;
   }
   mouseOffset = _parent._ymouse - this._y;
   currMouse = _parent._ymouse;
   dragging = 1;
   gotoAndStop(1);
}
