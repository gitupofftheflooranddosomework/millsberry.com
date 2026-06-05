passWord = function(initialPassWord, optionalKey)
{
   var _loc1_ = this;
   var initialPassWord = String(initialPassWord).toUpperCase();
   _loc1_.getHelp = function()
   {
      var _loc1_ = "";
      _loc1_ += "\n";
      _loc1_ += "PASSWORD.getHelp()\n";
      _loc1_ += "------------------------\n";
      _loc1_ += "CONSTRUCTOR\n";
      _loc1_ += "\tmyPassWord = new PassWord(initialPassWord [,key])\t//initialPassWord - capitalized string to encrypt, key - optional, capitalized alphanumeric string\n";
      _loc1_ += "PUBLIC METHODS\n";
      _loc1_ += "\tgetHelp()\n";
      _loc1_ += "\tgetEncrypted()\n";
      _loc1_ += "\tgetDecrypted()\n";
      return _loc1_;
   };
   _loc1_.lengthOfAllCharCodes = function(key)
   {
      var _loc3_ = String(key);
      var kLength = _loc3_.length;
      var _loc2_ = 0;
      var _loc1_ = 0;
      while(_loc1_ < kLength)
      {
         _loc2_ += _loc3_.charCodeAt(_loc1_);
         _loc1_ = _loc1_ + 1;
      }
      return _loc2_;
   };
   _loc1_.initEncryption = function(username, optionalKey)
   {
      var _loc1_ = this;
      var _loc2_ = username;
      var _loc3_ = _root;
      if(optionalKey == undefined)
      {
         if(_loc3_._level0.id == undefined)
         {
            id = 7;
         }
         else
         {
            id = _loc3_._level0.id;
         }
         if(_loc3_._level0.username == undefined)
         {
            _loc2_ = "INCLUDE_USERNAME";
         }
         else
         {
            _loc2_ = _loc3_._level0.username;
         }
         _loc1_.key = String(_loc2_).toUpperCase();
         _loc1_.maxCharCodeShifts = Number(String(_loc2_).length + _loc1_.lengthOfAllCharCodes(_loc1_.key) + Number(id));
      }
      else
      {
         _loc1_.key = String(optionalKey).toUpperCase();
         _loc1_.maxCharCodeShifts = Number(String(_loc1_.key).length + _loc1_.lengthOfAllCharCodes(_loc1_.key));
      }
      _loc1_.OriginalSwapArray = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
      _loc1_.swapArray = _loc1_.OriginalSwapArray;
      _loc1_.charCodeShifts = Math.max(1,_loc1_.maxCharCodeShifts % _loc1_.swapArray.length);
   };
   _loc1_.initEncryption(username,optionalKey);
   _loc1_.setTo = function(string)
   {
      this.value = String(string);
   };
   _loc1_.setTo(initialPassWord);
   _loc1_.getEncrypted = function()
   {
      var _loc1_ = this;
      return _loc1_.getShiftedString(_loc1_.value,_loc1_.charCodeShifts);
   };
   _loc1_.getDecrypted = function()
   {
      var _loc1_ = this;
      return _loc1_.getShiftedString(_loc1_.value,- _loc1_.charCodeShifts);
   };
   _loc1_.getShiftedString = function(sourceString, shiftNum)
   {
      var targetString;
      var _loc1_ = 0;
      var _loc2_;
      var _loc3_;
      while(_loc1_ < sourceString.length)
      {
         _loc2_ = sourceString.charAt(_loc1_);
         _loc3_ = this.getShiftedChar(_loc2_,shiftNum,_loc1_);
         targetString += _loc3_;
         _loc1_ = _loc1_ + 1;
      }
      return targetString;
   };
   _loc1_.getShiftedChar = function(sourceChar, shiftNum, passWordIndex)
   {
      var _loc1_ = this;
      var _loc3_;
      for(var l in _loc1_.swapArray)
      {
         if(sourceChar.toUpperCase() == _loc1_.swapArray[l])
         {
            _loc3_ = Number(l);
            break;
         }
      }
      var _loc2_;
      if(shiftNum > 0)
      {
         _loc2_ = shiftNum + _loc3_ + passWordIndex;
         while(_loc2_ >= _loc1_.swapArray.length)
         {
            _loc2_ -= _loc1_.swapArray.length;
         }
      }
      else if(shiftNum < 0)
      {
         _loc2_ = shiftNum + _loc3_ - passWordIndex;
         while(_loc2_ < 0)
         {
            _loc2_ += _loc1_.swapArray.length;
         }
      }
      else
      {
         correctedShiftNum = shiftNum;
      }
      var targetChar = _loc1_.swapArray[_loc2_];
      return targetChar;
   };
};
