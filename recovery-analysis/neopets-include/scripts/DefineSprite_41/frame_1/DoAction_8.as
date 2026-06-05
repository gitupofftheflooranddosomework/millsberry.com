Dictionary.prototype.getContainedWordByType = function(userString, wordType)
{
   var userString = String(userString);
   var firstChar = 0;
   var lastChar = userString.length;
   var _loc3_ = [];
   var _loc2_ = firstChar;
   var _loc1_;
   while(_loc2_ <= lastChar)
   {
      _loc1_ = _loc2_ + 1;
      while(_loc1_ <= lastChar)
      {
         _loc3_.push(userString.slice(_loc2_,_loc1_));
         _loc1_ = _loc1_ + 1;
      }
      _loc2_ = _loc2_ + 1;
   }
   var arrayOfWords = [];
   if(wordType == 1 or wordType == 2)
   {
      for(var word in _loc3_)
      {
         var wordToCheck = _loc3_[word];
         var catagoryType = this.catagorizeWord(wordToCheck);
         if(catagoryType == wordType)
         {
            arrayOfWords.push(wordToCheck);
         }
      }
   }
   else if(wordType == undefined)
   {
      for(var word in _loc3_)
      {
         var wordToCheck = _loc3_[word];
         var catagoryType = this.catagorizeWord(wordToCheck);
         if(catagoryType > 0)
         {
            arrayOfWords.push(wordToCheck);
         }
      }
   }
   return arrayOfWords;
};
Dictionary.prototype.getContainedWords = function(userString)
{
   var _loc1_;
   return this.getContainedWordByType(userString,_loc1_);
};
Dictionary.prototype.getContainedDictionaryWords = function(userString)
{
   var _loc1_ = 1;
   return this.getContainedWordByType(userString,_loc1_);
};
Dictionary.prototype.getContainedNeopianWords = function(userString)
{
   var _loc1_ = 2;
   return this.getContainedWordByType(userString,_loc1_);
};
