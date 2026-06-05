this.startTransitionToFinish = function()
{
   var _loc2_ = this;
   _loc2_.chipGraphic = _loc2_.chipMC;
   _loc2_.bgGraphic = _loc2_._parent;
   _loc2_.onEnterFrame = _loc2_.alphaUpChip;
};
this.alphaUpChip = function()
{
   var _loc2_ = this;
   var _loc3_ = 8;
   _loc2_.chipGraphic._aStep = _loc3_ + (100 - _loc2_.chipGraphic._alpha) / 10;
   _loc2_.chipGraphic._alpha += _loc2_.chipGraphic._aStep;
   if(_loc2_.chipGraphic._alpha >= 100)
   {
      _loc2_.onEnterFrame = alphaDownBG;
   }
};
this.alphaDownBG = function()
{
   var _loc2_ = this;
   var _loc3_ = -12;
   _loc2_.bgGraphic._aStep = _loc3_ - _loc2_.bgGraphic._alpha / 10;
   _loc2_.bgGraphic._alpha += _loc2_.bgGraphic._aStep;
   if(_loc2_.bgGraphic._alpha <= 0)
   {
      _loc2_.onEnterFrame = undefined;
      _loc2_.finishBios();
   }
};
