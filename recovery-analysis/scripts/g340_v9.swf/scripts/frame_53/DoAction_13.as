function makePlayer(playerType, pOffense, pDefense, pSpeed, currentWeapon, offenseNum)
{
   var _loc6_ = _root.world.player;
   if(_loc6_ != undefined)
   {
      _loc6_.removeMovieClip();
   }
   var _loc13_ = _root.world;
   var _loc3_ = _root.selectedChar;
   var _loc7_ = _loc3_.name;
   var _loc5_ = _loc3_.linkage;
   var _loc11_ = pOffense;
   var _loc8_ = pDefense;
   var _loc10_ = pSpeed;
   var _loc9_ = gDepths.comboText + gDepths.comboTextNum % 50;
   _root.world.attachMovie("playerStart_Prompt","startPrompt" + gDepths.comboTextNum,_loc9_);
   var _loc4_ = _root.world["startPrompt" + gDepths.comboTextNum];
   _loc4_._x = _root.world.bounds.centerX;
   _loc4_._y = _root.world.bounds.centerY - 50;
   gDepths.comboTextNum++;
   var _loc12_;
   if(playerType == "restart")
   {
      _loc12_ = "<p align=\'center\'><font size=\'18\'>" + _level0.IDS_level + _root.eLevel.show() + "\n" + _level0.IDS_lives_left + _root.eLives.show() + "</font></p>";
   }
   else
   {
      _loc12_ = "<p align=\'center\'><font size=\'18\'>" + _level0.IDS_level + _root.eLevel.show() + " " + _level0.IDS_start + "\n" + _level0.IDS_lives_left + _root.eLives.show() + "</font></p>";
   }
   _global.translator.addTextField(_loc4_.tText,{htmlText:_loc12_});
   _root.world.attachMovie(_loc5_,"player",gDepths.player);
   _root.world.player.mcExtends(gPlayer,_loc13_,_loc7_,_loc5_,_loc11_,_loc8_,_loc10_,currentWeapon,offenseNum);
   _root.world.player.setSpeeds(_loc3_.speed);
   _root.world.sb.refresh();
}
_global.gPlayer = function(world, name, linkage, offense, defense, speed, currentWeapon, offenseNum)
{
   this.init(world,name,linkage,offense,defense,speed,currentWeapon,offenseNum);
};
var p = gPlayer.prototype;
p.init = function(world, name, linkage, offense, defense, speed, currentWeapon, offenseNum)
{
   gList.actorList.push(this);
   this.world = world;
   this.bounds = world.bounds;
   this._x = this.bounds.centerX;
   this._y = this.bounds.centerY;
   this._xscale = this._yscale = 75;
   this.fireCount = 0;
   this.specialFireCount = 0;
   this.fireRate = 20 - offense;
   this.specialFireRate = 36;
   this.offense = offense;
   this.pBombs = 3;
   this.offenseNum = offenseNum;
   this.defense = defense;
   this.speed = speed;
   this.dead = 0;
   this.dx = this.dy = 0;
   this.pTransformed = 0;
   this.weapon1 = {typeNum:1,numBullets:1,bSpeed:10,angle1:0,fireRate:-4};
   this.weapon2 = {typeNum:2,numBullets:2,bSpeed:8,angle1:6.08375,angle2:0.19625,fireRate:2};
   this.weapon3 = {typeNum:3,numBullets:3,bSpeed:6,angle1:6.08375,angle2:0.19625,angle3:0,fireRate:4};
   this.currentWeapon = this["weapon" + currentWeapon];
   var _loc4_ = this.currentWeapon.typeNum;
   trace(_global.gPlayer.currentWeapon.typeNum);
   if(_loc4_ == 1)
   {
      _root.world.sb.showKatra.gotoAndStop("mind");
   }
   else if(_loc4_ == 2)
   {
      _root.world.sb.showKatra.gotoAndStop("soul");
   }
   else if(_loc4_ == 3)
   {
      _root.world.sb.showKatra.gotoAndStop("unknown");
   }
   this.graphic.transformColor = new Color(this);
   this.graphic.oColor = {rb:0,gb:0,bb:0};
   this.graphic.fColor = {rb:255,gb:255,bb:0};
   this.graphic.flashCount = 0;
   this.graphic.flashLength = 6;
   this.graphic.flashMod = 6;
   this.graphic.flashNum = this.graphic.flashMod / 4;
   this.flash = _root.graphicFlash;
   this.flash();
   this.death_counter = 0;
   this.death_pause = 54;
};
p.reset = function()
{
   this._x = this.bounds.centerX;
   this._y = this.bounds.centerY;
   this.currentWeapon = this.weapon1;
   this.onEnterFrame = this.efc;
};
p.setSpeeds = function(newSpeed)
{
   if(typeof newSpeed == "string")
   {
      newSpeed = Number(newSpeed);
   }
   this.maxspeed = Math.min(15,newSpeed);
   this.accelAmt = this.maxspeed / 4;
};
p.decel = function(dVar)
{
   if(dVar > 0.2)
   {
      dVar -= this.accelAmt;
      return dVar;
   }
   if(dVar < -0.2)
   {
      dVar += this.accelAmt;
      return dVar;
   }
   return 0;
};
p.setMaxSpeed = function(sentSpeed)
{
   if(sentSpeed > 0)
   {
      if(sentSpeed > this.maxSpeed)
      {
         return this.maxSpeed;
      }
      return sentSpeed;
   }
   if(sentSpeed < 0)
   {
      if(sentSpeed < - this.maxSpeed)
      {
         return - this.maxSpeed;
      }
      return sentSpeed;
   }
};
p.checkEnemies = function()
{
   var _loc6_;
   var _loc7_;
   if(_root.world.boss)
   {
      _loc6_ = _root.world.boss;
      _loc7_ = this.getDistance(_loc6_._x,_loc6_._y);
      if(_loc7_ < _loc6_._width / 2)
      {
         this.die();
      }
   }
   var _loc5_ = gList.enemies.length;
   var _loc3_ = 0;
   var _loc4_;
   while(_loc3_ < _loc5_)
   {
      _loc4_ = gList.enemies[_loc3_];
      if(_loc4_.sizer.hitTest(this.sizer) && !_loc4_.dying && !this.dead)
      {
         this.die(1);
      }
      _loc3_ = _loc3_ + 1;
   }
};
p.checkBounds = function()
{
   if(this._x - this.sizer._width / 2 < 0)
   {
      this.dx = 0;
      this._x = this.sizer._width / 2;
   }
   else if(this._x + this.sizer._width / 2 > this.bounds.xMax)
   {
      this.dx = 0;
      this._x = this.bounds.xMax - this.sizer._width / 2;
   }
   if(this._y - this.sizer._height / 2 < this.bounds.yMin - 40)
   {
      this.dy = 0;
      this._y = this.bounds.yMin - 40 + this.sizer._height / 2;
   }
   else if(this._y + this.sizer._height / 2 > this.bounds.yMax + 15)
   {
      this.dy = 0;
      this._y = this.bounds.yMax + 15 - this.sizer._height / 2;
   }
};
p.shoot = function()
{
   this.fireCount = this.fireCount + 1;
   this.specialFireCount = this.specialFireCount + 1;
   var _loc9_;
   var _loc10_;
   var _loc3_;
   var _loc4_;
   var _loc6_;
   var _loc5_;
   var _loc7_;
   var _loc8_;
   if(Key.isDown(32))
   {
      if(this.fireCount < this.fireRate)
      {
         return undefined;
      }
      this.gotoAndStop("shoot");
      this.fireCount = 0;
      _loc9_ = this.currentWeapon;
      _loc10_ = _loc9_.numBullets;
      _root.plFireSound.start();
      _loc3_ = 0;
      while(_loc3_ < _loc10_)
      {
         _loc4_ = gDepths.pBullet + gDepths.pBulletNum % 100;
         _loc6_ = _root.world.attachMovie("playerBullet","pBullet" + gDepths.pBulletNum,_loc4_);
         _loc5_ = _loc9_["angle" + (_loc3_ + 1)];
         _loc7_ = Math.min(10,_loc9_.bSpeed + this.offenseNum);
         _loc8_ = this.world.currentMode;
         _loc6_.mcExtends(gPlayerBullet,"RIGHT",this._x + this.sizer._width / 2 + 30,this._y,_loc5_,_loc7_,_loc8_);
         gDepths.pBulletNum++;
         _loc3_ = _loc3_ + 1;
      }
   }
   if(Key.isDown(83))
   {
      if(this.specialFireCount < this.specialFireRate)
      {
         return undefined;
      }
      this.specialFireCount = 0;
      if(_root.eBombs.show() > 0)
      {
         _root.specialSound.start();
         this.gotoAndStop("special");
      }
   }
};
p.die = function()
{
   this.dead = 1;
   _root.explosionSound.start();
   _root.eLives.changeby(-1);
   _root.world.sb.refresh();
   this.dy = 0;
   this.dx = 6;
   this.rot = 1.4;
   this.onEnterFrame = function()
   {
      this.dy += 1;
      this._rotation -= this.rot;
      this._y += this.dy;
      this._x -= this.dx;
      var _loc11_;
      var _loc6_;
      var _loc3_;
      var _loc7_;
      var _loc10_;
      var _loc9_;
      var _loc4_;
      var _loc5_;
      var _loc8_;
      if(this._y > this.bounds.yMax + 200)
      {
         if(++this.death_counter > this.death_pause)
         {
            this.death_counter = 0;
            if(_root.eLives.show() > 0)
            {
               this.removeItem(gList.actorList);
               _loc11_ = _root.world.currentCol;
               if(_root.world.currentCol > _root.world.maxCols / 2)
               {
                  trace("> half");
                  _loc6_ = 1;
               }
               else
               {
                  _loc6_ = 0;
               }
               _root.makeWorld(_loc6_);
               _loc3_ = _root.selectedChar;
               _loc7_ = 1;
               _loc10_ = 1;
               _loc9_ = _loc3_.offense;
               _loc4_ = _loc3_.defense;
               _loc5_ = _loc3_.speed;
               _root.makePlayer("restart",_loc9_,_loc4_,_loc5_,_loc7_,_loc10_);
            }
            else
            {
               _root.world.endGame();
               _loc8_ = "gameOver";
               this.removeItem(gList.actorList);
               _root.makePrompt(_loc8_);
               this.removeMovieClip();
               thisRock.removeMovieClip();
               thisRock = undefined;
            }
         }
      }
   };
};
p.setShieldBy = function(amount)
{
   if(amount > 0 and this.defense == 10)
   {
      _root.eScore.changeby(_root.eShieldBonus.show());
      return undefined;
   }
   this.defense += amount;
   if(amount < 0)
   {
      this.defense = Math.max(this.defense,0);
      _root.pHitSound.start();
      if(this.defense > 0)
      {
         this.flash();
      }
      else if(!this.dead)
      {
         this.die();
      }
   }
   else
   {
      this.defense = Math.min(this.defense,10);
   }
   _root.world.sb.refresh();
};
p.move = function()
{
   if(Key.isDown(37))
   {
      this.dx -= this.accelAmt;
   }
   else if(Key.isDown(39))
   {
      this.dx += this.accelAmt;
   }
   else if(this.dx != 0)
   {
      this.dx = this.decel(this.dx);
   }
   if(Key.isDown(38))
   {
      this.dy -= this.accelAmt;
   }
   else if(Key.isDown(40))
   {
      this.dy += this.accelAmt;
   }
   else if(this.dy != 0)
   {
      this.dy = this.decel(this.dy);
   }
   this.dx = this.setMaxSpeed(this.dx);
   this.dy = this.setMaxSpeed(this.dy);
   this._x += this.dx;
   this._y += this.dy;
   this.checkBounds();
};
p.setWeapon = function(weaponNum, weaponMultiplier)
{
   var _loc3_ = weaponMultiplier;
   if(this.currentWeapon.typeNum == weaponNum.typeNum)
   {
      this.offenseNum = Math.min(5,this.offenseNum + _loc3_);
   }
   else
   {
      this.offenseNum = _loc3_;
   }
   this.currentWeapon = weaponNum;
   this.fireRate += this.currentWeapon.fireRate;
   this.fireRate = Math.max(4,this.fireRate);
   _root.world.sb.refresh();
};
p.bombEnemies = function()
{
   _root.eBombs.changeby(-1);
   _root.world.sb.refresh();
   var _loc5_ = _root.world.boss;
   if(_loc5_)
   {
      _loc5_.numHits -= 4;
      _loc5_.shield.gotoAndStop(_loc5_.numHits + 1);
      if(_loc5_.numHits <= 0)
      {
         _loc5_.die();
      }
      else
      {
         _root.hitEnemySound.start();
         _loc5_.flash();
      }
   }
   var _loc6_ = gList.enemies.length;
   var _loc4_ = 0;
   var _loc3_;
   while(_loc4_ < _loc6_)
   {
      _loc3_ = gList.enemies[_loc4_];
      if(_loc3_._x + _loc3_._width / 2 < this.bounds.xMax and _loc3_._y - _loc3_._height / 2 > 0 and !_loc3_.dying)
      {
         _loc3_.numHits -= 4;
         if(_loc3_.numHits <= 0)
         {
            _loc3_.die(0);
         }
      }
      _loc4_ = _loc4_ + 1;
   }
};
p.checkKatras = function()
{
   var _loc6_ = gList.katras.length;
   var _loc5_ = 0;
   var _loc3_;
   var _loc4_;
   while(_loc5_ < _loc6_)
   {
      _loc3_ = gList.katras[_loc5_];
      if(_loc3_.hitTest(this.sizer) && !_loc3_.dying)
      {
         _loc4_ = _loc3_.subType.toLowerCase();
         _loc3_.die();
         if(_loc4_ == "gk_catalyst")
         {
            this.pBombs = this.pBombs + 1;
         }
         else if(_loc4_ == "gk_body")
         {
            this.setShieldBy(2 * _loc3_.multiplier);
            _root.world.sb.refresh();
         }
         else if(_loc4_ == "gk_mind")
         {
            _root.world.sb.showKatra.gotoAndStop("mind");
            this.setWeapon(this.weapon1,_loc3_.multiplier);
         }
         else if(_loc4_ == "gk_soul")
         {
            _root.world.sb.showKatra.gotoAndStop("soul");
            this.setWeapon(this.weapon2,_loc3_.multiplier);
         }
         else if(_loc4_ == "gk_spirit")
         {
            this.setSpeeds(this.speed + _loc3_.multiplier);
         }
         else if(_loc4_ == "gk_unknown")
         {
            _root.world.sb.showKatra.gotoAndStop("unknown");
            this.setWeapon(this.weapon3,_loc3_.multiplier);
         }
      }
      _loc5_ = _loc5_ + 1;
   }
};
p.setTransformation = function()
{
   var _loc2_ = this.graphic;
   switch(this.pTransformed)
   {
      case 1:
         _loc2_.onEnterFrame = function()
         {
            this.play();
            if(this._currentFrame == this._totalframes)
            {
               this.onEnterFrame = undefined;
            }
         };
         break;
      case -1:
         _loc2_.onEnterFrame = function()
         {
            this.rewind();
            if(this._currentFrame == 1)
            {
               this.onEnterFrame = undefined;
            }
         };
      default:
         return;
   }
};
p.transform = function()
{
   var _loc2_;
   var _loc3_;
   if(Key.isDown(88))
   {
      _loc2_ = this.graphic;
      _loc3_ = _loc2_._totalframes;
      if(_loc2_._currentframe == 1)
      {
         this.pTransformed = 1;
      }
      else if(_loc2_._currentframe == _loc2_._totalframes)
      {
         this.pTransformed = -1;
      }
      this.setTransformation();
   }
};
p.efc = function()
{
   this.checkEnemies();
   this.checkKatras();
   this.move();
   this.shoot();
};
p.onEnterFrame = p.efc;
