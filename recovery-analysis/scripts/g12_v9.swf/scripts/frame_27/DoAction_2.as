_global.markSpotIn = function(mc, x, y)
{
   var _loc2_ = _root;
   _loc2_.depth.markedSpot++;
   mc.attachMovie("markMC","mark" + _loc2_.depth.markedSpot,_loc2_.depth.markedSpot);
   var _loc1_ = mc["mark" + _loc2_.depth.markedSpot];
   _loc1_._x = x;
   _loc1_._y = y;
};
