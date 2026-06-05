_global.gEnemyObj = function(world, look, speedOffset, fireOffset, pFireRand, numHitsOffset, x, y, group)
{
   this.init(world,look,speedOffset,fireOffset,pFireRand,numHitsOffset,x,y,group);
};
var sEnemy = gEnemyObj.prototype;
sEnemy.init = function(world, look, speedOffset, fireOffset, pFireRand, numHitsOffset, x, y, group)
{
   gList.actorList.push(this);
   gList.enemies.push(this);
   this.world = world;
   this.bounds = world.bounds;
   this.attachMovie(look,"graphic",1);
   if(speedOffset == undefined)
   {
      this.speed = this.world.scrollSpeed;
   }
   else
   {
      this.speed = this.world.scrollSpeed + speedOffset;
   }
   this.dx = this.dy = this.speed;
   if(fireOffset == undefined)
   {
      this.firing = 0;
   }
   else
   {
      this.fireCounter = 0;
      this.firing = 1;
      this.shotChance = pFireRand;
      this.fireOffset = fireOffset + (36 + random(10));
   }
   this.numHits = 1 + numHitsOffset;
   if(this.numHits > 1)
   {
      this.graphic.transformColor = new Color(this);
      this.graphic.oColor = {rb:0,gb:0,bb:0};
      this.graphic.fColor = {rb:255,gb:0,bb:0};
      this.graphic.flashCount = 0;
      this.graphic.flashLength = 6;
      this.graphic.flashMod = 6;
      this.graphic.flashNum = this.graphic.flashMod / 4;
      this.flash = _root.graphicFlash;
   }
   this._x = x;
   this._y = y;
   if(group != undefined)
   {
      this.group = group;
   }
   this.dr = speed;
};
sEnemy.shoot = function()
{
   _root.enFireSound.start();
   var _loc3_ = gDepths.eBullet + gDepths.eBulletNum % 500;
   var _loc4_ = _root.world.attachMovie("bullet","eBullet" + gDepths.eBulletNum,_loc3_);
   _loc4_.mcExtends(gEnemyBullet,"moveLeft",this._x - this._width / 2,this._y);
   gDepths.eBulletNum++;
};
sEnemy.setShooting = function()
{
   this.fireCounter = this.fireCounter + 1;
   var _loc2_;
   var _loc3_;
   if(this.fireCounter == this.fireOffset)
   {
      this.fireCounter = 0;
      _loc2_ = 10 - this.shotChance;
      _loc3_ = random(_loc2_);
      if(_loc3_ == 0)
      {
         this.shoot();
      }
   }
};
sEnemy.remove = function()
{
   this.removeItem(gList.enemies);
   this.removeItem(gList.actorList);
   this.removeMovieClip();
};
sEnemy.die = function(playSound)
{
   this.dying = 1;
   if(playSound != 0)
   {
      _root.explosionSound.start();
   }
   this.graphic.onEnterFrame = undefined;
   this.graphic.transformColor.setTransform(this.graphic.oColor);
   _root.eScore.changeby(_root.eEnemyKillPts.show());
   _root.world.sb.refresh();
   var _loc3_;
   if(this.group != undefined)
   {
      this.removeItem(this.group);
      if(this.group.length == 0)
      {
         _root.bonusSound.start();
         _root.eScore.changeby(_root.eEnemyGroupPts.show());
         _loc3_ = "BONUS " + _root.eEnemyGroupPts.show() + " pts.";
         _root.showComboPts(this._x,this._y,_loc3_);
      }
   }
   this.attachMovie("explosion","graphic",1);
   this.graphic.onEnterFrame = function()
   {
      if(this._currentframe == this._totalframes)
      {
         this._parent.remove();
      }
   };
};
_global.gMine = function(world, look, speedOffset, fireOffset, pFireRand, numHitsOffset, x, y, group)
{
   this.init(world,look,speedOffset,fireOffset,pFireRand,numHitsOffset,x,y,group);
};
gMine.extend(gEnemyObj);
var cM = gMine.prototype;
cM.init = function(world, look, speedOffset, fireOffset, pFireRand, numHitsOffset, x, y, group)
{
   super.init(world,look,speedOffset,fireOffset,pFireRand,numHitsOffset,x,y,group);
   this.fuseCount = 0;
   this.fuseTime = 18;
   this.exploding = 0;
   this.sensorRange = this._width * 2;
   this.explosionRange = 80;
};
cM.blowUp = function()
{
   this.fuseCount = this.fuseCount + 1;
   var _loc3_ = this.fuseCount % 2;
   if(_loc3_ == 0)
   {
      this.flash();
   }
   if(this.fuseCount >= this.fuseTime)
   {
      this.exploding = 1;
      this.dying = 1;
      this.attachMovie("explosion","graphic",1);
      this.transformColor.setTransform(this.fColor);
      this.graphic._xscale = 200;
      this.graphic._yscale = 400;
      _root.explosionSound.start();
      this.graphic.onEnterFrame = function()
      {
         if(this._currentframe == this._totalframes)
         {
            if(this._parent.hitTest(_root.world.player))
            {
               _root.world.player.setShieldBy(-3);
            }
            this._parent.remove();
         }
      };
   }
};
cm.fuseReset = function()
{
   this.fuseCount = 0;
};
cM.onEnterFrame = function()
{
   var _loc3_ = this.getDistance(_root.world.player._x,_root.world.player._y);
   if(_loc3_ < this.sensorRange and !this.exploding and !this.dying)
   {
      this.blowUp();
   }
   else
   {
      this.fuseReset();
   }
   this._x -= this.dx;
   if(this._x + this._width < 0)
   {
      this.remove();
   }
};
_global.gPatternEnemy = function(world, look, speedOffset, fireOffset, pFireRand, numHitsOffset, x, y, group, patternList, loopCount)
{
   this.init(world,look,speedOffset,fireOffset,pFireRand,numHitsOffset,x,y,group,patternList,loopCount);
};
gPatternEnemy.extend(gEnemyObj);
var pat = gPatternEnemy.prototype;
pat.init = function(world, look, speedOffset, fireOffset, pFireRand, numHitsOffset, x, y, group, patternList, loopCount)
{
   super.init(world,look,speedOffset,fireOffset,pFireRand,numHitsOffset,x,y,group);
   this.looping = loopCount;
   this.startPoint = 0;
   this.points = gPatterns[patternList];
};
pat.onEnterFrame = function()
{
   this.setShooting();
   var _loc2_ = this.points[this.startPoint];
   var _loc4_ = this.points.length - 1;
   var _loc5_ = this.getDistance(_loc2_.x,_loc2_.y);
   var _loc3_ = this.getAngle(_loc2_.x,_loc2_.y);
   if(_loc5_ > this._width / 2)
   {
      this.dx = this.speed * Math.cos(_loc3_);
      this.dy = this.speed * Math.sin(_loc3_);
   }
   else
   {
      this.startPoint = this.startPoint + 1;
      if(this.startPoint > _loc4_)
      {
         if(this.looping)
         {
            this.startPoint = 0;
         }
         else
         {
            this.remove();
         }
      }
   }
   this._x += this.dx;
   this._y += this.dy;
};
_global.gShieldEnemy = function(world, look, speedOffset, fireOffset, pFireRand, numHitsOffset, x, y, group, par, angle, orbitRad, rotIncr)
{
   this.init(world,look,speedOffset,fireOffset,pFireRand,numHitsOffset,x,y,group,par,angle,orbitRad,rotIncr);
};
gShieldEnemy.extend(gEnemyObj);
var gS = gShieldEnemy.prototype;
gS.init = function(world, look, speedOffset, fireOffset, pFireRand, numHitsOffset, x, y, group, par, angle, orbitRad, rotIncr)
{
   super.init(world,look,speedOffset,fireOffset,pFireRand,numHitsOffset,x,y,group);
   this.par = par;
   this.angle = angle;
   this.orbitRad = orbitRad;
   this.rotIncr = rotIncr;
   this.invincible = 1;
};
gS.onEnterFrame = function()
{
   if(!this.par.invincible)
   {
      this.invincible = 0;
      this.setShooting();
   }
   this.angle += this.rotIncr;
   this._x = Math.cos(this.angle) * this.orbitRad + this.par._x;
   this._y = Math.sin(this.angle) * this.orbitRad + this.par._y;
};
_global.gChaseEnemy = function(world, look, speedOffset, fireOffset, pFireRand, numHitsOffset, x, y, group)
{
   this.init(world,look,speedOffset,fireOffset,pFireRand,numHitsOffset,x,y,group);
};
gChaseEnemy.extend(gEnemyObj);
var gChase = gChaseEnemy.prototype;
gChase.init = function(world, look, speedOffset, fireOffset, pFireRand, numHitsOffset, x, y, group)
{
   super.init(world,look,speedOffset,fireOffset,pFireRand,numHitsOffset,x,y,group);
   this.target_x = _root.world.player._x;
   this.target_y = _root.world.player._y;
};
gChase.onEnterFrame = function()
{
   var _loc4_ = this.getDistance(_root.world.player._x,_root.world.player._y);
   var _loc3_ = this.getAngle(_root.world.player._x,_root.world.player._y);
   this._rotation = radToDegrees(_loc3_);
   this._x += this.speed * Math.cos(_loc3_);
   this._y += this.speed * Math.sin(_loc3_);
};
