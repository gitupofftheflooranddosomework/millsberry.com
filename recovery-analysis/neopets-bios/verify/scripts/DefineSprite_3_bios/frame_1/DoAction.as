this.addProtoCode = function()
{
   Object.prototype.toString = function(indentSpacesPerLevel, level)
   {
      var _loc2_ = level;
      var _loc3_ = indentSpacesPerLevel;
      var _loc4_ = function(indentSpacesPerLevel, level)
      {
         var _loc3_ = indentSpacesPerLevel * level;
         var _loc4_ = "";
         var _loc5_;
         if(_loc3_ > 0)
         {
            _loc4_ += "\n";
            _loc5_ = 1;
            while(_loc5_ < _loc3_)
            {
               _loc4_ += " ";
               _loc5_ += 1;
            }
         }
         else
         {
            _loc4_ = "";
         }
         return _loc4_;
      };
      if(_loc2_ == undefined)
      {
         _loc2_ = 1;
      }
      var _loc5_ = "";
      var _loc6_ = [];
      for(var _loc7_ in this)
      {
         _loc6_.push(String(_loc7_));
      }
      if(_loc6_.length < 1)
      {
         _loc5_ += "{}";
      }
      else
      {
         _loc5_ += _loc4_(_loc3_,_loc2_) + "{" + _loc4_(_loc3_,_loc2_);
      }
      var _loc8_;
      for(_loc7_ in this)
      {
         _loc8_ = this[_loc7_];
         if(typeof _loc8_ == "object")
         {
            _loc5_ += _loc7_ + ":";
            _loc5_ += _loc8_.toString(_loc3_,_loc2_ += 1);
            if(_loc7_ != _loc6_[_loc6_.length - 1])
            {
               _loc5_ += _loc4_(_loc3_,_loc2_--) + "}," + _loc4_(_loc3_,_loc2_);
            }
            else
            {
               _loc5_ += _loc4_(_loc3_,_loc2_--) + "}";
               if(_loc2_ == 1)
               {
                  _loc5_ += _loc4_(_loc3_,_loc2_) + "}" + _loc4_(_loc3_,_loc2_);
               }
            }
         }
         else
         {
            _loc5_ += _loc7_ + ":" + this[_loc7_];
            if(_loc7_ != _loc6_[_loc6_.length - 1])
            {
               _loc5_ += "," + _loc4_(_loc3_,_loc2_);
            }
            else if(_loc2_ == 1)
            {
               _loc5_ += _loc4_(_loc3_,_loc2_) + "}" + _loc4_(_loc3_,_loc2_);
            }
         }
      }
      return String(_loc5_);
   };
};
