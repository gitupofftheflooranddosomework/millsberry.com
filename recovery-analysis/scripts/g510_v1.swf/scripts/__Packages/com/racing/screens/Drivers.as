class com.racing.screens.Drivers
{
   var __shell;
   var driversTitle;
   static var __inst;
   function Drivers(mc)
   {
      com.racing.screens.Drivers.__inst = this;
      this.__shell = mc;
      this.driversTitle = this.__shell.driversTitle;
      this.init();
      this.hide();
   }
   function init()
   {
      this.driversTitle.X = this.driversTitle._x;
      this.driversTitle.Y = this.driversTitle._y;
   }
   function show()
   {
      com.racing.Logo.update("drivers",0.1);
      gs.TweenMax.to(this.driversTitle,0.5,{_y:this.driversTitle.Y,ease:gs.easing.Bounce.easeOut});
      var _loc3_ = com.racing.Application.getInstance().xmlObject.config.driver.length;
      var _loc2_ = 1;
      while(_loc2_ <= _loc3_)
      {
         this.__shell._parent["driverThumb" + _loc2_].panel.show();
         _loc2_ = _loc2_ + 1;
      }
   }
   function hide()
   {
      gs.TweenMax.to(this.driversTitle,0.5,{_y:-100,ease:gs.easing.Back.easeInOut});
      var _loc3_ = com.racing.Application.getInstance().xmlObject.config.driver.length;
      var _loc2_ = 1;
      while(_loc2_ <= _loc3_)
      {
         this.__shell._parent["driverThumb" + _loc2_].panel.hide();
         _loc2_ = _loc2_ + 1;
      }
   }
   static function getInstance()
   {
      if(com.racing.screens.Drivers.__inst == undefined)
      {
         com.racing.screens.Drivers.__inst = new com.racing.screens.Drivers();
      }
      return com.racing.screens.Drivers.__inst;
   }
}
