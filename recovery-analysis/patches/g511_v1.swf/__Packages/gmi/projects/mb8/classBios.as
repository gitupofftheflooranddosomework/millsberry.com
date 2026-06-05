class gmi.projects.mb8.classBios
{
   var bDebug;
   var bDictionary;
   var bLocal;
   var bTranslate;
   var gameTranslationSuccess;
   var gameTranslation_lis;
   var iLoadState;
   var iScoringMeterHeight;
   var iScoringMeterWidth;
   var mcBios;
   var nVersion;
   var objGameData;
   var objGameRoot;
   var objRoot;
   var objTracer;
   var sIncludeFileName;
   var sLocal_DICT_URL;
   var sLocal_INCLUDE_URL;
   function classBios(mcBL, objGR, version)
   {
      this.mcBios = mcBL;
      this.objGameRoot = objGR;
      this.nVersion = version;
      var _loc3_ = String(this.objGameRoot);
      this.bLocal = _loc3_.indexOf("_level0") < 0 ? false : true;
      this.iLoadState = 0;
      this.bDebug = this.mcBios.debug;
      this.bTranslate = this.mcBios.translation;
      this.bDictionary = this.mcBios.dictionary;
      this.iScoringMeterWidth = 300;
      this.iScoringMeterHeight = 120;
      this.objTracer = new gmi.projects.mb8.classTracer(this.bDebug,"MB8 BIOS: ");
      this.objTracer.trace("Initializing...",true);
      if(this.bLocal)
      {
         this.objGameData = new gmi.projects.mb8.classGameData();
      }
      else
      {
         this.objGameData = _level0._MB8_GAME_DATA;
      }
      var _loc2_ = "//neoserver/neoserver3/multimedia/websites_like_gmi/gmi/gaming_system/";
      var _loc4_ = this.mcBios.local_path;
      this.sIncludeFileName = "mb" + this.nVersion + "_include.swf";
      this.sLocal_INCLUDE_URL = _loc4_ + this.sIncludeFileName;
      this.sLocal_DICT_URL = _loc2_ + "dictionary/flash_dictionary_en_v" + this.objGameData.iDictVersion + ".swf";
      this.gameTranslationSuccess = false;
      this.gameTranslation_lis = new Object();
      this.gameTranslation_lis.objRoot = this.objGameRoot;
      this.gameTranslation_lis.onLoad = function(event)
      {
         this.objRoot._MB8_objLB.gameTranslationSuccess = true;
      };
      this.objGameRoot.Translator.addEventListener("onLoad",this.gameTranslation_lis);
   }
   function main()
   {
      if(this.iLoadState != 999)
      {
         this.objGameData.FG_GAME_BASE = _level0.FG_GAME_BASE;
         this.objGameData.FG_SCRIPT_BASE = _level0.FG_GAME_BASE;
         this.objGameRoot._MB8_GAME_DATA = this.objGameData;
         this.objGameRoot.play();
         this.iLoadState = 999;
      }
      return;
      switch(this.iLoadState)
      {
         case 0:
            this.mcBios.mcChip._alpha += 10;
            if(this.mcBios.mcChip._alpha >= 100)
            {
               this.iLoadState = 1;
            }
            break;
         case 1:
            if(this.bLocal)
            {
               this.loadInclude_SWF();
               this.iLoadState = 2;
            }
            else
            {
               this.iLoadState = 3;
            }
            break;
         case 2:
            if(this.includeIsLoaded())
            {
               this.iLoadState = 3;
            }
            break;
         case 3:
            this.objTracer.trace("Setting Game Data...");
            if(this.bLocal)
            {
               this.setLocalIncludeData();
               for(var _loc3_ in this.objGameData)
               {
                  if(String(_loc3_) == "objAddVars")
                  {
                     for(var _loc2_ in this.objGameData[_loc3_])
                     {
                        _level100.include.setGameDataAdd(_loc3_,_loc2_,this.objGameData[_loc3_][_loc2_]);
                     }
                  }
                  else
                  {
                     _level100.include.setGameData(_loc3_,this.objGameData[_loc3_]);
                  }
               }
            }
            else
            {
               this.setLiveIncludeData();
            }
            this.iLoadState = 4;
            break;
         case 4:
            this.objTracer.trace("Create System Objects...");
            _level100.include.createSystemObjects(this.bDictionary);
            if(this.bLocal)
            {
               this.setTranslatorProps(this.objGameData);
               if(this.bTranslate)
               {
                  this.iLoadState = 5;
               }
               else
               {
                  this.iLoadState = 7;
               }
            }
            else
            {
               this.setTranslatorProps(_level100.include._MB8_GAME_DATA);
               this.iLoadState = 7;
            }
            break;
         case 5:
            this.gameTranslation();
            this.iLoadState = 6;
            break;
         case 6:
            if(this.gameTranslationSuccess)
            {
               this.iLoadState = 7;
            }
            break;
         case 7:
            if(this.bLocal || _level0._MB8_bGameLoaded)
            {
               this.objTracer.trace("Starting Game...");
               this.objGameRoot.play();
               this.iLoadState = 999;
            }
         default:
            return;
      }
   }
   function loadInclude_SWF()
   {
      var _loc2_ = "";
      if(this.bLocal)
      {
         if(this.mcBios.load_local)
         {
            _loc2_ = this.sLocal_INCLUDE_URL;
            this.objTracer.trace("Loading local Include...",true);
         }
         else
         {
            this.objTracer.trace("Loading Include from " + this.mcBios.game_server + "...");
            _loc2_ = "http://" + this.mcBios.game_server + "/gamingsystem/flash8/" + this.sIncludeFileName + "?r=" + random(99999);
         }
      }
      else
      {
         _loc2_ = _level0.FG_GAME_BASE + "gamingsystem/flash8/" + this.sIncludeFileName + "?r=" + random(99999);
      }
      loadMovieNum(_loc2_,100);
   }
   function includeIsLoaded()
   {
      var _loc1_ = false;
      var _loc2_ = int(_level100.getBytesLoaded() / _level100.getBytesTotal() * 100);
      if(_loc2_ >= 100)
      {
         _loc1_ = true;
      }
      return _loc1_;
   }
   function setLocalIncludeData()
   {
      this.objGameData.FG_GAME_BASE = "http://" + this.mcBios.game_server + "/";
      this.objGameData.FG_SCRIPT_BASE = "http://" + this.mcBios.script_server + "/";
      this.objGameData.bDebug = this.mcBios.debug;
      this.objGameData.bTransDebug = this.mcBios.trans_debug;
      this.objGameData.bOffline = this.bLocal;
      this.objGameData.bDictionary = this.bDictionary;
      this.objGameData.bMeterVisible = this.mcBios.metervisible;
      this.objGameData.objTransLevel = _level0;
      this.objGameData.iGameID = this.mcBios.game_id;
      this.objGameData.sLang = this.mcBios.game_lang;
      this.objGameData.iSras = this.mcBios.iSras;
      this.objGameData.iSrasVals = this.mcBios.iSrasVals;
      _level100.include._x = this.mcBios.meterX + this.iScoringMeterWidth / 2;
      _level100.include._y = this.mcBios.meterY + this.iScoringMeterHeight / 2;
   }
   function setLiveIncludeData()
   {
      _level100.include._MB8_GAME_DATA.bDictionary = this.bDictionary;
      _level100.include._MB8_GAME_DATA.bMeterVisible = this.mcBios.metervisible;
      var _loc3_ = 1000 / this.mcBios._width;
      var _loc2_ = 1000 / this.mcBios._height;
      _level100.include._width = int(this.iScoringMeterWidth * _loc3_);
      _level100.include._height = int(this.iScoringMeterHeight * _loc2_);
      var _loc5_ = int(this.mcBios.meterX * _loc3_);
      var _loc4_ = int(this.mcBios.meterY * _loc2_);
      _level100.include._x = _loc5_ + int(this.iScoringMeterWidth / 2 * _loc3_);
      _level100.include._y = _loc4_ + int(this.iScoringMeterHeight / 2 * _loc2_);
   }
   function setTranslatorProps(oGD)
   {
      this.objGameRoot.Translator.setPlayMode("MANUAL");
      this.objGameRoot.Translator.setDebug(oGD.bTransDebug);
      this.objGameRoot.Translator.setTarget(_level0);
      var _loc3_ = oGD.FG_SCRIPT_BASE + "transcontent/gettranslationxml.phtml";
      this.objGameRoot.Translator.setTranslationScriptURL(_loc3_);
      this.objTracer.trace("Loading Translation: " + _loc3_,true);
      this.objGameRoot.Translator.setLang(oGD.sLang);
      this.objGameRoot.Translator.setTypeID(4);
      this.objGameRoot.Translator.setItemID(oGD.iGameID);
   }
   function gameTranslation()
   {
      this.objGameRoot.Translator.translate();
   }
}
