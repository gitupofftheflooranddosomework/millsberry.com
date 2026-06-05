class com.racing.screens.Tracks
{
   var __shell;
   static var __inst;
   function Tracks(mc)
   {
      com.racing.screens.Tracks.__inst = this;
      this.__shell = mc;
      this.defineCoords(this.__shell.startRace);
      this.defineCoords(this.__shell.trackTitle);
      this.hide();
      this.initHandlers();
   }
   function show()
   {
      com.racing.Logo.update("tracks",0);
      gs.TweenMax.to(this.__shell.trackTitle,0.5,{_y:this.__shell.trackTitle.Y,ease:gs.easing.Bounce.easeOut,delay:0.6});
      gs.TweenMax.to(this.__shell.startRace,0.6,{_x:this.__shell.startRace.X,ease:gs.easing.Back.easeOut,delay:0.8});
      var _loc3_ = com.racing.Application.getInstance().xmlObject.config.track.length;
      var _loc2_ = 1;
      while(_loc2_ <= _loc3_)
      {
         this.__shell._parent["trackThumb" + _loc2_].panel.show();
         _loc2_ = _loc2_ + 1;
      }
   }
   function hide()
   {
      gs.TweenMax.to(this.__shell.startRace,0.5,{_x:-200,ease:gs.easing.Cubic.easeInOut});
      gs.TweenMax.to(this.__shell.trackTitle,0.4,{_y:-100,ease:gs.easing.Back.easeInOut});
      var _loc3_ = com.racing.Application.getInstance().xmlObject.config.track.length;
      var _loc2_ = 1;
      while(_loc2_ <= _loc3_)
      {
         this.__shell._parent["trackThumb" + _loc2_].panel.hide();
         _loc2_ = _loc2_ + 1;
      }
   }
   function initHandlers()
   {
      this.__shell.startRace.onRelease = com.dynamicflash.utils.Delegate.create(com.racing.StateManager,com.racing.StateManager.goRace,com.racing.screens.Tracks.__inst);
   }
   function defineCoords(c)
   {
      c.X = c._x;
      c.Y = c._y;
   }
   static function getInstance()
   {
      if(com.racing.screens.Tracks.__inst == undefined)
      {
         com.racing.screens.Tracks.__inst = new com.racing.screens.Tracks();
      }
      return com.racing.screens.Tracks.__inst;
   }
}
