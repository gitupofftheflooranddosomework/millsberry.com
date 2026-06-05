this.finishBios = function()
{
   var _loc4_ = this;
   var _loc5_ = _root;
   var _loc6_ = _parent;
   trace("i say that this is " + _loc4_);
   trace("i say that _root is " + _loc5_);
   trace("i say that this._target) " + _loc4_._target);
   trace("talking with " + _loc4_._parent._name);
   trace("AND ROOT of " + _loc4_._parent._parent._name);
   trace("told parentparent to play");
   trace("--------------this----------------");
   for(var _loc7_ in _loc4_)
   {
      trace(_loc7_ + " == " + _loc4_[_loc7_]);
   }
   trace("--------------this._parent----------------");
   for(_loc7_ in _loc4_._parent)
   {
      trace(_loc7_ + " == " + _loc4_._parent[_loc7_]);
   }
   trace("--------------_parent----------------");
   for(_loc7_ in _loc6_)
   {
      trace(_loc7_ + " == " + _loc6_[_loc7_]);
   }
   trace("--------------this._parent._parent----------------");
   for(_loc7_ in _loc4_._parent._parent)
   {
      trace(_loc7_ + " ==  " + _loc4_._parent._parent[_loc7_]);
   }
   trace("-------------_root-----------------");
   for(_loc7_ in _loc5_)
   {
      trace(_loc7_ + " ==  " + _loc5_[_loc7_]);
   }
   trace("------------_root[\'_level0\']------------------");
   for(_loc7_ in _level0)
   {
      trace(_loc7_ + " ==  " + _loc5_._level0[_loc7_]);
   }
   _loc4_.stop();
   _loc4_._parent._visible = 0;
   _loc4_._parent._parent.play();
};
