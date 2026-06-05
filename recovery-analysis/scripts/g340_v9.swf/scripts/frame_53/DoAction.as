_global.gPauseGame = function(val)
{
   var _loc6_ = gList.actorList.length;
   var _loc4_ = 0;
   var _loc3_;
   while(_loc4_ < _loc6_)
   {
      _loc3_ = gList.actorList[_loc4_];
      if(!_loc3_.dying)
      {
         if(val == 0)
         {
            _loc3_.onEnterFrame = _loc3_.tempEFC;
         }
         else
         {
            _loc3_.tempEFC = _loc3_.onEnterFrame;
            _loc3_.onEnterFrame = undefined;
         }
      }
      _loc4_ = _loc4_ + 1;
   }
   _root.world.paused = val;
   if(val == 0)
   {
      _global.translator.addTextField(_root.world.sb.tPauseText,{htmlText:_level0.IDS_pause});
   }
   else
   {
      _global.translator.addTextField(_root.world.sb.tPauseText,{htmlText:_level0.IDS_play});
   }
};
_global.gGetOddEvenNum = function()
{
   var _loc1_ = random(2);
   if(_loc1_ == 0)
   {
      return -1;
   }
   return 1;
};
Array.prototype.removeClips = function()
{
   var _loc3_ = this.length;
   var _loc2_ = 0;
   while(_loc2_ < _loc3_)
   {
      this[_loc2_].removeMovieClip();
      _loc2_ = _loc2_ + 1;
   }
   this.splice(0);
};
MovieClip.prototype.removeItem = function(pList)
{
   var _loc5_ = pList.length;
   var _loc2_ = 0;
   var _loc3_;
   while(_loc2_ < _loc5_)
   {
      _loc3_ = pList[_loc2_];
      if(_loc3_ == this)
      {
         pList.splice(_loc2_,1);
      }
      _loc2_ = _loc2_ + 1;
   }
};
MovieClip.prototype.rewind = function()
{
   if(this._currentframe != 1)
   {
      this.gotoAndStop(this._currentframe - 1);
   }
};
Object.prototype.getDistance = function(pTarget_X, pTarget_Y)
{
   var _loc3_ = pTarget_X - this._x;
   var _loc2_ = pTarget_Y - this._y;
   var _loc4_ = Math.sqrt(_loc3_ * _loc3_ + _loc2_ * _loc2_);
   return _loc4_;
};
Object.prototype.getAngle = function(pTarget_X, pTarget_Y)
{
   var _loc3_ = pTarget_X - this._x;
   var _loc2_ = pTarget_Y - this._y;
   var _loc4_ = Math.atan2(_loc2_,_loc3_);
   return _loc4_;
};
