userProfile = function(requestArray)
{
   var _loc1_ = this;
   _loc1_.getHelp = function()
   {
      var _loc3_ = this;
      var _loc2_ = "";
      _loc2_ += "USERPROFILE.getHelp()\n";
      _loc2_ += "------------------------\n";
      _loc2_ += "CONSTRUCTOR\n";
      _loc2_ += "        myUserProfile = new UserProfile(requestArray) // pass an array of propNumbers for needed info\n";
      _loc2_ += "PUBLIC METHODS\n";
      _loc2_ += "        getHelp()\n";
      _loc2_ += "        getProp(propNumber)\n";
      _loc2_ += "        getPercentComplete()\n";
      _loc2_ += "                PARAMETERS (propNumber)\n";
      var _loc1_ = 0;
      while(_loc1_ < _loc3_.possibleProps.length)
      {
         _loc2_ += "                        " + _loc3_.possibleProps[_loc1_] + " = " + (_loc1_ + 1) + "\n";
         _loc1_ = _loc1_ + 1;
      }
      return _loc2_;
   };
   _loc1_.requestArray = requestArray;
   _loc1_.possibleProps = ["scores_sent","high_score","user_age","user_gender","pet1_name","pet1_color","pet1_species","user_full_name","user_email","user_country","user_dob","pet2_name","pet3_name","pet4_name"];
   _loc1_.levelNum = 110;
   if(_root._level0.id == undefined)
   {
      _loc1_.game_id = 7;
   }
   else
   {
      _loc1_.game_id = _level0.game_id;
   }
   var typeString = "";
   var tArrayLength_num = _loc1_.requestArray.length;
   var _loc3_ = 0;
   while(_loc3_ < tArrayLength_num)
   {
      typeString += _loc1_.requestArray[_loc3_] + ";";
      _loc3_ = _loc3_ + 1;
   }
   _loc1_.url = "http://www.neopets.com/high_scores/fg_get_info.phtml?game_id=" + _loc1_.game_id + "&type=" + typestring;
   loadVariablesNum(_loc1_.url,_loc1_.levelNum);
   _loc1_.getPercentComplete = function()
   {
      var _loc2_ = this;
      var _loc1_ = 0;
      while(_loc1_ < _loc2_.possibleProps.length)
      {
         if(_loc2_.getProp(_loc1_) != -1 && _loc2_.getProp(_loc1_) != "-1")
         {
            return 100;
         }
         _loc1_ = _loc1_ + 1;
      }
      return -1;
   };
   _loc1_.getProp = function(tRequest)
   {
      var _loc2_ = this;
      var _loc3_ = tRequest;
      if(isNan(_loc3_) == true)
      {
         return _root["_level" + _loc2_.levelNum][_loc3_];
      }
      propIndex = _loc3_;
      var _loc1_ = _root["_level" + _loc2_.levelNum][_loc2_.possibleProps[propIndex - 1]];
      if(_loc1_ == undefined)
      {
         return -1;
      }
      return _loc1_;
   };
};
