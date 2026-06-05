_global.puzzleObject = function()
{
};
var obj = _global.puzzleObject.prototype;
obj.init = function()
{
   var _loc1_ = this;
   var _loc3_;
   var _loc2_;
   do
   {
      if(_root.ROUND.show() == 1 and Game.specialWords.length > 0)
      {
         _loc3_ = 0;
      }
      else
      {
         _loc3_ = random(3);
      }
      if(_loc3_ < 2)
      {
         Game.puzzleType = "SPECIAL";
         var special_length = Game.specialWords.length;
         _loc2_ = random(special_length - 1);
         _loc1_.word = Game.specialWords[_loc2_];
         Game.specialWords.splice(_loc2_);
         _loc1_.subset = Game[_loc1_.word + "_List"];
      }
      else
      {
         Game.puzzleType = "DICTIONARY";
         do
         {
            _loc1_.word = myDictionary.getRandomWord(Game.maxWordLength);
         }
         while(myDictionary.isANeopianWord(_loc1_.word));
         _loc1_.subset = myDictionary.getSubSet(_loc1_.word);
      }
   }
   while(_loc1_.subset.length < 9 or _loc1_.subset.length > 37);
   _loc1_.subset = _loc1_.arrayOfObject(_loc1_.subset);
   _loc1_.scrambledWord = myDictionary.doScramble(_loc1_.word);
   _loc1_.subset = _loc1_.sortByLengthAndAlphabet(_loc1_.subset);
   _loc1_.maxNumPts = _loc1_.calculateValueOfSubset(_loc1_.subSet);
};
obj.center = function()
{
   var _loc1_ = this;
   _loc1_._x = Screen.centerX - _loc1_._width / 2;
};
obj.calculateValueOfSubset = function(pSubSet)
{
   var totalValue = 0;
   var max = pSubSet.length;
   var _loc1_ = 0;
   var _loc3_;
   var _loc2_;
   while(_loc1_ < max)
   {
      _loc3_ = pSubSet[_loc1_];
      var word_length = _loc3_.subWord.length;
      _loc2_ = Game.returnWordValues(word_length);
      totalValue += _loc2_;
      _loc1_ = _loc1_ + 1;
   }
   var roundNum = Math.round(totalValue);
   return roundNum;
};
obj.sortByLengthAndAlphabet = function(arrayTemp)
{
   var _loc1_ = new Array();
   var _loc2_ = 0;
   while(_loc2_ < arrayTemp.length)
   {
      var word = arrayTemp[_loc2_];
      var l = word.length;
      if(_loc1_[l] == undefined)
      {
         _loc1_[l] = new Array();
      }
      _loc1_[l].push(word);
      _loc2_ = _loc2_ + 1;
   }
   var arrayFinal = new Array();
   _loc2_ = 0;
   var _loc3_;
   while(_loc2_ < _loc1_.length)
   {
      if(_loc1_[_loc2_] != undefined)
      {
         _loc1_[_loc2_].sort();
         _loc3_ = _loc1_[_loc2_].length - 1;
         while(_loc3_ >= 0)
         {
            var wrd_final = _loc1_[_loc2_][_loc3_];
            arrayFinal.push({subWord:wrd_final,already_answered:0});
            _loc3_ = _loc3_ - 1;
         }
      }
      _loc2_ = _loc2_ + 1;
   }
   return arrayFinal;
};
obj.arrayOfObject = function(obj)
{
   var _loc3_ = obj;
   var temp_array = [];
   var _loc1_;
   var _loc2_;
   for(var i in _loc3_)
   {
      _loc1_ = _loc3_[i];
      if(_loc1_.length > 1 && !_root.myDictionary.isANeopianWord(_loc1_))
      {
         _loc2_ = _loc1_.toUpperCase();
         temp_array.push(_loc2_);
      }
   }
   return temp_array;
};
