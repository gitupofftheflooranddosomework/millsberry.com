class np.projects.include.EvarClass
{
   var aEvar;
   function EvarClass(xVar, cName)
   {
      var _loc1_ = this;
      _loc1_.aEvar = [];
      _loc1_.cDesc = cName;
      _loc1_.create(xVar);
   }
   function create(xVar)
   {
      var _loc2_ = xVar;
      this.aEvar = [];
      var _local5 = [];
      var _local6 = typeof _loc2_;
      var _loc3_;
      var _loc1_;
      if(_local6.toLowerCase() == "string")
      {
         _local5.push(0);
         _loc3_ = [];
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            _loc3_.push(_loc2_.charCodeAt(_loc1_));
            _loc1_ = _loc1_ + 1;
         }
         _local5.push(_loc3_);
      }
      else if(_local6.toLowerCase() == "number")
      {
         _local5.push(11 + random(89));
         _local5.push(_loc2_ * _local5[0]);
      }
      this.aEvar.push(_local5);
   }
   function changeTo(xVar)
   {
      this.create(xVar);
   }
   function changeBy(xValue)
   {
      var _loc2_ = xValue;
      var _loc3_ = this;
      var _loc1_;
      if(_loc3_.aEvar[0][0] > 0)
      {
         _loc3_.aEvar[0][1] += _loc3_.aEvar[0][0] * _loc2_;
      }
      else
      {
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            _loc3_.aEvar[0][1].push(_loc2_.charCodeAt(_loc1_));
            _loc1_ = _loc1_ + 1;
         }
      }
   }
   function show()
   {
      var _loc3_ = this;
      if(_loc3_.aEvar[0][0] > 0)
      {
         return _loc3_.aEvar[0][1] / _loc3_.aEvar[0][0];
      }
      var _loc2_ = "";
      var _loc1_ = 0;
      while(_loc1_ < _loc3_.aEvar[0][1].length)
      {
         _loc2_ += String.fromCharCode(_loc3_.aEvar[0][1][_loc1_]);
         _loc1_ = _loc1_ + 1;
      }
      return _loc2_;
   }
}
