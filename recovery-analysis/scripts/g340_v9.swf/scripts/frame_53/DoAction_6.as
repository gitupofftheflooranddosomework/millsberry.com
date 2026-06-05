_global.gBossEnemy = function(x, y)
{
   this.init(x,y);
};
var b = gBossEnemy.prototype;
b.init = function(x, y)
{
   this.invincible = 1;
   gList.actorList.push(this);
   var _loc3_ = _root.eLevel.show() * 18;
   this._x = x;
   this._y = y;
   this.dy = 0;
   this.xPoint = _root.world.bounds.centerX + this._width / 2;
   this.amp = 6;
   this.numHits = 8;
   this.fireCounter = 0;
   this.shootTime = 108 - _loc3_;
   this.shotChance = 2 * _root.eLevel.show();
   this.graphic.transformColor = new Color(this.graphic);
   this.graphic.oColor = {rb:0,gb:0,bb:0};
   this.graphic.fColor = {rb:255,gb:0,bb:0};
   this.graphic.flashCount = 0;
   this.graphic.flashLength = 6;
   this.graphic.flashMod = 6;
   this.graphic.flashNum = this.graphic.flashMod / 4;
   this.flash = _root.graphicFlash;
   this.hatchSound = new Sound(this);
   this.hatchSound.attachSound("bossHatchNoise");
   if(_root.eLevel.show() > 1)
   {
      this.makeShield();
   }
   if(_root.eLevel.show() > 2)
   {
      this.enemyTime = 180 - _loc3_;
      this.enemyCounter = 0;
   }
   this.efc = this["efcLEV" + _root.eLevel.show()];
};
b.shoot = function()
{
   _root.enFireSound.start();
   var _loc3_ = gDepths.eBullet + gDepths.eBulletNum % 500;
   var _loc5_ = _root.world.attachMovie("bullet","bullet" + gDepths.eBulletNum,_loc3_);
   var _loc4_ = gGetOddEvenNum();
   _loc5_.mcExtends(gEnemyBullet,"moveLeft",this._x - this._width / 2,this._y + _loc4_ * 50);
   gDepths.eBulletNum++;
};
b.remove = function()
{
   this.removeItem(gList.enemies);
   this.removeItem(gList.actorList);
   var _loc3_;
   if(_root.eLevel.show() == _root.eMaxLevels.show())
   {
      _loc3_ = "gameCleared";
   }
   else
   {
      _loc3_ = "endRound";
   }
   _root.makePrompt(_loc3_);
   this.removeMovieClip();
};
b.die = function()
{
   this.dying = 1;
   _root.explosionSound.start();
   this.onEnterFrame = undefined;
   _root.eScore.changeby(_root.eBossPts.show());
   _root.world.sb.refresh();
   var _loc6_ = this._width / 2;
   var _loc5_ = this._height / 2;
   var _loc3_ = 0;
   var _loc4_;
   while(_loc3_ < 12)
   {
      this.attachMovie("explosion","explosion" + _loc3_,_loc3_ + 1);
      _loc4_ = this["explosion" + _loc3_];
      _loc4_._x = _loc6_ - random(_loc6_ * 2);
      _loc4_._y = _loc5_ - random(_loc5_ * 2);
      _loc3_ = _loc3_ + 1;
   }
   this.gotoAndPlay("blowupFrame");
};
b.makeEnemy = function()
{
   var _loc3_;
   var _loc10_;
   var _loc12_;
   var _loc8_;
   var _loc5_;
   var _loc9_;
   var _loc7_;
   var _loc6_;
   var _loc4_;
   var _loc11_;
   if(++this.enemyCounter == this.enemyTime)
   {
      this.enemyCounter = 0;
      this.hatchSound.start();
      _loc3_ = gDepths.enemy + gDepths.enemyNum % 100;
      _root.world.attachMovie("enemy","enemy" + gDepths.enemyNum,_loc3_);
      _loc10_ = _root.world["enemy" + gDepths.enemyNum];
      _loc12_ = "mine1";
      _loc8_ = _root.eLevel.show();
      _loc5_ = 0;
      _loc9_ = _root.eLevel.show();
      _loc7_ = _root.eLevel.show() - 1;
      _loc6_ = this._x;
      _loc4_ = this._y;
      _loc11_ = 0;
      _loc10_.mcExtends(gChaseEnemy,this._parent,"chaserEnemy",_loc8_,_loc5_,_loc9_,_loc7_,_loc6_,_loc4_,undefined);
      gDepths.enemyNum++;
   }
};
b.setShot = function()
{
   if(++this.fireCounter == this.shootTime)
   {
      this.fireCounter = 0;
      this.shoot();
   }
};
b.introEFC = function()
{
   if(this._x > this.xPoint)
   {
      this._x -= 2;
   }
   else
   {
      this.invincible = 0;
      this.onEnterFrame = this.efc;
   }
};
b.move = function()
{
   this.dy += 0.2;
   this._y += this.amp * Math.sin(this.dy);
};
b.efcLEV1 = function()
{
   this.setShot();
   this.move();
};
b.efcLEV2 = function()
{
   this.setShot();
   this.move();
};
b.efcLEV3 = b.efcLEV4 = b.efcLEV5 = function()
{
   this.setShot();
   this.makeEnemy();
   this.move();
};
b.onEnterFrame = b.introEFC;
b.makeShield = function()
{
   var _loc10_ = 6;
   var _loc13_ = 6.28 / _loc10_;
   var _loc3_ = 0;
   var _loc5_ = 170;
   var _loc11_ = 0.08;
   var _loc14_ = 2 * _root.eLevel.show();
   var _loc12_ = _root.eLevel.show() - 1;
   var _loc4_ = 0;
   var _loc6_;
   var _loc7_;
   var _loc9_;
   var _loc8_;
   while(_loc4_ < _loc10_)
   {
      _loc6_ = gDepths.enemy + gDepths.enemyNum % 100;
      this._parent.attachMovie("enemy","enemy" + gDepths.enemyNum,_loc6_);
      _loc7_ = this._parent["enemy" + gDepths.enemyNum];
      _loc9_ = Math.cos(_loc3_) * _loc5_ + this._x;
      _loc8_ = Math.sin(_loc3_) * _loc5_ + this._y;
      _loc7_.mcExtends(gShieldEnemy,this._parent,"sineEnemy",0,20,_loc14_,_loc12_,_loc9_,_loc8_,undefined,this,_loc3_,_loc5_,_loc11_);
      _loc3_ += _loc13_;
      gDepths.enemyNum++;
      _loc4_ = _loc4_ + 1;
   }
};
