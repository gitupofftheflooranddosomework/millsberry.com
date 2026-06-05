obj.object.toString = function(indentSpacesPerLevel, level)
{
   var _loc1_ = level;
   var _loc3_ = indentSpacesPerLevel;
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
   var _loc2_ = "";
   var listI = [];
   for(var i in this)
   {
      listI.push(String(i));
   }
   _loc2_ += formatLevel(_loc3_,_loc1_) + "{" + formatLevel(_loc3_,_loc1_);
   for(var i in this)
   {
      var nextContent = this[i];
      if(typeof nextContent == "object")
      {
         if(nextContent.length != undefined)
         {
            _loc2_ += i + ":" + "[";
            _loc2_ += nextContent.toString(_loc3_,_loc1_ = _loc1_ + 1);
            if(i != listI[listI.length - 1])
            {
               _loc2_ += "]," + formatLevel(_loc3_,_loc1_ = _loc1_ - 1);
            }
            else
            {
               _loc2_ += "]" + formatLevel(_loc3_,_loc1_ = _loc1_ - 1);
               if(_loc1_ == 1)
               {
                  _loc2_ += "}" + formatLevel(_loc3_,_loc1_);
               }
            }
         }
         else
         {
            _loc2_ += i + ":";
            _loc2_ += nextContent.toString(_loc3_,_loc1_ = _loc1_ + 1);
            if(i != listI[listI.length - 1])
            {
               _loc2_ += formatLevel(_loc3_,_loc1_--) + "}," + formatLevel(_loc3_,_loc1_);
            }
            else
            {
               _loc2_ += formatLevel(_loc3_,_loc1_--) + "}";
               if(_loc1_ == 1)
               {
                  _loc2_ += formatLevel(_loc3_,_loc1_) + "}" + formatLevel(_loc3_,_loc1_);
               }
            }
         }
      }
      else
      {
         if(typeof nextContent == "string")
         {
            _loc2_ += i + ":\'" + nextContent + "\'";
         }
         else
         {
            _loc2_ += i + ":" + nextContent;
         }
         if(i != listI[listI.length - 1])
         {
            _loc2_ += "," + formatLevel(_loc3_,_loc1_);
         }
         else if(_loc1_ == 1)
         {
            _loc2_ += formatLevel(_loc3_,_loc1_) + "}" + formatLevel(_loc3_,_loc1_);
         }
      }
   }
   if(_loc1_ == 1 and _loc2_.length == 1)
   {
      _loc2_ += "}";
   }
   return String(_loc2_);
};
