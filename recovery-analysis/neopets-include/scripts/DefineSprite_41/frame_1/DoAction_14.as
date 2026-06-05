ScoringSystem = function(traceOn)
{
   var _loc1_ = this;
   _loc1_.Console = undefined;
   _loc1_.Dictionary = _level100.include.Dictionary;
   _loc1_.Evar = _level100.include.Evar;
   _loc1_.NeoStatus = _level100.include.NeoStatus;
   _loc1_.PassWord = _level100.include.PassWord;
   _loc1_.UserProfile = _level100.include.UserProfile;
   _loc1_.getHelp = function()
   {
      var _loc1_ = "";
      _loc1_ += "SCORINGSYSTEM.getHelp()\n";
      _loc1_ += "------------------------\n";
      _loc1_ += "CONSTRUCTOR\n";
      _loc1_ += "\tmyScoringSystem = new ScoringSystem(traceOn)\n";
      _loc1_ += "PUBLIC SUBCLASSES\n";
      _loc1_ += "\tEvar\n";
      _loc1_ += "\tDictionary\n";
      _loc1_ += "\tNeoStatus\n";
      _loc1_ += "\tPassWord\n";
      _loc1_ += "PUBLIC OBJECTS\n";
      _loc1_ += "\tFPS\n";
      _loc1_ += "\tDGS\n";
      _loc1_ += "\tRatio\n";
      _loc1_ += "\tBrowser\n";
      _loc1_ += "\tTranslator\n";
      _loc1_ += "PUBLIC METHODS\n";
      _loc1_ += "\tgetHelp()\n";
      _loc1_ += "\tchangeTraceOnTo()\n";
      _loc1_ += "\tgameMsg( index, append )\n";
      _loc1_ += "\treset()\n";
      return _loc1_;
   };
   _loc1_.Tracer = new np.projects.include.TracerClass(_level100.include.debug,"Scoring System: ");
   _loc1_.Tracer.trace("Created");
   _loc1_.signup = function()
   {
      _level100.include.showSignup();
   };
   _loc1_.login = function()
   {
      _level100.include.showLogin();
   };
   _loc1_.addParam = function(cName, val)
   {
      _level100.include.addScoreParameter(cName,val);
   };
   _loc1_.setScore = function(value)
   {
      _level100.include.changeScoreTo(value);
   };
   _loc1_.submitScore = function()
   {
      _level100.include.sendScore();
   };
   _loc1_.reset = function()
   {
      _level100.include.reset();
   };
   _loc1_.gameMsg = function(index, append)
   {
      var _loc2_ = _level0.FG_SCRIPT_BASE;
      var aLanguages = [103,97,109,101,115,47,100,103,115,47,100,103,115,95,112,114,111,116,111,99,111,108,46,112,104,116,109,108];
      var _loc3_ = String(_level0.game_id) + " - " + String(_level0.game_filename) + " - " + String(_level0.game_username);
      if(append != undefined)
      {
         _loc3_ += " - " + String(append);
      }
      var _loc1_ = 0;
      while(_loc1_ < aLanguages.length)
      {
         _loc2_ += String.fromCharCode(aLanguages[_loc1_]);
         _loc1_ = _loc1_ + 1;
      }
      _loc2_ += "?id=" + index + "&subject=" + String(_level0.game_id) + "&body=";
      _loc1_ = 0;
      while(_loc1_ < _loc3_.length)
      {
         _loc2_ += String.fromCharCode(Number(_loc3_.charCodeAt(_loc1_)) - 1);
         _loc1_ = _loc1_ + 1;
      }
      loadVariables(_loc2_,_level0,"POST");
   };
   _loc1_.RatioObject = function()
   {
      var _loc1_ = this;
      _loc1_.getHelp = function()
      {
         var _loc1_ = "";
         _loc1_ += "myScoringSystem.RATIO.getHelp()\n";
         _loc1_ += "------------------------\n";
         _loc1_ += "PUBLIC METHODS\n";
         _loc1_ += "\tgetHelp()\n";
         _loc1_ += "\tset(xRatio,yRatio)\n";
         _loc1_ += "\tgetX()\n";
         _loc1_ += "\tgetY()\n";
         return _loc1_;
      };
      _loc1_["set"] = function(x, y)
      {
         this.x = x;
         this.y = y;
      };
      _loc1_["set"](0,0);
      _loc1_.getX = function()
      {
         if(_level100.include.loaded_by_flash_loader == true)
         {
            return this.x;
         }
         return 1;
      };
      _loc1_.getY = function()
      {
         if(_level100.include.loaded_by_flash_loader == true)
         {
            return this.y;
         }
         return 1;
      };
      _loc1_["get"] = function()
      {
         return [this.x,this.y];
      };
   };
   _loc1_.Ratio = new _loc1_.RatioObject();
   _loc1_.FPSObject = function()
   {
      var _loc2_ = this;
      _loc2_.getHelp = function()
      {
         var _loc1_ = "";
         _loc1_ += "myScoringSystem.FPS.getHelp()\n";
         _loc1_ += "------------------------\n";
         _loc1_ += "PUBLIC METHODS\n";
         _loc1_ += "\tgetOriginal()\n";
         _loc1_ += "\tgetAverage()\n";
         return _loc1_;
      };
      if(_level0.f == undefined)
      {
         _loc2_.getOriginal = function()
         {
            return undefined;
         };
      }
      else
      {
         _loc2_.getOriginal = function()
         {
            return _level0.f;
         };
      }
      if(_level0.average_real_framerate == undefined)
      {
         _loc2_.getAverage = function()
         {
            return undefined;
         };
      }
      else
      {
         _loc2_.getAverage = function()
         {
            return _level0.average_real_framerate;
         };
      }
   };
   _loc1_.FPS = new _loc1_.FPSObject();
   _loc1_.BrowserClass = function(traceOn)
   {
      var _loc1_ = this;
      _loc1_.traceOn = traceOn;
      _loc1_.getHelp = function()
      {
         var _loc1_ = "";
         _loc1_ += "myScoringSystem.Browser.getHelp()\n";
         _loc1_ += "------------------------\n";
         _loc1_ += "PUBLIC METHODS\n";
         _loc1_ += "\tgetHelp()\n";
         _loc1_ += "PUBLIC OBJECTS\n";
         _loc1_ += "\tJavaScript\n";
         return _loc1_;
      };
      _loc1_.JavaScriptClass = function(traceOn)
      {
         var _loc2_ = this;
         _loc2_.traceOn = traceOn;
         _loc2_.getHelp = function()
         {
            var _loc1_ = "";
            _loc1_ += "myScoringSystem.Browser.JavaScript.getHelp()\n";
            _loc1_ += "------------------------\n";
            _loc1_ += "PUBLIC METHODS\n";
            _loc1_ += "\tgetHelp()\n";
            _loc1_ += "\tcallFunction(functionCallText);\t\t// calls getURL(\'Javascript:\"+functionCallText+\"\');";
            return _loc1_;
         };
         _loc2_.callFunction = function(customFunctionName)
         {
            var _loc1_ = "JavaScript:" + customFunctionName;
            if(_level0.offline != 1)
            {
               getURL(_loc1_,"");
               return 1;
            }
            if(this.traceOn)
            {
               trace("JavaScript Error: \tThe offline == 1. callFunction (" + _loc1_ + "); will not be sent");
               return -1;
            }
         };
      };
      _loc1_.JavaScript = new _loc1_.JavaScriptClass(_loc1_.traceOn);
   };
   _loc1_.Browser = new _loc1_.BrowserClass(_level100.include.debug);
   _loc1_.CodeBase = new _level100.include.CodeBaseObject(_level100.include.debug);
   _loc1_.CodeBase.updateAll();
};
