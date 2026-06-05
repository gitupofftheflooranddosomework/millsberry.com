_global.degreesToRadians = function(num)
{
   return num * 3.141592653589793 / 180;
};
_global.radToDegrees = function(num)
{
   return num * 180 / 3.141592653589793;
};
_global.gClearAll = function()
{
   var _loc4_ = gList.clearAll.length;
   var _loc2_ = 0;
   var _loc3_;
   while(_loc2_ < _loc4_)
   {
      _loc3_ = gList.clearAll[_loc2_];
      _loc3_.removeMovieClip();
      _loc2_ = _loc2_ + 1;
   }
   _root.world.thisRock.removeMovieClip();
   _root.world.thisRock = undefined;
};
_global.makeRuler = function()
{
   _root.createEmptyMovieClip("ruler",9900);
   _root.ruler.lineStyle(0.5,16777215);
   _root.ruler.mouseIsDown = 0;
   _root.ruler.onMouseDown = function()
   {
      this.mouseIsDown = 1;
      this.startY = _root._ymouse;
      this.startX = _root._xmouse;
   };
   _root.ruler.onEnterFrame = function()
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if(Key.isDown(16))
      {
         this.clear();
         this.lineStyle(0.5,16777215);
         if(this.mouseIsDown == 1)
         {
            this.endY = _root._ymouse;
            this.endX = _root._xmouse;
            this.moveTo(this.startX,this.startY);
            this.lineTo(this.endX,this.endY);
            _loc3_ = this.endY - this.startY;
            _loc4_ = this.endX - this.startX;
            _loc5_ = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
         }
      }
   };
   _root.ruler.onMouseUp = function()
   {
      this.mouseIsDown = 0;
   };
};
