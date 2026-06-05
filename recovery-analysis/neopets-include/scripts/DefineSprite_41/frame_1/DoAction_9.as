function NeoStatus(traceOn)
{
   var _loc1_ = this;
   _loc1_.getHelp = function()
   {
      var _loc1_ = "";
      _loc1_ += "NEOSTATUS.getHelp()\n";
      _loc1_ += "------------------------\n";
      _loc1_ += "CONSTRUCTOR\n";
      _loc1_ += "\tmyNeoStatus = new NeoStatus(traceOn)\n";
      _loc1_ += "PUBLIC METHODS\n";
      _loc1_ += "\tgetHelp()\n";
      _loc1_ += "\tloadMovie(url);                                    // loads an invisible tracking url to one of a predefined set of levels.";
      _loc1_ += "\tunloadAllMovies(url);                             / unloads all tracking urls.  Once they are loaded they are useless (perhaps harmless)";
      _loc1_ += "\tchangeDebugTo (state); \t\t\t\t\t\t// 0,1; //may work locally\n";
      _loc1_ += "COMMON\n";
      _loc1_ += "\tprocessClickGetURL(item_id, windowName [, method ,URLSuffix])\n";
      _loc1_ += "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//item_id = # given to you by stats dept.\n";
      _loc1_ += "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//windowName \'\',\'_blank\',\'_parent\',\'_self\',\'_top\',\'customName\'...\n";
      _loc1_ += "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//[OPTIONAL] method = \'POST\'\n";
      _loc1_ += "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//[OPTIONAL] URLSuffix = \'&nc_value=\'+value //sends additional var(s) when needed\n";
      _loc1_ += "\tprocessClickLoadVariables(item_id, target, method, [type_id, nc_value])\n";
      _loc1_ += "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//item_id = # given to you by stats dept.\n";
      _loc1_ += "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//target = the levelNumber or clipName of where the variables will be returned\n";
      _loc1_ += "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//[OPTIONAL] method = \'GET\' or \'POST\'\n";
      _loc1_ += "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//[OPTIONAL] item_id,nc_value - possibly; counts a click, redirects, rewards points.\n";
      _loc1_ += "\tsendTag(tagName [,URLSuffix])\n";
      _loc1_ += "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//default tagNames are...\n";
      _loc1_ += "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//\'Game Started\', \'Multiplayer Game Started X\',\'Game Finished\', \'Sponsor Item Shown\',\n";
      _loc1_ += "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//\'Sponsor Logo Shown\',\'Sponsor Item Collected\',\'Sponsor Banner Shown\'\n";
      _loc1_ += "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//\'Reached Level x\' --where x is the current round\n";
      _loc1_ += "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//[OPTIONAL] URLSuffix = \'&value=\'+value //sends additional var(s) when needed\n";
      _loc1_ += "UNCOMMON\n";
      _loc1_ += "\tshowAllEvents()\t\t\t\t\t\t\t\t\t//show all events that can be tagged\n";
      _loc1_ += "\taddEvent(tagName, statusCode, offset)\t\t//add a new tagname; statusCode and multiple must be defined by stats dept.\n";
      _loc1_ += "\ttag(tagName)\t\t\t\t\t\t\t\t\t\t//queue a tag\n";
      _loc1_ += "\tshowAllTags()\t\t\t\t\t\t\t\t\t\t//show all tagnames\n";
      _loc1_ += "\tsendAllTags()\t\t\t\t\t\t\t\t\t\t//send all queued tags\n";
      _loc1_ += "\tclearAllTags()\t\t\t\t\t\t\t\t\t\t//clear all queued tags\n";
      _loc1_ += "\tnonMemberOpen(openTypeName)\t\t\t//getURL for openTypeName of \'SIGN UP\' OR \'LOG IN\'";
      return _loc1_;
   };
   _loc1_.Tracer = new np.projects.include.TracerClass(_level100.include.debug,"NeoStatus: ");
   _loc1_.Tracer.trace("Created");
   _loc1_.changeDebugTo(0);
   if(_level0.nsm == undefined)
   {
      _loc1_.multiple = 0;
   }
   else
   {
      _loc1_.multiple = _level0.nsm;
   }
   if(_level0.nsid == undefined)
   {
      _loc1_.item_id = -1;
      if(_loc1_.debug == 1)
      {
         _loc1_.item_id = 1;
         _loc1_.multiple = 1;
         _loc1_.traceon = 1;
      }
   }
   else
   {
      _loc1_.item_id = _level0.nsid;
   }
   var server = _level0.FG_SCRIPT_BASE;
   _loc1_.NEOSTATUS_URL = server + "neostatus.phtml";
   _loc1_.PROCESS_URL = server + "process_click.phtml";
   _loc1_.oTrace = function(message)
   {
      trace("NeoStatus: " + message);
      return 1;
   };
   _loc1_.eTrace = function(message)
   {
      trace("NeoStatus Error: " + message);
      return 1;
   };
   _loc1_.event = function(tagName, statusCode, offset, base_multiple)
   {
      var _loc1_ = this;
      var _loc2_ = offset;
      if(tagName == undefined)
      {
         trace("NeoStatus Error: Event Constructor: Param #1: tagName Not Provided");
         return -1;
      }
      if(statusCode == undefined)
      {
         trace("NeoStatus Error: Event Constructor: Param #2: statusCode Not Provided");
         return -1;
      }
      if(_loc2_ == undefined)
      {
         trace("NeoStatus Error: Event Constructor: Param #3: offset Not Provided");
         return -1;
      }
      if(base_multiple == undefined)
      {
         trace("NeoStatus Error: Event Constructor: Param #4: multiple Not Provided");
         return -1;
      }
      _loc1_.tagName = tagName;
      _loc1_.statusCode = statusCode;
      _loc1_.multiple = base_multiple * _loc2_;
      _loc1_.active = random(_loc2_) + 1 == 1;
      return _loc1_;
   };
   _loc1_.addEvent = function(tagName, statusCode, offset)
   {
      var _loc1_ = this;
      var _loc2_ = statusCode;
      if(_loc1_.eventlist == undefined)
      {
         _loc1_.eventlist = new Object();
      }
      if(_loc1_.eventlist[tagName] != undefined)
      {
         _loc1_.eTrace(" Event (" + _loc1_.eventlist[tagName].tagName + ") is already set to " + _loc1_.eventlist[tagName].statusCode);
         return -1;
      }
      for(var _loc3_ in _loc1_.eventList)
      {
         if(_loc1_.eventList[_loc3_].statusCode == _loc2_)
         {
            _loc1_.eTrace("\tStatusCode (" + _loc2_ + ") is already taken by event(" + _loc1_.eventlist[_loc3_].tagName + ")");
            return -1;
         }
      }
      if(_loc1_.item_id == -1)
      {
         offset = 1;
      }
      _loc1_.eventlist[tagName] = new _loc1_.event(tagName,_loc2_,offset,_loc1_.multiple);
   };
   _loc1_.addEvent("Game Started",900,1);
   var _loc3_ = 1;
   while(_loc3_ <= 4)
   {
      _loc1_.addEvent("Multiplayer Game Started " + _loc3_,900 + _loc3_,1);
      _loc3_ = _loc3_ + 1;
   }
   _loc1_.addEvent("Game Finished",1000,1);
   _loc1_.addEvent("Sent Score",1001,1);
   var l = 1;
   while(l <= 100)
   {
      _loc1_.addEvent("Reached Level " + l,Number(7000 + l),10);
      l++;
   }
   _loc1_.addEvent("Sponsor Item Shown",8010,30);
   _loc1_.addEvent("Sponsor Logo Shown",8020,10);
   _loc1_.addEvent("Sponsor Item Collected",8030,30);
   _loc1_.addEvent("Sponsor Banner Shown",8040,30);
   _loc1_.taglist = new Array();
   _loc1_.sendtag = function(tagName, URLSuffix)
   {
      var _loc1_ = this;
      var _loc2_ = tagName;
      var _loc3_;
      if(Number(_level0.game_tracking) == 1)
      {
         _loc3_ = _level0.FG_SCRIPT_BASE + "track_plays.phtml?game_id=" + _level0.game_id;
         var bNewTracking = false;
         if(_loc2_ == "Game Started")
         {
            bNewTracking = true;
            _loc3_ += "&dowhat=game_starts&multiple=" + _level0.game_multiple;
         }
         else if(_loc2_ == "Game Finished")
         {
            bNewTracking = true;
            _loc3_ += "&dowhat=game_ends&multiple=" + _level0.game_multiple;
         }
         if(bNewTracking)
         {
            loadVariables(_loc3_,_root);
         }
      }
      if(URLSuffix != undefined)
      {
         if(typeof URLSuffix != "string")
         {
            _loc1_.eTrace("Event (" + _loc1_.eventlist[_loc2_].tagName + ") will not be sent. The URLSuffix: " + URLSuffix + " must be type string or undefined.");
            return -1;
         }
         URLSuffix += _level0.nc_referer;
      }
      else
      {
         URLSuffix = "&nc_value=" + _level0.nc_referer;
      }
      if(_loc1_.eventlist[_loc2_].tagName == undefined)
      {
         _loc1_.eTrace("\tThe tagname(" + _loc2_ + ") does not exist.");
         return -1;
      }
      if(_loc1_.eventlist[_loc2_].active == 1)
      {
         if(_loc1_.item_id != -1)
         {
            var sendstring = _loc1_.NEOSTATUS_URL + "?item_id=" + _loc1_.item_id + "&multiple=" + _loc1_.eventlist[_loc2_].multiple + "&status=" + _loc1_.eventlist[_loc2_].statusCode + URLSuffix + "&r=" + random(999999999);
            _loc1_.oTrace("\tSending tag for Event (" + _loc1_.eventlist[_loc2_].tagName + ") = " + sendstring);
            loadVariables(sendstring,_root);
            return 1;
         }
         _loc1_.oTrace("\tThe item_id = " + _loc1_.item_id + ". Event (" + _loc1_.eventlist[_loc2_].tagName + ") will not be sent.");
         return -1;
      }
      _loc1_.oTrace(" Event (" + _loc1_.eventlist[_loc2_].tagName + ").active = " + _loc1_.eventlist[_loc2_].active + ". Tag will not be sent.");
      return -1;
   };
   _loc1_.showAllEvents = function()
   {
      var _loc1_ = this;
      trace("Showing All Events");
      for(var _loc2_ in _loc1_.eventList)
      {
         trace("\tEvent (" + _loc2_ + ") with statusCode: " + _loc1_.eventList[_loc2_].statusCode);
      }
      return 1;
   };
   _loc1_.tag = function(tagName)
   {
      this.taglist.push(tagName);
      this.oTrace("Tagging (" + tagName + ").");
      return 1;
   };
   _loc1_.clearAllTags = function()
   {
      this.taglist = new Array();
      this.oTrace("All Tags Cleared");
      return 1;
   };
   _loc1_.showAllTags = function()
   {
      var _loc2_ = this;
      trace("showAllTags() Called");
      if(_loc2_.taglist.length == 0)
      {
         _loc2_.oTrace("Showing All Tags: No Events are tagged.");
         return -1;
      }
      _loc2_.oTrace("Showing All Tags");
      var _loc1_ = 0;
      while(_loc1_ < _loc2_.taglist.length)
      {
         _loc2_.oTrace("\tTag: " + _loc1_ + " = " + _loc2_.taglist[_loc1_]);
         _loc1_ = _loc1_ + 1;
      }
      return 1;
   };
   _loc1_.sendAllTags = function()
   {
      var _loc2_ = this;
      _loc2_.oTrace("Sending All Tags");
      var _loc1_ = 0;
      while(_loc1_ < _loc2_.taglist.length)
      {
         _loc2_.sendTag(_loc2_.taglist[_loc1_]);
         _loc1_ = _loc1_ + 1;
      }
      _loc2_.clearAllTags();
      return 1;
   };
   _loc1_.processClickGetURL = function(item_id, windowName, method, URLSuffix)
   {
      var _loc1_ = method;
      var _loc2_ = this;
      var _loc3_ = URLSuffix;
      if(typeof item_id != "number")
      {
         _loc2_.eTrace("processClick - Parameter #1 (item_id) must be type Number");
         return -1;
      }
      if(_loc1_.toUpperCase() == "POST")
      {
         _loc1_ = _loc1_.toUpperCase();
      }
      else
      {
         if(_loc1_ != undefined)
         {
            _loc2_.eTrace("processClick - [OPTIONAL] Parameter #3 (method) must \'POST\' //\'GET\' DOESN\'T WORK");
            return -1;
         }
         _loc1_ = "POST";
      }
      if(_loc3_ != undefined)
      {
         if(typeof _loc3_ != "string")
         {
            _loc2_.eTrace("processClick - Optional Parameter #4 (URLSuffix) is improperly formatted. The URLSuffix: " + _loc3_ + " must be type string or undefined.");
            return -1;
         }
      }
      var sendString = _loc2_.PROCESS_URL + "?item_id=" + item_id + _loc3_ + "&random=" + Math.random() * 999999999;
      if(_loc1_ == "POST")
      {
         _loc2_.oTrace("processClickGetURL - (windowName: " + windowName + ", method: " + _loc1_ + ", sendString :" + sendString + " )");
         getURL(sendString,windowName,"POST");
      }
   };
   _loc1_.processClickLoadVariables = function(item_id, targetName, method, type_id, nc_value)
   {
      var _loc1_ = method;
      var _loc3_ = targetName;
      if(typeof item_id != "number")
      {
         this.eTrace("processClick - Parameter #2 (item_id) must be type Number");
         return -1;
      }
      if(_loc1_.toUpperCase() == "POST" or _loc1_.toUpperCase() == "GET")
      {
         _loc1_ = _loc1_.toUpperCase();
      }
      else
      {
         if(_loc1_ != undefined)
         {
            this.eTrace("processClickLoadVariables - Parameter #3 (method) must be \'GET\' or \'POST\'");
            return -1;
         }
         _loc1_ = "POST";
      }
      var _loc2_ = this.PROCESS_URL + "?item_id=" + item_id + "&type_id=" + type_id + "&nc_value=" + nc_value + "&random=" + Math.random() * 999999999;
      if(_loc1_.toUpperCase() == "POST")
      {
         this.oTrace("processClickLoadVariables - (targetName: " + _loc3_ + ", method: " + _loc1_ + ", sendString :" + _loc2_ + " )");
         loadVariables(_loc2_,_loc3_,"POST");
      }
      else
      {
         this.oTrace("processClickLoadVariables - (targetName: " + _loc3_ + ", method: " + _loc1_ + ", sendString :" + _loc2_ + " )");
         loadVariables(_loc2_,_loc3_,"GET");
      }
   };
   _loc1_.startingTrackingLevel = 250;
   _loc1_.currentTrackingLevel = _loc1_.startingTrackingLevel;
   _loc1_.finalTrackingLevel = 50;
   _loc1_.unloadAllMovies = function()
   {
      var _loc2_ = this;
      var _loc1_ = _loc2_.startingTrackingLevel;
      while(_loc1_ <= _loc2_.startingTrackingLevel + _loc2_.finalTrackingLevel)
      {
         unloadMovieNum(_loc1_);
         _loc1_ = _loc1_ + 1;
      }
      _loc2_.currentTrackingLevel = _loc2_.startingTrackingLevel;
   };
   _loc1_.unloadAllMovies();
   _loc1_.loadMovie = function(URL)
   {
      var _loc1_ = this;
      var _loc3_ = URL;
      _loc1_.getNextTrackingLevel = function()
      {
         var _loc1_ = this;
         if(_loc1_.currentTrackingLevel > _loc1_.startingTrackingLevel + _loc1_.finalTrackingLevel)
         {
            _loc1_.currentTrackingLevel = _loc1_.startingTrackingLevel;
         }
         return _loc1_.currentTrackingLevel++;
      };
      if(_level0.offline == 1)
      {
         _loc1_.oTrace("The offline == 1. NeoStatus.loadMovie (\"" + _loc3_ + "\"); will not be sent.");
         return -1;
      }
      var _loc2_ = _loc1_.getNextTrackingLevel();
      loadMovieNum(_loc3_,_loc2_);
      return 1;
   };
   _loc1_.nonMemberOpen = function(tOpenTypeName)
   {
      var _loc1_ = Number(0);
      if(tOpenTypeName.toUpperCase() == "SIGN UP")
      {
         _loc1_ = 3187;
      }
      else if(tOpenTypeName.toUpperCase() == "LOG IN")
      {
         _loc1_ = 3188;
      }
      else
      {
         this.eTrace("nonMemberOpen - Parameter #1 (openTypeName) must be type String and a value of \'SIGN UP\' or \'LOG IN\'.");
         return;
      }
      var type_id = 12;
      var game_id = _level0.game_id != undefined ? _level0.game_id : Number(0);
      var _loc3_ = _level0.nc_referer != undefined ? _level0.nc_referer : Number(0);
      var _loc2_ = String("");
      if(_loc3_ == undefined)
      {
         _loc2_ = _level0.game_id;
      }
      else
      {
         _loc2_ = _level0.game_id + "-" + _loc3_;
      }
      var tURL = "http://www.neopets.com/nc_track.phtml?type_id" + type_id + "&item_id=" + _loc1_ + "&nc_value=" + _loc2_ + "?r=" + Math.random(999999);
      getURL("javascript: var newwin = window.open(\"" + tURL + "\", \"\", \"\" ); window.close();","");
   };
}
