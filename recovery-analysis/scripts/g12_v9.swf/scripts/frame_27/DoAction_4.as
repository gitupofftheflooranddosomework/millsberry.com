_global.blockObject = function()
{
};
blockObject.prototype = new MovieClip();
var obj = _global.blockObject.prototype;
obj.init = function(letter, row, col)
{
   var _loc1_ = this;
   _loc1_.taken = 0;
   _loc1_.letter = letter.toUpperCase();
   _loc1_.manualBox.text = _loc1_.letter;
   _loc1_.setXOutByCol = function(col)
   {
      this.oX = col * this._width;
   };
   _loc1_.setXOutByCol(col);
   _loc1_._x = _loc1_.oX;
   _loc1_._y = _loc1_.oy = row * _loc1_._height;
   _loc1_.finalX = "";
   _loc1_.finalY = _loc1_.oy - _loc1_._height;
   _loc1_.toggleButtonTo("on");
};
obj.setTakenTo = function(state)
{
   var _loc2_ = this;
   _loc2_.taken = state;
   var _loc1_;
   if(state == 1)
   {
      userWord += _loc2_.letter;
      _loc2_.setTargetTo("final",userWord.length - 1);
   }
   else
   {
      _loc1_ = userWord.length - 1;
      userWord = userWord.slice(0,_loc1_);
   }
};
obj.getTaken = function()
{
   return this.taken;
};
obj.setTargetTo = function(destination, row, movement)
{
   var _loc1_ = this;
   if(destination == "home")
   {
      _loc1_.targetX = _loc1_.oX;
      _loc1_.targetY = _loc1_.oY;
   }
   else if(destination == "final")
   {
      _loc1_.targetX = _loc1_.finalX + _loc1_._width * row;
      _loc1_.targetY = _loc1_.finalY;
   }
   _loc1_.toggleMoveTo("on",movement);
};
obj.toggleMoveTo = function(state, movement)
{
   var _loc1_ = this;
   _loc1_.state = state;
   if(_loc1_.state == "on")
   {
      if(movement == 0 or movement == undefined)
      {
         _loc1_._x = _loc1_.targetX;
         _loc1_._y = _loc1_.targetY;
      }
      else
      {
         _loc1_.bufferT = 3;
         _loc1_.distX = _loc1_._x - _loc1_.targetx;
         _loc1_.distY = _loc1_._y - _loc1_.targety;
         _loc1_.radians = Math.atan2(_loc1_.distY,_loc1_.distX) - 1.5707963267948966;
         _loc1_.onEnterFrame = function()
         {
            var _loc1_ = this;
            _loc1_.distX = _loc1_._x - _loc1_.targetx;
            _loc1_.distY = _loc1_._y - _loc1_.targety;
            _loc1_.distT = Math.sqrt(_loc1_.distX * _loc1_.distX + _loc1_.distY * _loc1_.distY);
            if(_loc1_.distT < _loc1_.bufferT)
            {
               _loc1_._x = _loc1_.targetX;
               _loc1_._y = _loc1_.targetY;
            }
            else
            {
               _loc1_.speed = 2 + _loc1_.distT / 3;
               _loc1_._x += _loc1_.speed * Math.sin(_loc1_.radians);
               _loc1_._y += _loc1_.speed * (- Math.cos(_loc1_.radians));
            }
         };
      }
   }
   else if(_loc1_.state == "off")
   {
      _loc1_.onPress = undefined;
   }
};
obj.toggleButtonTo = function(state)
{
   var _loc1_ = this;
   _loc1_.state = state;
   if(_loc1_.state == "on")
   {
      _loc1_.onPress = function()
      {
         var _loc1_ = this;
         var _loc2_;
         var _loc3_;
         if(_loc1_.taken == 0)
         {
            _loc2_ = _loc1_._parent;
            _loc2_.userInput(_loc1_.letter,"mouse");
            _loc2_.takenLetterList.push(_loc1_);
            _loc1_.setTakenTo(1);
         }
         else
         {
            _loc2_ = _loc1_._parent;
            _loc3_ = _loc2_.takenLetterList;
            var list_end = _loc3_[_loc3_.length - 1];
            if(list_end == _loc1_)
            {
               _loc2_.backSpaceKey();
            }
         }
      };
   }
   else if(_loc1_.state == "off")
   {
      _loc1_.onPress = undefined;
   }
};
obj.onGameEnd = function()
{
   this.setTargetTo("home");
};
Object.registerClass("blockMC",blockObject);
