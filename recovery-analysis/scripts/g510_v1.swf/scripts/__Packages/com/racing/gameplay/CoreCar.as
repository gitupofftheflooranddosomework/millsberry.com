class com.racing.gameplay.CoreCar extends MovieClip
{
   var scenery;
   static var __inst;
   var pedal = false;
   var steer = 0;
   var onborder = false;
   var rotationZ = -90;
   var speed1 = 0;
   var maxspeed1 = 50;
   var reverseAccel = 1;
   var accel1 = 0.01;
   var damp1 = 0.97;
   var dampStop = 0.7300000000000004;
   var sinness = 0;
   var cosness = 0;
   function CoreCar()
   {
      super();
      this._visible = false;
      com.racing.gameplay.CoreCar.__inst = this;
      this.scenery = com.racing.gameplay.World.scenery;
   }
   function onEnterFrame()
   {
      this.pedal = false;
      this.steer = 0;
      this.onborder = false;
      if(this.scenery.night)
      {
         this.scenery.night.swapDepths(com.racing.gameplay.World.BASEDEPTH + 301);
      }
      this.scenery.carp.swapDepths(com.racing.gameplay.World.BASEDEPTH + 302);
      if(com.racing.gameplay.RaceTimer.getInstance().timing == false)
      {
         if(Key.isDown(38))
         {
            this.pedal = true;
         }
         return undefined;
      }
      if(Key.isDown(38))
      {
         this.speed1 += (this.maxspeed1 - this.speed1 + 1) * this.accel1;
         this.pedal = true;
         if(this.speed1 > 0 && this.speed1 < 5)
         {
            this.scenery.carp.smoke._visible = true;
         }
         else
         {
            this.scenery.carp.smoke._visible = false;
         }
      }
      else
      {
         this.scenery.carp.smoke._visible = false;
      }
      if(Key.isDown(40))
      {
         if(this.speed1 < 0)
         {
            this.speed1 -= (this.maxspeed1 / 3 + this.speed1) * this.accel1;
         }
         else
         {
            this.speed1 -= this.reverseAccel;
         }
         this.pedal = false;
      }
      if(this.pedal == false)
      {
         if(Math.abs(this.speed1) > 0.1)
         {
            this.speed1 *= this.damp1;
         }
         else
         {
            this.speed1 = 0;
         }
      }
      if(Key.isDown(39))
      {
         this.rotationZ -= 5;
         this.steer = 1;
         this.scenery.carp.car.nextFrame();
      }
      if(Key.isDown(37))
      {
         this.rotationZ += 5;
         this.steer = 2;
         this.scenery.carp.car.prevFrame();
      }
      if(this.steer == 0)
      {
         if(this.scenery.carp.car._currentframe >= 6)
         {
            this.scenery.carp.car.prevFrame();
         }
         if(this.scenery.carp.car._currentframe <= 4)
         {
            this.scenery.carp.car.nextFrame();
         }
      }
      if(this.rotationZ > 180)
      {
         this.rotationZ = -180 + (this.rotationZ - 180);
      }
      if(this.rotationZ < -180)
      {
         this.rotationZ = 180 + (this.rotationZ + 180);
      }
      this._rotation = - this.rotationZ - 90;
      this._x -= this.sinness / 2;
      this._y -= this.cosness / 2;
      this.cosness = this.speed1 * Math.cos(this.rotationZ * 3.141592653589793 / 180) / 2;
      this.sinness = this.speed1 * Math.sin(this.rotationZ * 3.141592653589793 / 180) / 2;
   }
   function kill()
   {
      this.onEnterFrame = com.dynamicflash.utils.Delegate.create(this,this.stopCar);
   }
   function stopCar()
   {
      this.pedal = false;
      if(Math.abs(this.speed1) > 0.1)
      {
         this.speed1 *= this.dampStop;
         this.scenery.carp.car.nextFrame();
      }
      else
      {
         this.speed1 = 0;
         this.onEnterFrame = null;
         com.racing.gameplay.RaceTimer.getInstance().timing = false;
         this.scenery.carp.smoke._visible = false;
      }
      this.scenery.carp.swapDepths(com.racing.gameplay.World.BASEDEPTH + 300);
      if(this.rotationZ > 180)
      {
         this.rotationZ = -180 + (this.rotationZ - 180);
      }
      if(this.rotationZ < -180)
      {
         this.rotationZ = 180 + (this.rotationZ + 180);
      }
      this._rotation = - this.rotationZ - 90;
      this._x -= this.sinness / 2;
      this._y -= this.cosness / 2;
      this.cosness = this.speed1 * Math.cos(this.rotationZ * 3.141592653589793 / 180) / 2;
      this.sinness = this.speed1 * Math.sin(this.rotationZ * 3.141592653589793 / 180) / 2;
   }
   static function getInstance()
   {
      return com.racing.gameplay.CoreCar.__inst;
   }
}
