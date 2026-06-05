class com.racing.Game extends MovieClip
{
   var assetManager;
   var course;
   var dataArr;
   static var __inst;
   function Game()
   {
      super();
      com.racing.Game.__inst = this;
      this._visible = false;
      this._alpha = 0;
      this.createEmptyMovieClip("car",2);
      this.createEmptyMovieClip("course",1);
      this.dataArr = com.racing.Application.getInstance().xmlObject.config;
      this.assetManager = com.racing.Application.getInstance().assetManager;
   }
   function loadRace()
   {
      var _loc2_ = com.racing.Application.getInstance();
      this.assetManager.ResetAssetCue();
      this.assetManager.clearClip(this.course);
      this.assetManager.AddAsset("swf",_loc2_.filePath + "tracks/" + this.dataArr.track[_loc2_.SESSION_DATA.curTrack - 1].course.attributes.filename,this.course);
      this.assetManager.AddCallBack(com.dynamicflash.utils.Delegate.create(this,this.loadCar));
      this.assetManager.StartLoadSequence();
   }
   function loadCar()
   {
      var _loc2_ = com.racing.Application.getInstance();
      this.assetManager.ResetAssetCue();
      this.assetManager.clearClip(this.course.scenery.carp);
      this.assetManager.AddAsset("swf",_loc2_.filePath + "drivers/" + this.dataArr.driver[_loc2_.SESSION_DATA.curDriver - 1].car.attributes.filename,this.course.scenery.carp);
      this.assetManager.AddCallBack(com.dynamicflash.utils.Delegate.create(this,this.onRaceLoadComplete));
      this.assetManager.StartLoadSequence();
   }
   function onRaceLoadComplete()
   {
      gs.TweenMax.to(this,0.2,{autoAlpha:100,delay:0.5,onComplete:this.course.wrld.go});
   }
   function resetQuality()
   {
      this._quality = "HIGH";
   }
   function hide()
   {
      gs.TweenMax.to(this,0.2,{autoAlpha:0,delay:0.5});
      gs.TweenMax.delayedCall(1,this.resetQuality,null,this);
   }
   static function initDocumentClass(document)
   {
      com.gnimmel.util.DocumentClass.init(document,com.racing.Game);
   }
   static function getInstance()
   {
      if(com.racing.Game.__inst == undefined)
      {
         com.racing.Game.__inst = new com.racing.Game();
      }
      return com.racing.Game.__inst;
   }
}
