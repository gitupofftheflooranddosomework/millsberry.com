_global.wordObject = function()
{
};
wordObject.prototype = new MovieClip();
var obj = _global.wordObject.prototype;
obj.init = function(word, row, col)
{
   var _loc2_ = this;
   var w = 16 * Game.maxWordLength;
   var h = 18;
   _loc2_._x = (col - 1) * w;
   _loc2_._y = (row - 1) * h;
   _loc2_.word = word;
   _loc2_.letterList = new Array();
   _loc2_.numTiles = _loc2_.word.length;
   var _loc1_ = 0;
   var _loc3_;
   while(_loc1_ < _loc2_.numTiles)
   {
      var letter = _loc2_.word.charAt(_loc1_);
      var sourceName = "tileMC";
      var targetName = "tile" + _loc1_;
      var depthNum = _loc1_ + 1;
      _loc2_.attachMovie(sourceName,targetName,depthNum);
      _loc3_ = _loc2_[targetName];
      var row = 1;
      var col = _loc1_;
      _loc3_.init(letter,row,col);
      _loc2_.letterList.push(_loc3_);
      _loc2_.showMyWord(0);
      _loc1_ = _loc1_ + 1;
   }
};
obj.showMyWord = function(pValue)
{
   var _loc3_ = this;
   _loc3_.shown = pValue;
   var _loc1_ = 0;
   var _loc2_;
   while(_loc1_ < _loc3_.numTiles)
   {
      _loc2_ = _loc3_["tile" + _loc1_];
      _loc2_.toggleLetter(pValue);
      _loc1_ = _loc1_ + 1;
   }
};
Object.registerClass("wordMC",wordObject);
