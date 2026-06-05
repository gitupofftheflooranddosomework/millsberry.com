function init()
{
   _root.eLevel = new gMyScoringSystem.Evar(0);
   _root.eMaxLevels = new gMyScoringSystem.Evar(5);
   _root.eScore = new gMyScoringSystem.Evar(0);
   _root.eRoundBonus = new gMyScoringSystem.Evar(0);
   _root.eLives = new gMyScoringSystem.Evar(3);
   _root.eEnemyKillPts = new gMyScoringSystem.Evar(5);
   _root.eBossPts = new gMyScoringSystem.Evar(100);
   _root.eEnemyGroupPts = new gMyScoringSystem.Evar(5);
   _root.ePickupPts = new gMyScoringSystem.Evar(5);
   _root.eShieldBonus = new gMyScoringSystem.Evar(10);
   _root.eBombs = new gMyScoringSystem.Evar(3);
   _root.shotsMissed = 0;
   _root.gameMusic = new Sound(_root);
   _root.gameMusic.attachSound("gameMusic");
   _root.pickupSound = new Sound(_root);
   _root.pickupSound.attachSound("pickupNoise");
   _root.specialSound = new Sound(_root);
   _root.specialSound.attachSound("specialSound");
   _root.bonusSound = new Sound(_root);
   _root.bonusSound.attachSound("bonusNoise");
   _root.plFireSound = new Sound(_root);
   _root.plFireSound.attachSound("plShootSound");
   _root.enFireSound = new Sound(_root);
   _root.enFireSound.attachSound("enShootSound");
   _root.hitEnemySound = new Sound(_root);
   _root.hitEnemySound.attachSound("hitENoise");
   _root.pHitSound = new Sound(_root);
   _root.pHitSound.attachSound("playerHitSound");
   _root.explosionSound = new Sound(_root);
   _root.explosionSound.attachSound("eExplosion");
   _root.setDepths();
   _global.gList = new Object();
   gList.clearAll = new Array();
   gList.enemies = new Array();
   gList.katras = new Array();
   gList.actorList = new Array();
   _root.attachMovie("bg","bg",gDepths.bg);
   gList.clearAll.push(_root.bg);
   _root.nextLevel();
   makeRuler();
}
function setDepths()
{
   _global.gDepths = new Object();
   gDepths.bbg = 1;
   gDepths.world = 100;
   gDepths.bg = 2;
   gDepths.fg = 7900;
   gDepths.enemy = 1000;
   gDepths.enemyNum = 0;
   gDepths.enemyGroupNum = 0;
   gDepths.enemyBoss = 4000;
   gDepths.enemyBossNum = 0;
   gDepths.player = 5000;
   gDepths.pBullet = 5010;
   gDepths.pBulletNum = 0;
   gDepths.eBullet = 6000;
   gDepths.eBulletNum = 0;
   gDepths.katras = 7000;
   gDepths.katraNum = 0;
   gDepths.comboText = 8000;
   gDepths.comboTextNum = 0;
   gDepths.sb = 9000;
   gDepths.timer = 9500;
   gDepths.prompt = 9800;
}
function nextLevel()
{
   _root.gameMusic.stop("gameMusic");
   _root.gameMusic.start(0,999999);
   gList.actorList = [];
   _root.eRoundBonus.changeto(0);
   _root.shotsMissed = 0;
   _root.setDepths();
   if(_root.endPrompt != undefined)
   {
      _root.endPrompt.removeMovieClip();
   }
   _root.eLevel.changeby(1);
   gMyNeoStatus.sendTag("Reached Level " + _root.eLevel.show());
   var _loc2_;
   var _loc5_;
   var _loc7_;
   if(_root.eLevel.show() == 1)
   {
      _loc2_ = _root.selectedChar;
      _loc5_ = 1;
      _loc7_ = 1;
   }
   else
   {
      _loc2_ = _root.world.player;
      _loc5_ = _loc2_.currentWeapon.typeNum;
      _loc7_ = _loc2_.offenseNum;
   }
   var _loc6_ = _loc2_.offense;
   var _loc3_ = _loc2_.defense;
   var _loc4_ = _loc2_.speed + 2;
   _root.makeWorld(0);
   _root.makePlayer("new",_loc6_,_loc3_,_loc4_,_loc5_,_loc7_);
}
function setPause()
{
   _root.buttonClick.start();
   var _loc2_;
   if(_root.world.paused)
   {
      _root.promptUnpause();
   }
   else
   {
      gPauseGame(1);
      _loc2_ = "pauseGame";
      _root.makePrompt(_loc2_);
   }
}
function openInstruct()
{
   _root.buttonClick.start();
   _root.InPrompt = _root.attachMovie("instructPrompt","instructPrompt",100000);
   _root.InPrompt._x = -55.1;
   _root.InPrompt._y = -147.6;
}
function closeInstruct()
{
   _root.buttonClick.start();
   _root.setPause();
   _root.InPrompt.removeMovieClip();
}
function promptUnpause()
{
   trace("unpause the game");
   _root.gameMusic.stop("gameMusic");
   _root.gameMusic.start(0,999999);
   gPauseGame(0);
   _root.endPrompt.removeItem(gList.clearAll);
   _root.endPrompt.removeMovieClip();
}
function restartCode()
{
   _root.gotoAndPlay("resetallframe");
   gClearAll();
}
function sendscoreCode()
{
   _root.gotoAndStop("sendscoreFrame");
   gClearAll();
}
function makeExplosion(x, y)
{
   var _loc3_ = gDepths.explosion + gDepths.explosionNum % 100;
   _root.world.attachMovie("explosion","expl" + gDepths.explosionNum,_loc3_);
   var _loc2_ = _root.world["expl" + gDepths.explosionNum];
   _loc2_._x = x;
   _loc2_._y = y;
   gDepths.explosionNum++;
}
function showComboPts(pX, pY, pMessage)
{
   var _loc8_ = gDepths.comboText + gDepths.comboTextNum % 50;
   _root.world.attachMovie("comboGroupText","cgText" + gDepths.comboTextNum,_loc8_);
   var _loc3_ = _root.world["cgText" + gDepths.comboTextNum];
   _global.translator.addTextField(_loc3_.tText,{htmlText:pMessage});
   var _loc5_ = _loc3_._width / 2;
   var _loc4_ = _loc3_._height / 2;
   if(pX < _loc5_)
   {
      pX += _loc5_;
   }
   else if(pX > _root.world.bounds.xMax - _loc5_)
   {
      pX = _root.world.bounds.xMax - _loc5_;
   }
   if(pY < _loc4_)
   {
      pY += _loc4_;
   }
   else if(pY > _root.world.bounds.yMax - _loc4_)
   {
      pY = _root.world.bounds.yMax - _loc4_;
   }
   _loc3_._x = pX;
   _loc3_._y = pY;
   gDepths.comboTextNum++;
}
function graphicFlash()
{
   this.graphic.onEnterFrame = function()
   {
      var _loc2_;
      if(++this.flashCount > this.flashLength)
      {
         this.flashCount = 0;
         this.transformColor.setTransform(this.oColor);
         this.onEnterFrame = undefined;
      }
      else
      {
         _loc2_ = Math.floor(this.flashCount % this.flashMod / this.flashNum);
         if(_loc2_ == 0)
         {
            this.transformColor.setTransform(this.oColor);
         }
         else
         {
            this.transformColor.setTransform(this.fColor);
         }
      }
   };
}
