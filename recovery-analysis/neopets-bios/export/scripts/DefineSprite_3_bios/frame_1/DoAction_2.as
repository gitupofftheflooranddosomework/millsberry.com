this.finishBios = function()
{
   var _loc1_ = this;
   var _loc2_ = _root;
   var _loc3_ = _parent;
   trace("i say that this is " + _loc1_);
   trace("i say that _root is " + _loc2_);
   trace("i say that this._target) " + _loc1_._target);
   trace("talking with " + _loc1_._parent._name);
   trace("AND ROOT of " + _loc1_._parent._parent._name);
   trace("told parentparent to play");
   trace("--------------this----------------");
   for(var i in _loc1_)
   {
      trace(i + " == " + _loc1_[i]);
   }
   trace("--------------this._parent----------------");
   for(var i in _loc1_._parent)
   {
      trace(i + " == " + _loc1_._parent[i]);
   }
   trace("--------------_parent----------------");
   for(var i in _loc3_)
   {
      trace(i + " == " + _loc3_[i]);
   }
   trace("--------------this._parent._parent----------------");
   for(var i in _loc1_._parent._parent)
   {
      trace(i + " ==  " + _loc1_._parent._parent[i]);
   }
   trace("-------------_root-----------------");
   for(var i in _loc2_)
   {
      trace(i + " ==  " + _loc2_[i]);
   }
   trace("------------_root[\'_level0\']------------------");
   for(var i in _level0)
   {
      trace(i + " ==  " + _loc2_._level0[i]);
   }
   _loc1_.stop();
   _loc1_._parent._visible = 0;
   _loc1_._parent._parent.play();
};
