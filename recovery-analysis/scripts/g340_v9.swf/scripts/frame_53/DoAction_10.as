_global.gBullet = function(pType, pX, pY)
{
   this.init(pType,pX,pY);
};
var obj = gBullet.prototype;
obj.init = function(pType, pX, pY)
{
   this.dir = pDir;
   this._x = pX;
   this._y = pY;
   this.speed = 3;
   if(pType == "moveLeft")
   {
      this.dx = -1;
      this.dy = 0;
   }
   else if(pType == "moveRight")
   {
      this.dx = 1;
      this.dy = 0;
   }
   gList.actorList.push(this);
};
obj.checkBounds = function()
{
   if(this._x < 0 or this._x > this._parent.bounds.xMax or this._y < 0 or this._y > 400)
   {
      this.removeItem(gList.actorList);
      this.removeMovieClip();
   }
};
obj.move = function()
{
   this._y += this.speed * this.dy;
   this._x += this.speed * this.dx;
};
_global.gPlayerBullet = function(pType, pX, pY, bulletAngle, bulletSpeed, pMode)
{
   this.init(pType,pX,pY,bulletAngle,bulletSpeed,pMode);
};
gPlayerBullet.extend(gBullet);
var pB = gPlayerBullet.prototype;
pB.init = function(pType, pX, pY, bulletAngle, bulletSpeed, pMode)
{
   super.init(pType,pX,pY);
   if(_root.characterSelected == 2)
   {
      this.type2._visible = 1;
      this.type1._visible = 0;
   }
   else
   {
      this.type1._visible = 1;
      this.type2._visible = 0;
   }
   this.angle = bulletAngle;
   this.dx = Math.cos(this.angle);
   this.dy = Math.sin(this.angle);
   this.speed = bulletSpeed;
   if(pMode == 0)
   {
      this.enemyChecking = this.checkRegEnemies;
   }
   else
   {
      this.enemyChecking = this.checkBossEnemy;
   }
};
pB.checkBounds = function()
{
   if(this._x < 0 or this._x > this._parent.bounds.xMax or this._y < 0 or this._y > 400)
   {
      _root.shotsMissed = _root.shotsMissed + 1;
      this.removeItem(gList.actorList);
      this.removeMovieClip();
   }
};
pB.checkRegEnemies = function()
{
   var _loc5_ = gList.enemies.length;
   var _loc4_ = 0;
   var _loc3_;
   while(_loc4_ < _loc5_)
   {
      _loc3_ = gList.enemies[_loc4_];
      if(this.hitTest(_loc3_) and !_loc3_.dying and !_loc3_.invincible)
      {
         _loc3_.numHits = _loc3_.numHits - 1;
         if(_loc3_.numHits == 0)
         {
            _loc3_.die(1);
         }
         else
         {
            _root.hitEnemySound.start();
            _loc3_.flash();
         }
         this.removeItem(gList.actorList);
         this.removeMovieClip();
      }
      _loc4_ = _loc4_ + 1;
   }
};
pB.checkBossEnemy = function()
{
   var _loc3_ = _root.world.boss;
   if(gList.enemies.length > 0)
   {
      this.checkRegEnemies();
   }
   var _loc4_;
   if(this.hitTest(_loc3_) and !_loc3_.dying)
   {
      _loc4_ = Math.abs(this._y - _loc3_._y);
      if(_loc4_ < _loc3_.shield._height / 2 and !_loc3_.invincible)
      {
         _loc3_.numHits = _loc3_.numHits - 1;
         _loc3_.shield.nextFrame();
         if(_loc3_.numHits == 0)
         {
            _loc3_.die();
         }
         else
         {
            _root.hitEnemySound.start();
            _loc3_.flash();
         }
      }
      this.removeItem(gList.actorList);
      this.removeMovieClip();
   }
};
pB.onEnterFrame = function()
{
   this.enemyChecking();
   this.checkBounds();
   this.move();
};
_global.gEnemyBullet = function(pType, pX, pY)
{
   this.init(pType,pX,pY);
};
gEnemyBullet.extend(gBullet);
var eB = gEnemyBullet.prototype;
eB.init = function(pType, pX, pY)
{
   super.init(pType,pX,pY);
   this.speed = 1.5;
   this.pXRatio = gMyScoringSystem.Ratio.getX();
   this.pYRatio = gMyScoringSystem.Ratio.getY();
   var _loc6_ = 10 - random(20);
   var _loc5_ = 10 - random(20);
   var _loc4_ = this.getAngle(_root.world.player._x + _loc6_,_root.world.player._y + _loc5_);
   this.dx = this.speed * Math.cos(_loc4_);
   this.dy = this.speed * Math.sin(_loc4_);
};
eB.checkPlayer = function()
{
   if(_root.world.player.body.hitTest(this._x * this.pXRatio,this._y * this.pYRatio,1))
   {
      _root.world.player.setShieldBy(-1);
      this.removeItem(gList.actorList);
      this.removeMovieClip();
   }
};
eB.onEnterFrame = function()
{
   this.checkPlayer();
   this.checkBounds();
   this.move();
};
