this.startTransitionToFinish = function()
{
   var _loc1_ = this;
   _loc1_.chipGraphic = _loc1_.chipMC;
   _loc1_.bgGraphic = _loc1_._parent;
   trace("-------------START MOVING  " + _loc1_.chipGraphic);
   trace("---------and  START MOVING " + _loc1_.bgGraphic);
   _loc1_.onEnterFrame = _loc1_.alphaUpChip;
};
this.alphaUpChip = function()
{
   var _loc1_ = this;
   _loc1_.chipGraphic._aStep = 4 + (100 - _loc1_.chipGraphic._alpha) / 10;
   _loc1_.chipGraphic._alpha += _loc1_.chipGraphic._aStep;
   if(_loc1_.chipGraphic._alpha >= 100)
   {
      _loc1_.onEnterFrame = alphaDownBG;
   }
};
this.alphaDownBG = function()
{
   var _loc1_ = this;
   _loc1_.bgGraphic._aStep = -1 - _loc1_.bgGraphic._alpha / 10;
   _loc1_.bgGraphic._alpha += _loc1_.bgGraphic._aStep;
   if(_loc1_.bgGraphic._alpha <= 0)
   {
      _loc1_.onEnterFrame = undefined;
      _loc1_.finishBios();
   }
};
