class gmi.projects.mb8.classGameData
{
   var FG_GAME_BASE;
   var FG_SCRIPT_BASE;
   var bDebug;
   var bDictionary;
   var bEmbedFonts;
   var bMeterVisible;
   var bOffline;
   var bTransDebug;
   var iAvgFramerate;
   var iDictVersion;
   var iFramerate;
   var iGameID;
   var iHiscore;
   var iIsMember;
   var iItemID;
   var iNPCap;
   var iNPRatio;
   var iQuestionSet;
   var iScorePosts;
   var iSendGet;
   var iSras;
   var iSrasVals;
   var iStatCivics;
   var iStatHealth;
   var iStatHungerIndex;
   var iStatIntelligence;
   var iStatMillsbucks;
   var iStatStrength;
   var iTypeID;
   var iVerifiedAct;
   var iVersion;
   var objAddVars;
   var objTransLevel;
   var sBaseURL;
   var sDestination;
   var sFilename;
   var sHash;
   var sImageURL;
   var sLang;
   var sPreloader;
   var sQuality;
   var sSK;
   var sStatHunger;
   var sUsername;
   var tLoaded;
   function classGameData()
   {
      this.FG_GAME_BASE = "http://graphics.millsberry.com/";
      this.FG_SCRIPT_BASE = "http://www.millsberry.com/";
      this.bDebug = false;
      this.bTransDebug = false;
      this.bOffline = false;
      this.bDictionary = false;
      this.bMeterVisible = true;
      this.objTransLevel = undefined;
      this.sPreloader = "GMI_prldr_bicycling_V3";
      this.sFilename = "g401_v2";
      this.iGameID = 401;
      this.sUsername = "blix";
      this.iTypeID = 4;
      this.iItemID = 401;
      this.iVersion = 2;
      this.iFramerate = 18;
      this.iDictVersion = 14;
      this.iNPRatio = 0;
      this.iNPCap = 1000;
      this.sDestination = "flashgames/";
      this.sQuality = "HIGH";
      this.iIsMember = 0;
      this.sBaseURL = "www.millsberry.com";
      this.sImageURL = "graphics.millsberry.com";
      this.sHash = "35ba379a5d920acb6f18";
      this.sSK = "35ba379a5d920acb6f18";
      this.iQuestionSet = 0;
      this.iScorePosts = 0;
      this.iVerifiedAct = 1;
      this.iHiscore = 0;
      this.iSendGet = 0;
      this.iStatStrength = 0;
      this.iStatCivics = 0;
      this.iStatHealth = 0;
      this.iStatIntelligence = 0;
      this.sStatHunger = "";
      this.iStatHungerIndex = 0;
      this.iStatMillsbucks = 0;
      this.iSras = 0;
      this.iSrasVals = "";
      this.sLang = "en";
      this.tLoaded = getTimer();
      this.bEmbedFonts = true;
      this.iAvgFramerate = 24;
      this.objAddVars = {};
   }
   function setVar(cVar, val)
   {
      if(this[cVar] != undefined)
      {
         if(val != undefined)
         {
            this[cVar] = val;
            trace(cVar + " set to " + val);
         }
         else
         {
            trace(cVar + " undefined! Using default value: " + this[cVar]);
         }
      }
      else if(val != undefined)
      {
         this.objAddVars[cVar] = val;
         trace(cVar + " does not exist! Added to additional params object: " + this.objAddVars[cVar]);
      }
      else
      {
         trace(cVar + " undefined! Doesn\'t not exist in object either!");
      }
   }
}
