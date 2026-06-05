class com.racing.screens.Home extends com.racing.screens.ScreenBase
{
   var __shell;
   var clint;
   var dly;
   var instructPanel;
   var instructions;
   var introPanel;
   var startGame;
   static var __inst;
   function Home(mc)
   {
      super();
      com.racing.screens.Home.__inst = this;
      this.__shell = mc;
      this.init();
      this.hide();
   }
   function init()
   {
      this.clint = this.__shell.clint;
      this.instructions = this.__shell.instructions;
      this.startGame = this.__shell.startGame;
      this.introPanel = this.__shell.introPanel;
      this.instructPanel = this.__shell.instructPanel;
      this.defineCoords(this.clint);
      this.defineCoords(this.instructions);
      this.defineCoords(this.startGame);
      this.defineCoords(this.introPanel);
      this.initHandlers();
   }
   function show()
   {
      this.dly = 0.1;
      com.racing.Logo.update("home",0.2);
      this.showItem(this.clint,0.6);
      this.showItem(this.introPanel,0.4);
      this.showItem(this.instructions,0.07);
      this.showItem(this.startGame,0);
   }
   function hide()
   {
      var _loc2_ = Stage.width;
      gs.TweenMax.to(this.clint,0.5,{_x:-500,ease:gs.easing.Cubic.easeInOut});
      gs.TweenMax.to(this.instructions,0.5,{_x:_loc2_ + 200,_y:this.instructions.Y + 200,ease:gs.easing.Cubic.easeInOut,onComplete:this.onHideComplete,onCompleteParams:[this.instructions]});
      gs.TweenMax.to(this.startGame,0.5,{_x:_loc2_ + 200,_y:this.startGame.Y - 100,ease:gs.easing.Cubic.easeInOut,onComplete:this.onHideComplete,onCompleteParams:[this.startGame]});
      gs.TweenMax.to(this.introPanel,0.6,{_x:_loc2_ + 400,_y:this.introPanel.Y - 100,ease:gs.easing.Cubic.easeInOut,onComplete:this.onHideComplete,onCompleteParams:[this.introPanel]});
      this.instructPanel.hide();
   }
   function initHandlers()
   {
      this.instructions.onRelease = com.dynamicflash.utils.Delegate.create(this.instructPanel,this.instructPanel.show);
      this.startGame.onRelease = com.racing.StateManager.goDrivers;
   }
   static function getInstance()
   {
      if(com.racing.screens.Home.__inst == undefined)
      {
         com.racing.screens.Home.__inst = new com.racing.screens.Home();
      }
      return com.racing.screens.Home.__inst;
   }
}
