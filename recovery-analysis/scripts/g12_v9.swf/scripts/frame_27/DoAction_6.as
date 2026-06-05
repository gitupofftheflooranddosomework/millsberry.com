_global.tileObject = function()
{
};
tileObject.prototype = new MovieClip();
var obj = _global.tileObject.prototype;
obj.init = function(letter, row, col)
{
   var _loc1_ = this;
   _loc1_.letter = letter;
   _loc1_.manualBox.text = "";
   _loc1_._x = col * _loc1_._width;
   _loc1_._y = (row - 1) * _loc1_._height;
};
obj.toggleLetter = function(pValue)
{
   var _loc1_ = this;
   if(pValue)
   {
      _loc1_.manualBox.text = _loc1_.letter;
      _loc1_.gotoAndStop("normalState");
   }
   else
   {
      _loc1_.manualBox.text = "";
   }
};
Object.registerClass("tileMC",tileObject);
