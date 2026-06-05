onClipEvent(load){
   function setContent(mouseY)
   {
      if(mouseY > max)
      {
         this._y = max;
      }
      else if(mouseY < min)
      {
         this._y = min;
      }
      else
      {
         this._y = mouseY;
      }
      _parent._parent.content._y = Math.floor((this._y - min) / (max - min) * _parent.scrollLimit);
   }
   this._height = Math.floor(_parent.allScrollerHeight / _parent.contentHeight * (_parent.allScrollerHeight - 2 * _parent.btnHeight));
   min = this._y;
   max = _parent.allScrollerHeight - _parent.btnHeight - this._height;
}
