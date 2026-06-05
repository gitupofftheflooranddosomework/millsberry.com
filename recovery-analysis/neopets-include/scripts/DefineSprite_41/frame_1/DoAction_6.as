Object.prototype.getDuplicate = function()
{
   var _loc1_ = this;
   ASSetPropFlags(Object.prototype,["getDuplicate"],1);
   var _loc2_ = new _loc1_.__proto__.constructor(_loc1_);
   for(var _loc3_ in _loc1_)
   {
      _loc2_[_loc3_] = _loc1_[_loc3_].getDuplicate();
   }
   return _loc2_;
};
obj.object.getDuplicate = Object.prototype.getDuplicate;
ASSetPropFlags(Object.prototype,["getDuplicate"],1);
