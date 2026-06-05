class com.gnimmel.LoadManager
{
   var CallBack;
   var CurrentAssetCue;
   var MCLoader;
   var MCLoaderListener;
   var MCPreLoaderInt;
   var PreLoadIndex;
   var TotalAssets;
   var XMLAsset;
   var XMLPreLoaderInt;
   static var __inst;
   var Asset_array = new Array();
   var AssetProgress_array = new Array();
   function LoadManager()
   {
      mx.events.EventDispatcher.initialize(this);
      this.InitMovieClipEvents();
      this.ResetAssetCue();
      com.gnimmel.LoadManager.__inst = this;
   }
   function addEventListener(type, handler)
   {
   }
   function removeEventListener(type, handler)
   {
   }
   function dispatchEvent(e)
   {
   }
   function AddAsset($type, $source, $target)
   {
      var _loc2_ = new Object();
      _loc2_.assetType = $type;
      _loc2_.assetSource = $source;
      _loc2_.assetTarget = $target;
      this.Asset_array.push(_loc2_);
      this.AssetProgress_array.push(0);
      this.TotalAssets = this.TotalAssets + 1;
   }
   function AddCallBack($functionName)
   {
      this.CallBack = $functionName;
   }
   function ResetAssetCue()
   {
      this.CurrentAssetCue = 0;
      this.TotalAssets = 0;
      this.PreLoadIndex = 0;
      this.CallBack = undefined;
      delete this.AssetProgress_array;
      delete this.Asset_array;
      this.AssetProgress_array = new Array();
      this.Asset_array = new Array();
   }
   function StartLoadSequence()
   {
      var _loc2_ = new Object();
      _loc2_.type = "onStart";
      _loc2_.target = this;
      this.dispatchEvent(_loc2_);
      this.PreLoadIndex = 0;
      this.LoadNextAsset();
   }
   function UpdateProgress()
   {
      var _loc3_ = 0;
      var _loc6_ = this.TotalAssets * 100;
      var _loc2_ = 0;
      while(_loc2_ < this.TotalAssets)
      {
         _loc3_ += this.AssetProgress_array[_loc2_];
         _loc2_ = _loc2_ + 1;
      }
      var _loc4_ = Math.round(_loc3_ / _loc6_ * 100);
      if(_loc4_ < 0)
      {
         _loc4_ = 0;
      }
      if(_loc4_ > 100)
      {
         _loc4_ = 100;
      }
      var _loc5_ = new Object();
      _loc5_.type = "onProgress";
      _loc5_.target = this;
      _loc5_.total = _loc4_;
      this.dispatchEvent(_loc5_);
   }
   function LoadNextAsset()
   {
      this.CurrentAssetCue = this.PreLoadIndex;
      var _loc2_;
      var _loc4_;
      var _loc5_;
      var _loc3_;
      if(this.PreLoadIndex < this.TotalAssets)
      {
         _loc2_ = new Object();
         _loc2_.type = "onNext";
         _loc2_.target = this;
         this.dispatchEvent(_loc2_);
         _loc4_ = this.Asset_array[this.PreLoadIndex].assetSource;
         _loc5_ = this.Asset_array[this.PreLoadIndex].assetTarget;
         _loc3_ = this.Asset_array[this.PreLoadIndex].assetType;
         if(_loc3_ == "xml")
         {
            this.LoadXMLAsset(_loc4_,_loc5_);
         }
         if(_loc3_ == "swf")
         {
            this.MCLoader.loadClip(_loc4_,_loc5_);
         }
      }
      else
      {
         _loc2_ = new Object();
         _loc2_.type = "onComplete";
         _loc2_.target = this;
         this.dispatchEvent(_loc2_);
         this.CallBack();
      }
   }
   function LoadXMLAsset($file, $target)
   {
      this.XMLAsset = new XML();
      this.XMLAsset = $target;
      this.XMLAsset.ignoreWhite = true;
      if($file)
      {
         this.XMLAsset.onLoad = com.dynamicflash.utils.Delegate.create(this,this.OnXMLLoad);
         this.StartXMLPreloader();
         this.XMLAsset.load($file);
      }
   }
   function StartXMLPreloader()
   {
      this.XMLPreLoaderInt = setInterval(this,"UpdateXMLProgress",100);
   }
   function UpdateXMLProgress()
   {
      var _loc2_ = this.XMLAsset.getBytesLoaded();
      if(_loc2_ <= 0)
      {
         _loc2_ = 0;
      }
      var _loc3_ = this.XMLAsset.getBytesTotal();
      if(_loc3_ <= 0)
      {
         _loc3_ = 0;
      }
      var _loc4_ = _loc2_ / _loc3_ * 100;
      this.AssetProgress_array[this.CurrentAssetCue] = _loc4_;
      this.UpdateProgress();
   }
   function UpdateMCProgress()
   {
      var _loc3_ = _level0.getBytesLoaded();
      if(_loc3_ <= 0)
      {
         _loc3_ = 0;
      }
      var _loc2_ = _level0.getBytesTotal();
      if(_loc2_ <= 0)
      {
         _loc2_ = 0;
      }
      var _loc4_ = _loc3_ / _loc2_ * 100;
      this.AssetProgress_array[this.CurrentAssetCue] = _loc4_;
      this.UpdateProgress();
      if(_loc3_ >= _loc2_ && _loc2_ > 0)
      {
         clearInterval(this.MCPreLoaderInt);
         this.AssetProgress_array[this.CurrentAssetCue] = 100;
         this.PreLoadIndex = this.PreLoadIndex + 1;
         this.LoadNextAsset();
      }
   }
   function OnXMLLoad(success)
   {
      clearInterval(this.XMLPreLoaderInt);
      if(success)
      {
         this.AssetProgress_array[this.CurrentAssetCue] = 100;
         this.PreLoadIndex = this.PreLoadIndex + 1;
         this.LoadNextAsset();
      }
      else
      {
         trace("XML Error ==============");
      }
   }
   function InitMovieClipEvents()
   {
      this.MCLoader = new MovieClipLoader();
      this.MCLoaderListener = new Object();
      this.MCLoaderListener.onLoadProgress = com.dynamicflash.utils.Delegate.create(this,this.MCLoaderOnLoadProgress);
      this.MCLoaderListener.onLoadInit = com.dynamicflash.utils.Delegate.create(this,this.MCLoaderOnLoadComplete);
      this.MCLoaderListener.onLoadError = com.dynamicflash.utils.Delegate.create(this,this.MCLoaderOnLoadError);
      this.MCLoader.addListener(this.MCLoaderListener);
   }
   function MCLoaderOnLoadProgress(targetMC, loadedBytes, totalBytes)
   {
      var _loc2_ = loadedBytes / totalBytes * 100;
      this.AssetProgress_array[this.CurrentAssetCue] = _loc2_;
      this.UpdateProgress();
   }
   function MCLoaderOnLoadComplete()
   {
      this.AssetProgress_array[this.CurrentAssetCue] = 100;
      this.PreLoadIndex = this.PreLoadIndex + 1;
      this.LoadNextAsset();
   }
   function MCLoaderOnLoadError(targetMC, errorCode)
   {
      trace("ERRORCODE:" + errorCode + " : " + targetMC + "Failed to load its content");
   }
   function clearClip($clip)
   {
      this.MCLoader.unloadClip($clip);
   }
   static function getInstance()
   {
      return com.gnimmel.LoadManager.__inst;
   }
}
