function resetHitObj()
{
   hitObj._visible = false;
}
function drawDistance()
{
   canvas.clear();
   var k = 0;
   while(k < aBarrels.length)
   {
      with(canvas)
      {
         lineStyle(1,255,75);
         moveTo(hitObj._x,hitObj._y);
         lineTo(aBarrels[k]._x,aBarrels[k]._y);
      }
      k++;
   }
   updateAfterEvent();
}
function setCompassTarget(angle, power)
{
   var _loc2_ = angle * 3.141592653589793 / 180;
   trace("setCompassTarget " + power + " @ " + angle + "º (" + _loc2_ + " rads)");
   targetX = Math.round(targetOriginX + 3 * power * Math.sin(_loc2_));
   targetY = Math.max(horizonY,Math.round(targetOriginY - 3 * power * Math.cos(_loc2_)));
   hitObj._x = targetX;
   hitObj._y = targetY;
   hitObj._visible = true;
   var _loc5_ = new mx.transitions.Tween(MC_compass,"_y",mx.transitions.easing.Regular.easeInOut,0,320,0.6,true);
   _loc5_.onMotionFinished = function()
   {
      launchLifesaver();
   };
   var _loc6_ = targetX - ropeOriginX;
   var _loc4_ = targetY - ropeOriginY;
   var _loc1_ = 180 * Math.atan2(_loc6_,- _loc4_) / 3.141592653589793;
   MC_Panel_RopeTry._rotation = _loc1_;
   MC_Panel_RopeTry.angle = _loc1_;
   MC_Panel_RopeTry.ropeMC.cheerioMC._rotation = - _loc1_;
   trace("target @ " + targetX + "," + targetY + "   ropeAngle " + _loc1_ + "º");
}
function launchLifesaver()
{
   trace("launchLifesaver " + targetX + "," + targetY);
   MC_ropeUncoiling._y = 70;
   MC_Panel_RopeTry._x = targetX;
   MC_Panel_RopeTry._y = targetY;
   MC_Panel_RopeTry._xscale = MC_Panel_RopeTry._yscale = targetY / 2;
   var _loc6_ = MC_Panel_Field["MC_Panel_cheerioX_0" + ++attempt];
   _loc6_._visible = true;
   var _loc5_ = 1000;
   var _loc1_ = 0;
   var _loc4_;
   var _loc3_;
   var _loc2_;
   while(_loc1_ < aBarrels.length)
   {
      _loc4_ = targetX - aBarrels[_loc1_]._x;
      _loc3_ = targetY - aBarrels[_loc1_]._y;
      _loc2_ = Math.sqrt(_loc4_ * _loc4_ + _loc3_ * _loc3_);
      trace("BARREL >>>>>>>>>> " + _loc1_ + ": " + aBarrels[_loc1_]._x + " - " + aBarrels[_loc1_]._y);
      trace("Char >>>>>>>>>>>> " + hitObj._y + " - " + hitObj._x);
      if(aBarrels[_loc1_].areahit.hitTest(hitObj))
      {
         barrel = aBarrels[_loc1_];
         points = Math.round(basePoints - deviationPtsMultiplier * _loc2_);
         trace("------------------------------");
         trace("hit barrel " + _loc1_ + "\t" + points + "pts");
         trace("------------------------------");
         MC_Panel_RopeTry.hitMiss = "hit";
         MC_Panel_RopeTry.play();
         MC_ropeUncoiling.play();
         return undefined;
      }
      if(_loc2_ < _loc5_)
      {
         _loc5_ = _loc2_;
      }
      _loc1_ = _loc1_ + 1;
   }
   points = Math.round(- _loc5_);
   trace("missed! " + points + "pts");
   MC_Panel_RopeTry.hitMiss = "miss";
   MC_Panel_RopeTry.play();
   MC_ropeUncoiling.play();
}
function ropeLanded(hit)
{
   trace(attempt + " ropeLanded " + hit);
   var _loc1_;
   if(hit)
   {
      _loc1_ = 0;
      while(_loc1_ < aBarrels.length)
      {
         if(aBarrels[_loc1_] == barrel)
         {
            aBarrels.splice(_loc1_,1);
            break;
         }
         _loc1_ = _loc1_ + 1;
      }
      barrel.removeMovieClip();
   }
   else if(attempt < 4)
   {
      MC_Panel_RopeTry.onEnterFrame = function()
      {
         hitObj._x = MC_Panel_RopeTry._x;
         hitObj._y = MC_Panel_RopeTry._y;
         var _loc1_ = 0;
         var _loc3_;
         var _loc2_;
         var _loc4_;
         while(_loc1_ < aBarrels.length)
         {
            if(aBarrels[_loc1_].areahit.hitTest(hitObj))
            {
               _loc3_ = targetX - aBarrels[_loc1_]._x;
               _loc2_ = targetY - aBarrels[_loc1_]._y;
               _loc4_ = Math.sqrt(_loc3_ * _loc3_ + _loc2_ * _loc2_);
               barrel = aBarrels[_loc1_];
               points = Math.round(basePoints - deviationPtsMultiplier * _loc4_);
               trace("hit barrel " + _loc1_ + "\t" + points + "pts");
               tweenRope.stop();
               MC_Panel_RopeTry.gotoAndStop("hit");
               return undefined;
            }
            _loc1_ = _loc1_ + 1;
         }
      };
   }
   var tweenRope = new mx.transitions.Tween(MC_Panel_RopeTry,"_x",mx.transitions.easing.Regular.easeIn,MC_Panel_RopeTry._x,ropeOriginX,2,true);
   new mx.transitions.Tween(MC_Panel_RopeTry,"_y",mx.transitions.easing.Regular.easeIn,MC_Panel_RopeTry._y,ropeOriginX,2,true);
   new mx.transitions.Tween(MC_Panel_RopeTry,"_xscale",mx.transitions.easing.Regular.easeIn,MC_Panel_RopeTry._xscale,100,2,true);
   new mx.transitions.Tween(MC_Panel_RopeTry,"_yscale",mx.transitions.easing.Regular.easeIn,MC_Panel_RopeTry._yscale,100,2,true);
   new mx.transitions.Tween(MC_ropeUncoiling,"_y",mx.transitions.easing.Regular.easeIn,70,170,2,true);
   tweenRope.onMotionFinished = function()
   {
      trackPoints(points,targetX,targetY);
      if(barrel == null)
      {
         CloseTryAgain.play();
      }
      else
      {
         SweetHoneySaved.play();
      }
      resetHitObj();
      delete MC_Panel_RopeTry.onEnterFrame;
   };
}
function messageDone(wasHit)
{
   trace("messageDone " + wasHit);
   if(aBarrels.length == 0)
   {
      gameOver("gameWon");
   }
   else if(attempt > 3)
   {
      if(aBarrels.length < 1)
      {
         gameOver("gameWon");
      }
      else
      {
         gameOver("gameLost");
      }
   }
   else
   {
      newRound();
   }
}
function trackPoints(pts, X, Y)
{
   var _loc3_;
   var _loc9_;
   var _loc11_;
   var _loc10_;
   if(MC_Panel_Field.onEnterFrame)
   {
      trace("wait to track these points: " + pts + " @ " + X + "," + Y);
      trackMorePoints = {points:pts,x_:X,y_:Y};
   }
   else
   {
      trace("trackPoints " + pts + " @ " + X + "," + Y);
      score += pts;
      _root.honeyloader.GAMESCORE.changeTo(score);
      trace("UPDATE GAMESCORE >>>>>>>>>>> " + _root.honeyloader.GAMESCORE.show());
      MC_Panel_Field.onEnterFrame = function()
      {
         var _loc2_ = Number(MC_Panel_Field.tfScore.text);
         var _loc1_ = Math.round((3 * _loc2_ + score) / 4);
         if(_loc1_ == _loc2_)
         {
            _loc1_ = Math.round((_loc2_ + 3 * score) / 4);
         }
         MC_Panel_Field.tfScore.text = String(_loc1_);
         if(_loc1_ == score)
         {
            delete MC_Panel_Field.onEnterFrame;
            if(trackMorePoints)
            {
               trackPoints(trackMorePoints.points,trackMorePoints.x_,trackMorePoints.y_);
               trackMorePoints = null;
            }
         }
      };
      _loc3_ = _root.createEmptyMovieClip("pointsMCcontainer",_root.getNextHighestDepth());
      _loc9_ = _loc3_.attachMovie("pointsMC","mc",0);
      _loc9_.TF.text = pts;
      _loc3_._x = X;
      _loc11_ = new mx.transitions.Tween(_loc3_,"_y",mx.transitions.easing.Regular.easeInOut,Y,Y - 40,2,true);
      _loc11_.onMotionFinished = function()
      {
         _root.pointsMCcontainer.removeMovieClip();
      };
      _loc10_ = new mx.transitions.Tween(_loc3_,"_alpha",mx.transitions.easing.Regular.easeInOut,0,100,1,true);
      _loc10_.onMotionFinished = function()
      {
         this.continueTo(0,1);
         delete this.onMotionFinished;
      };
   }
}
function gameOver(winLoseOrDraw)
{
   gameWonOrLost = winLoseOrDraw;
   trace("gameOver -> RESULT: " + gameWonOrLost);
   if(gameWonOrLost == "gameWon")
   {
   }
   if(!_root.honeyloader.PLAYTIMER.paused)
   {
      _root.honeyloader.PLAYTIMER.stop();
   }
   MC_Panel_Ship_Gamestates.gotoAndPlay("r4");
}
function afterGameOver()
{
   if(gameWonOrLost == "gameWon")
   {
      onEnterFrame = function()
      {
         trace("waiting for score check");
         gotoAndStop(gameWonOrLost);
         delete onEnterFrame;
      };
   }
   else
   {
      trace(gameWonOrLost);
      gotoAndStop(gameWonOrLost);
   }
   flash.external.ExternalInterface.call("urchinTracker","Game_511/Action_FinishLevel1");
}
function newRound()
{
   trace("newRound " + attempt);
   MC_compass.gotoAndPlay(1);
   MC_Panel_RopeTry.gotoAndStop(1);
   MC_ropeUncoiling.gotoAndStop(1);
   MC_Panel_Ship_Gamestates.gotoAndPlay("r" + attempt);
   barrel = null;
   var _loc1_ = new mx.transitions.Tween(MC_compass,"_y",mx.transitions.easing.Regular.easeInOut,320,0,0.6,true);
}
function newGame()
{
   trace("newGame");
   gameWonOrLost = null;
   MC_Panel_Ship_Gamestates.gotoAndStop(1);
   _root.honeyloader.GAMESCORE.changeTo(0);
   MC_Panel_Field.tfScore.text = score = 0;
   attempt = 0;
   aBarrels = new Array();
   aHorizontalPositions.sort(function()
   {
      return !random(2) ? -1 : 1;
   }
   );
   aVerticalPositions.sort(function()
   {
      return !random(2) ? -1 : 1;
   }
   );
   var _loc2_ = 0;
   var _loc3_;
   while(_loc2_ < 3)
   {
      _loc3_ = barrelLayer.attachMovie("MC_Panel_barrelInSplash" + random(2),"barrel" + _loc2_,_loc2_);
      _loc3_._x = aHorizontalPositions[_loc2_];
      _loc3_._y = aVerticalPositions[_loc2_];
      _loc3_._xscale = _loc3_._yscale = 40 + (aVerticalPositions[_loc2_] - 100) / 2;
      _loc3_.id = _loc2_;
      aBarrels.push(_loc3_);
      _loc2_ = _loc2_ + 1;
   }
   _loc2_ = 1;
   while(_loc2_ < 5)
   {
      MC_Panel_Field["MC_Panel_cheerioX_0" + _loc2_]._visible = false;
      _loc2_ = _loc2_ + 1;
   }
   flash.external.ExternalInterface.call("urchinTracker","Game_511/Action_StartLevel1");
   if(_root.honeyloader.PLAYTIMER.paused)
   {
      _root.honeyloader.PLAYTIMER.start();
   }
   newRound();
}
_root.honeyloader.GAMESCORE.changeTo(0);
trace("GAMESCORE LEVEL 1 >>>>>>>>>>>>> " + _root.honeyloader.GAMESCORE.show());
var basePoints = 1500;
var deviationPtsMultiplier = 5;
var percX = this._parent._parent._xscale / 100;
var percY = this._parent._parent._yscale / 100;
var aHorizontalPositions = new Array(Stage.width / percX / 4,Stage.width / percX / 2,3 * (Stage.width / percX) / 4);
var aVerticalPositions = new Array(120,145,180);
var ropeOriginX = Stage.width / percX / 2;
var ropeOriginY = Stage.height / percY + 120;
var targetOriginX = MC_compass.MC_Compass_Arrowanim._x;
var targetOriginY = MC_compass.MC_Compass_Arrowanim._y;
var horizonY = 95;
trace("targetOrigin: " + targetOriginX + ", " + targetOriginY);
var aBarrels;
var score;
var attempt = 0;
var points;
var targetX;
var targetY;
var barrel;
var userInitials = "   ";
var IDinterval;
this.createEmptyMovieClip("hitObj",this.getNextHighestDepth());
this.createEmptyMovieClip("canvas",this.getNextHighestDepth());
with(hitObj)
{
   beginFill("0x0000ff",0);
   moveTo(-10,-10);
   lineTo(10,-10);
   lineTo(10,10);
   lineTo(-10,10);
   lineTo(-10,-10);
   endFill();
}
stop();
newGame();
var trackMorePoints;
var gameWonOrLost;
