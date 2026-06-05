this.copyInProps = function()
{
   var _loc1_ = this;
   for(var _loc2_ in _loc1_._parent)
   {
      _loc1_[_loc2_] = _loc1_._parent[_loc2_];
   }
};
