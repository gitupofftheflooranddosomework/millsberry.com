class com.racing.Application extends MovieClip
{
   var SESSION_DATA;
   var assetManager;
   var filePath;
   var game;
   var isLive;
   var screens;
   var xmlApp;
   var xmlObject;
   var xmlParser;
   static var __inst;
   function Application()
   {
      super();
      com.racing.Application.__inst = this;
      this.xmlParser = new com.gnimmel.util.xml.XMLObjectOutput();
      this.xmlObject = new Object();
      this.assetManager = new com.gnimmel.LoadManager();
      this.xmlApp = new XML();
      this.isLive = this != _level0;
      this.filePath = !com.gnimmel.util.Utilities.isInBrowser() ? "" : _level0._MB8_GAME_DATA.FG_GAME_BASE + "flashgames/racing/";
      this.initSessionData();
      this.requestConfigFile();
   }
   function initSessionData()
   {
      this.SESSION_DATA = {curDriver:0,curTrack:0};
   }
   function requestConfigFile()
   {
      this.assetManager.AddAsset("xml",this.filePath + "config.xml",this.xmlApp);
      this.assetManager.AddCallBack(com.dynamicflash.utils.Delegate.create(this,this.onConfigLoad));
      this.assetManager.StartLoadSequence();
   }
   function onConfigLoad()
   {
      this.xmlObject = this.xmlParser.XMLToObject(this.xmlApp);
      this.initApp();
   }
   function goGame()
   {
      var _loc1_ = new com.racing.StateManager();
   }
   function initApp()
   {
      var _loc2_ = this.createEmptyMovieClip("screens",this.getNextHighestDepth());
      _loc2_._alpha = 0;
      _loc2_._visible = false;
      this.assetManager.AddAsset("swf",this.filePath + "screens.swf",_loc2_);
      this.addDrivers();
      this.addTracks();
      this.createEmptyMovieClip("game",1111);
      this.assetManager.AddAsset("swf",this.filePath + "game.swf",this.game);
      var _loc3_ = this.createEmptyMovieClip("soundlib",1121);
      this.assetManager.AddAsset("swf",this.filePath + "soundLibrary.swf",_loc3_);
      this.assetManager.AddCallBack(com.dynamicflash.utils.Delegate.create(this,this.onAssetLoadComplete));
      this.assetManager.StartLoadSequence();
   }
   function addDrivers()
   {
      var _loc5_ = this.xmlObject.config.driver;
      var _loc6_ = _loc5_.length;
      var _loc2_;
      var _loc3_;
      var _loc4_;
      _loc2_ = 0;
      while(_loc2_ < _loc6_)
      {
         _loc3_ = this.createEmptyMovieClip("driverThumb" + (_loc2_ + 1),this.getNextHighestDepth());
         _loc4_ = _loc5_[_loc2_].thumbnail.attributes.filename;
         this.assetManager.AddAsset("swf",this.filePath + "drivers/" + _loc4_,_loc3_);
         _loc2_ = _loc2_ + 1;
      }
   }
   function addTracks()
   {
      var _loc5_ = this.xmlObject.config.track;
      var _loc6_ = _loc5_.length;
      var _loc2_;
      var _loc3_;
      var _loc4_;
      _loc2_ = 0;
      while(_loc2_ < _loc6_)
      {
         _loc3_ = this.createEmptyMovieClip("trackThumb" + (_loc2_ + 1),this.getNextHighestDepth());
         _loc4_ = _loc5_[_loc2_].thumbnail.attributes.filename;
         this.assetManager.AddAsset("swf",this.filePath + "tracks/" + _loc4_,_loc3_);
         _loc2_ = _loc2_ + 1;
      }
   }
   function onAssetLoadComplete()
   {
      this.screens._alpha = 100;
      this.screens._visible = true;
      this.screens.home.show();
   }
   static function initDocumentClass(document)
   {
      com.gnimmel.util.DocumentClass.init(document,com.racing.Application);
   }
   static function getInstance()
   {
      if(com.racing.Application.__inst == undefined)
      {
         com.racing.Application.__inst = new com.racing.Application();
      }
      return com.racing.Application.__inst;
   }
}
