this.addProtoCode = function()
{
   Object.prototype.toString = function(indentSpacesPerLevel, level)
   {
      var _loc1_ = level;
      var _loc2_ = indentSpacesPerLevel;
      var formatLevel = function(indentSpacesPerLevel, level)
      {
         var _loc3_ = indentSpacesPerLevel * level;
         var _loc2_ = "";
         var _loc1_;
         if(_loc3_ > 0)
         {
            _loc2_ += "\n";
            _loc1_ = 1;
            while(_loc1_ < _loc3_)
            {
               _loc2_ += " ";
               _loc1_ = _loc1_ + 1;
            }
         }
         else
         {
            _loc2_ = "";
         }
         return _loc2_;
      };
      if(_loc1_ == undefined)
      {
         _loc1_ = 1;
      }
      var _loc3_ = "";
      var listI = [];
      for(var i in this)
      {
         listI.push(String(i));
      }
      if(listI.length < 1)
      {
         _loc3_ += "{}";
      }
      else
      {
         _loc3_ += formatLevel(_loc2_,_loc1_) + "{" + formatLevel(_loc2_,_loc1_);
      }
      for(var i in this)
      {
         var nextContent = this[i];
         if(typeof nextContent == "object")
         {
            _loc3_ += i + ":";
            _loc3_ += nextContent.toString(_loc2_,_loc1_ = _loc1_ + 1);
            if(i != listI[listI.length - 1])
            {
               _loc3_ += formatLevel(_loc2_,_loc1_--) + "}," + formatLevel(_loc2_,_loc1_);
            }
            else
            {
               _loc3_ += formatLevel(_loc2_,_loc1_--) + "}";
               if(_loc1_ == 1)
               {
                  _loc3_ += formatLevel(_loc2_,_loc1_) + "}" + formatLevel(_loc2_,_loc1_);
               }
            }
         }
         else
         {
            _loc3_ += i + ":" + this[i];
            if(i != listI[listI.length - 1])
            {
               _loc3_ += "," + formatLevel(_loc2_,_loc1_);
            }
            else if(_loc1_ == 1)
            {
               _loc3_ += formatLevel(_loc2_,_loc1_) + "}" + formatLevel(_loc2_,_loc1_);
            }
         }
      }
      return String(_loc3_);
   };
};
