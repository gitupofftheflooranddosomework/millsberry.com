_global.wordBankObject = function()
{
};
wordBankObject.prototype = new MovieClip();
var obj = _global.wordBankObject.prototype;
obj.init = function()
{
   this._x = Screen.centerX;
   this._y = Screen.yMax;
};
obj.layout = function()
{
   this.wordList = new Array();
   var _loc2_ = 0;
   var col = 0;
   var arrayLength = Game.puzzle.subset.length;
   var maxCol = 3;
   var maxRow = 8;
   var _loc1_ = 0;
   var _loc3_;
   while(_loc1_ < arrayLength)
   {
      _loc2_ = _loc2_ + 1;
      if(_loc2_ > maxRow)
      {
         _loc2_ = 1;
         col++;
      }
      var word = Game.puzzle.subset[_loc1_].subWord;
      var sourceName = "wordMC";
      var targetName = "word" + _loc1_;
      var depthNum = _loc1_ + 1;
      this.attachMovie(sourceName,targetName,depthNum);
      _loc3_ = this[targetName];
      _loc3_.init(word,_loc2_,col);
      this.wordList.push(_loc3_);
      _loc1_ = _loc1_ + 1;
   }
   this.center();
};
obj.center = function()
{
   var _loc1_ = this;
   _loc1_._x = Screen.centerX - _loc1_._width / 2;
   _loc1_._y = _root.game_bg._y + _root.game_bg._height + 8;
};
Object.registerClass("wordBankMC",wordBankObject);
