function clearScreen()
{
   var _loc1_ = _root;
   _loc1_.ball.removeMovieClip();
   rows = 1;
   while(rows < 8)
   {
      cols = 1;
      while(cols < 7 + (rows + 1) % 2)
      {
         _loc1_["prong_" + rows + "_" + cols].removeMovieClip();
         cols++;
      }
      rows++;
   }
   slots = 1;
   while(slots <= 7)
   {
      _loc1_["slot" + slots].removeMovieClip();
      slots++;
   }
   balls = 1;
   while(balls <= _loc1_.ballNum)
   {
      _loc1_["ball" + balls].removeMovieClip();
      balls++;
   }
   _loc1_.endGameMessage.removeMovieClip();
}
function checkMouse()
{
   var _loc1_ = _root;
   if(_loc1_.ball._ymouse > _loc1_.prong_7_1._y)
   {
      _loc1_.ball.stopDrag();
   }
   else if(_loc1_.ball._y <= 22 && !_loc1_.dropping)
   {
      _loc1_.ball.startDrag(true,_loc1_.prong_2_1._x,20,_loc1_.prong_2_7._x,20);
   }
}
function placeProngs()
{
   var _loc1_ = _root;
   rows = 1;
   while(rows < 8)
   {
      cols = 1;
      while(cols < 7 + (rows + 1) % 2)
      {
         prongName = "prong_" + rows + "_" + cols;
         _loc1_.attachMovie("prong",prongName,200 + rows * 10 + cols);
         _loc1_[prongName]._x = hstart + hspacing * cols + hspacing / 2 * (rows % 2);
         _loc1_[prongName]._y = vstart + vspacing * rows;
         _loc1_[prongName].row = rows;
         _loc1_[prongName].col = cols;
         cols++;
      }
      rows++;
   }
   slots = 1;
   while(slots <= 7)
   {
      _loc1_.attachMovie("slot","slot" + slots,190 + slots);
      _loc1_["slot" + slots]._x = hstart + hspacing * slots;
      _loc1_["slot" + slots]._y = vstart + vspacing * 7 + _loc1_["slot" + slots]._height / 2;
      _loc1_["slot" + slots].slotText.gotoAndStop(slots);
      slots++;
   }
   _loc1_.cerealCounter.gotoAndStop(8);
}
function placeBall()
{
   var _loc1_ = _root;
   _loc1_.ballNum = _loc1_.ballNum + 1;
   _loc1_.attachMovie("ball","ball",300 + _loc1_.ballNum);
   _loc1_.ball.ballNum = _loc1_.ballNum;
   _loc1_.ball.startDrag(true,_loc1_.prong_2_1._x,20,_loc1_.prong_2_7._x,20);
   _loc1_.ball.onMouseDown = function()
   {
      if(!_root.overEndGame)
      {
         _root.dropBall();
      }
   };
   _loc1_.ball.onMouseMove = function()
   {
      _root.checkMouse();
   };
}
function dropBall()
{
   var _loc1_ = _root;
   if(_loc1_.cerealCounter._currentframe > 1)
   {
      _loc1_.cerealCounter.prevFrame();
   }
   else
   {
      _loc1_.cerealCounter._visible = false;
   }
   _loc1_.ball.onMouseDown = function()
   {
   };
   _loc1_.ball.stopDrag();
   _loc1_.dropping = true;
   _loc1_.speed = 0;
   _loc1_.ball.row = 1;
   _loc1_.ball.col = Math.round((_loc1_.ball._x - hstart - hspacing / 2 * (_loc1_.ball.row % 2)) / hspacing);
   _loc1_.prongName = "prong_" + _loc1_.ball.row + "_" + _loc1_.ball.col;
   _loc1_.ball.onEnterFrame = function()
   {
      var _loc1_ = _root;
      _loc1_.acceleration = acceleration >= maxAcceleration ? maxAcceleration : acceleration + accelerationStep;
      _loc1_.speed += _loc1_.acceleration;
      _loc1_.ball._y += _loc1_.speed;
      _loc1_.ball._rotation += ballDirection * _loc1_.speed * 1.5;
      distance = Math.sqrt(Math.pow(_loc1_.ball._x - _loc1_[_loc1_.prongName]._x,2) + Math.pow(_loc1_.ball._y - _loc1_[_loc1_.prongName]._y,2));
      if(distance <= (_loc1_.ball._width + _loc1_[_loc1_.prongName]._width) / 2)
      {
         if(!ballHitsProng)
         {
            ballHitsProng = true;
            _loc1_.sound_hit.start();
            if(_loc1_.ball.row > 1)
            {
               _loc1_.ball._y = _loc1_[_loc1_.prongName]._y - _loc1_[_loc1_.prongName]._height / 2 - _loc1_.ball._height / 2;
            }
            _loc1_.acceleration = _loc1_.maxAcceleration;
            _loc1_.speed = 0;
         }
         if(_loc1_.ball._x == _loc1_[_loc1_.prongName]._x)
         {
            if(_loc1_[_loc1_.prongName].col == 1 && _loc1_[_loc1_.prongName].row % 2 == 0)
            {
               _loc1_.ball._x += 0.1;
            }
            else if(_loc1_[_loc1_.prongName].col == 7 && _loc1_[_loc1_.prongName].row % 2 == 0)
            {
               _loc1_.ball._x -= 0.1;
            }
            else
            {
               _loc1_.ball._x += 0.5 - Math.random() * 1;
            }
         }
         ballDirection = _loc1_.ball._x >= _loc1_[_loc1_.prongName]._x ? 1 : -1;
         minDistance = (_loc1_.ball._width + _loc1_[_loc1_.prongName]._width) / 2;
         _loc1_.ball._x = ballDirection + _loc1_[_loc1_.prongName]._x + ballDirection * Math.sqrt(Math.pow(minDistance,2) - Math.pow(_loc1_.ball._y - _loc1_[_loc1_.prongName]._y,2));
      }
      else if(!ballHitsProng)
      {
      }
      if(_loc1_.ball._y > _loc1_[_loc1_.prongName]._y)
      {
         _loc1_.ball.row++;
         if(_loc1_.ball.row == 2)
         {
            _loc1_.ball.gotoAndPlay("cinnamon");
            _loc1_.speechBubble._visible = true;
            _loc1_.speechBubble.gotoAndStop(10);
            sound_cinnamon.start(0,2);
         }
         else if(_loc1_.ball.row == 5)
         {
            _loc1_.ball.gotoAndPlay("sugar");
            _loc1_.speechBubble.gotoAndStop(11);
            sound_sugar.start(0,2);
         }
         _loc1_.ball.col = Math.round((_loc1_.ball._x - hstart - hspacing / 2 * (_loc1_.ball.row % 2)) / hspacing);
         _loc1_.ballHitsProng = false;
         _loc1_.prongName = "prong_" + _loc1_.ball.row + "_" + _loc1_.ball.col;
         _loc1_.ball._x = _loc1_[_loc1_.prongName]._x;
      }
      if(_loc1_.ball._y >= 425)
      {
         _loc1_.dropping = false;
         _loc1_.ball.row = 8;
         _loc1_.ball.col = Math.round((_loc1_.ball._x - hstart - hspacing / 2 * (_loc1_.ball.row % 2)) / hspacing);
         _loc1_.readSlot(_loc1_.ball.col);
         _loc1_.currcol = _loc1_.ball.col;
         _loc1_.ball.duplicateMovieClip("ball" + _loc1_.ball.ballNum,300 + _loc1_.ball.ballNum);
         _loc1_["ball" + _loc1_.ballNum].col = _loc1_.ball.col;
         _loc1_["ball" + _loc1_.ballNum].gotoAndStop("done");
         _loc1_["ball" + _loc1_.ballNum]._rotation = 0;
         _loc1_["ball" + _loc1_.ballNum]._x = _loc1_["prong_2_" + _loc1_.currCol]._x;
         _loc1_["ball" + _loc1_.ballNum]._y = 450;
         _loc1_.NUMBALLS.changeBy(-1);
         if(_loc1_.NUMBALLS.show() > 0)
         {
            _loc1_.placeBall();
         }
         else
         {
            _loc1_.cerealCounter._visible = false;
            _loc1_.attachMovie("endGameMessage","endGameMessage",9999);
            _loc1_.endGameMessage._x = 190;
            _loc1_.endGameMessage._y = 250;
         }
      }
   };
}
function readSlot(slotCol)
{
   var _loc1_ = _root;
   switch(slotCol)
   {
      case 1:
         _loc1_.score += 50;
         _loc1_.GAMESCORE.changeBy(50);
         _loc1_.sound_plus.start();
         break;
      case 2:
         _loc1_.score -= 25;
         _loc1_.GAMESCORE.changeBy(-25);
         _loc1_.sound_minus.start();
         break;
      case 3:
         _loc1_.score += 75;
         _loc1_.GAMESCORE.changeBy(75);
         _loc1_.sound_plus.start();
         break;
      case 4:
         _loc1_.score = 0;
         _loc1_.GAMESCORE.changeTo(0);
         _loc1_.sound_minus.start();
         break;
      case 5:
         _loc1_.score += 100;
         _loc1_.GAMESCORE.changeBy(100);
         _loc1_.sound_plus.start();
         break;
      case 6:
         _loc1_.score = Math.round(_loc1_.score / 2);
         _loc1_.GAMESCORE.changeTo(Math.round(_loc1_.GAMESCORE.show() / 2));
         _loc1_.sound_minus.start();
         break;
      case 7:
         _loc1_.score += 50;
         _loc1_.GAMESCORE.changeBy(50);
         _loc1_.sound_plus.start();
   }
   _loc1_.speechBubble.gotoAndStop(slotCol);
   _loc1_.scoreText = "<P align=\'center\'>" + _loc1_.score;
   if(_loc1_.gameOver)
   {
      _loc1_.gotoAndPlay("gameoverframe");
   }
}
var hstart = -10;
var vstart = 10;
var hspacing = 50;
var vspacing = 50;
var maxAcceleration = 2;
var accelerationStep = 0.1;
var acceleration = 0;
var score = 0;
var scoreText = "<P align=\'center\'>" + _root.score;
var gameOver = false;
var ballNum = 0;
var dropping = false;
var overEndGame = false;
sound_hit = new Sound(_root);
sound_hit.attachSound("drip");
sound_plus = new Sound(_root);
sound_plus.attachSound("cash_reg");
sound_minus = new Sound(_root);
sound_minus.attachSound("whistle");
sound_cinnamon = new Sound(_root);
sound_cinnamon.attachSound("merging");
sound_sugar = new Sound(_root);
sound_sugar.attachSound("rattler");
speechBubble._visible = false;
placeProngs();
placeBall();
