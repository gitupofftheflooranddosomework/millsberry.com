_global.gKatra = function(pSpeed, pType, pX, pY, kInfo_name, kInfo_desc)
{
   this.init(pSpeed,pType,pX,pY,kInfo_name,kInfo_desc);
};
var obj = gKatra.prototype;
obj.init = function(pSpeed, pType, pX, pY, kInfo_name, kInfo_desc)
{
   gList.katras.push(this);
   gList.actorList.push(this);
   this.speed = pSpeed;
   this.subType = pType;
   this.xS = 0;
   this._x = pX;
   this._y = pY;
   this.dx = - this.speed;
   this.pName = kInfo_name;
   this.pDesc = kInfo_desc;
   this.dying = 0;
   if(this.pDesc != "Bomb")
   {
      this.multiplier = random(_root.eLevel.show()) + 1;
   }
};
obj.remove = function()
{
   this.removeItem(gList.katras);
   this.removeItem(gList.actorList);
   this.removeMovieClip();
};
obj.die = function()
{
   this.dying = 1;
   _root.pickupSound.start();
   _root.eScore.changeby(_root.ePickupPts.show());
   _root.world.sb.refresh();
   trace("pickup");
   var _loc3_;
   switch(this.pName.toLowerCase())
   {
      case "mind":
         _loc3_ = _level0.IDS_single_shot;
         break;
      case "soul":
         _loc3_ = _level0.IDS_double_shot;
         break;
      case "unknown":
         _loc3_ = _level0.IDS_triple_shot;
         break;
      case "body":
         _loc3_ = _level0.IDS_shield;
         break;
      case "spirit":
         _loc3_ = _level0.IDS_speed_up;
         break;
      case "catalyst":
         _loc3_ = _level0.IDS_super_attack;
   }
   var _loc4_;
   if(_loc3_ == _level0.IDS_super_attack)
   {
      _loc4_ = _loc3_ + " + 1";
      _root.eBombs.changeBy(1);
   }
   else
   {
      _loc4_ = "<p align=\'center\'><font size=\'18\'>" + _loc3_ + "\nx" + this.multiplier + "</font></p>";
   }
   _root.world.sb.refresh();
   _root.showComboPts(this._x + this._width / 2,this._y + this._height / 2,_loc4_);
   this.onEnterFrame = function()
   {
      this.xS += 1.2;
      this._alpha -= this.xS;
      this.graphic._xscale = this.graphic._yscale += this.xS;
      if(this.graphic._xscale > 150)
      {
         this.remove();
      }
   };
};
obj.onEnterFrame = function()
{
   this._x += this.dx;
   if(this._x + this._width < 0)
   {
      this.remove();
   }
};
