_global.ScrollingBGClass = function(pX, pY, pSpeed)
{
   this.init(pX,pY,pSpeed);
};
ScrollingBGClass.extend(SpriteClass);
var obj = ScrollingBGClass.prototype;
obj.init = function(pX, pY, pSpeed)
{
   super.init(pX,pY);
   this.pWidth = Math.floor(this._width);
   this.pSpeed = pSpeed;
};
obj.onEnterFrame = function()
{
   this._x -= this.pSpeed;
   var _loc2_ = this._x + this.pWidth;
   if(_loc2_ <= 0)
   {
      this._x = this.pWidth + _loc2_;
   }
};
