function GameObject()
{
   var _loc1_ = this;
   var _loc2_ = _root;
   _loc2_.depth = new Object();
   _loc2_.depth.scoreBoard = 10;
   _loc2_.depth.playGround = 20;
   _loc2_.depth.wordBank = 30;
   _loc2_.depth.markedSpot = 2000;
   _loc2_.depth.gameOverTimer = 9700;
   _global.Screen = new Object();
   Screen = _loc2_.backGround.getBounds(_loc2_);
   Screen.centerX = Screen.xMax / 2 + _loc2_.sideBar._width;
   Screen.centerY = Screen.yMax / 2;
   Screen._width = 720 + _loc2_.sideBar._width;
   Screen._height = 540;
   _loc1_.init = function()
   {
      var _loc1_ = this;
      var _loc2_ = _root;
      var _loc3_ = _global;
      _loc2_.depth = new Object();
      _loc2_.depth.playGround = 20;
      _loc2_.depth.wordBank = 30;
      _loc2_.depth.scoreBoard = 9000;
      _loc1_.clearAll = new Array();
      Game.maxWordLength = 6;
      _loc1_.specialWords = ["BURGER","CEREAL","COMEDY","DINNER","ERASER","HOTDOG","JUICES","LOCKER","MOVIES","PENCIL","PIZZAS","RACING","SALADS","SCHOOL","SHARKS","SKIING","SNAKES","SOCCER","SUMMER","VIDEOS","SNACKS","APPLES","SMILES","HORSES","WINTER","BINDER","RACING","FOLDER"];
      _loc1_.SNACKS_LIST = ["ASKS","CASKS","CASK","SKA","SAC","ASK","SNACKS","SACKS","SACS","AS","SACK","AN","SANK","CAN","CANS","SCANS","SCAN","SNACK"];
      _loc1_.APPLES_LIST = ["SALE","SEAL","PEALS","PEAL","LA","PEAS","PLEAS","SEA","PEA","PLEA","PAL","PALES","PALS","PAS","PALE","PA","LEAPS","SPA","SAP","LEAP","LAP","LAPSE","LAPS","SLAP","SEPAL","ASP","PEPS","PEP","ALES","APPLES","APES","APE","AS","ALE","APPLE"];
      _loc1_.SMILES_LIST = ["MESS","LESS","ISLES","MISS","LIES","LEIS","LEI","LIE","MILES","SMILES","ME","IS","SIS","ISLE","MILE","ELMS","ELM","SEMIS","SEISM","SEMI","LIMES","SLIMES","SLIMS","LIME","SLIM","SLIME","SMILE"];
      _loc1_.HORSES_LIST = ["SHORES","SHORE","SHOE","SHOES","OH","SHE","HOERS","HERS","HOSERS","HOER","HER","HOSER","HOSE","HORSE","HOSES","HORSES","HOES","HES","ORES","HOE","HE","ORE","OR","SO","ROSE","ROSES","ROES","ROE","SORE","HEROS","HERO","SORES"];
      _loc1_.WINTER_LIST = ["TWIN","TWINE","NEWT","NEW","RENT","WENT","TERN","WREN","WEN","TEN","IT","WIT","IRE","WIRE","WINTER","WE","WINE","INERT","WET","NET","IN","WIN","RITE","WRITE","WRIT","TIRE","TIER","TIE","NIT","NITER","TRINE","REIN","TIN","TINE"];
      _loc1_.BINDER_LIST = ["NIB","RIB","DIB","INBRED","REND","END","BEND","DEN","ID","BID","BIND","IRE","BINDER","BE","NERD","BIRD","RED","BRED","BED","BIDE","IN","BIN","RIDE","BRIDE","RID","DIRE","BRIE","DIE","BRINE","REIN","DIN","DINER","DINE","RIND","BRINED"];
      _loc1_.RACING_LIST = ["CRAG","CAIRN","CARING","CAR","CIGAR","GRAIN","ARCING","ARC","GRIN","AIR","RING","ACING","RACING","RANG","AN","RAN","RIG","RAG","GIN","RAIN","IN","GAIN","NAG","CAN","CAG"];
      _loc1_.FOLDER_LIST = ["ROLFED","REFOLD","OF","REF","ELF","OLD","FOLD","ORE","FORE","OLDER","FOLDER","FOE","FORD","OR","FOR","RED","FED","LED","FLED","ODE","RODE","REDO","ROD","DO","DOER","FRO","ROE","DOE","LORE","FLOE","LORD","LODE","LO","ROLE","DOLE"];
      _loc1_.BURGER_LIST = ["RUBE","GRUB","RUB","ERR","BUG","BURGER","BE","BURR","BEG","URGE","BUR","RUG","RUE"];
      _loc1_.CEREAL_LIST = ["LACE","RACE","ACE","ARC","ACRE","LACER","CLEAR","ARE","CARE","EARL","EAR","CAR","ERA","ERE","LA","CEREAL","REAL","A","ALE","EEL","LEE","ALEE","REEL","CREEL","LEER"];
      _loc1_.COMEDY_LIST = ["DOC","DECOY","COME","ME","COMEDY","COD","DYE","COY","MY","ODE","CODE","COED","DOE","YO","DO","MOD","MODE","DEMO","DOME"];
      _loc1_.DINNER_LIST = ["RIDE","RID","RIND","ID","REND","END","NERD","RED","I","INN","IRE","DIRE","INNER","DINNER","DINER","DIE","DEN","DINE","IN","DIN","REIN","NINE"];
      _loc1_.ERASER_LIST = ["SERER","SEER","SEE","ERASE","REARS","EESA","ERAS","ERA","REAR","SEAR","SEA","AS","ERE","RARE","ARE","ERASER","EARS","EAR","EASE","A","ERRS","ERR","ARR"];
      _loc1_.HOTDOG_LIST = ["OH","OOH","DOH","GOTH","DOTH","GOT","HOOT","HOT","DOT","GO","DOG","HOTDOG","HOG","TO","GOD","HOOD","DO","GOOD","GOO","TOO"];
      _loc1_.JUICES_LIST = ["SIC","USE","JUICES","ICES","US","IS","JUICE","ICE","I","CUES","SUE","CUE"];
      _loc1_.LOCKER_LIST = ["RELOCK","ROLE","ELK","CLERK","LO","LOCK","ORE","LORE","LOCKER","OR","ROE","CORE","CORK","COKE","ROCK"];
      _loc1_.MOVIES_LIST = ["SOME","SEMI","VIM","I","VISE","MOVIES","VIES","MOVES","ME","MOVE","IS","MOVIE","VIE","SO"];
      _loc1_.PENCIL_LIST = ["EPIC","LIP","CLIP","NIP","IN","PIN","PENCIL","NIL","PEN","LICE","NICE","ICE","PILE","LIE","PIE","LEI","CLINE","LINE","PINE"];
      _loc1_.PIZZAS_LIST = ["APIS","SIP","ZIP","ZIPS","SPAZ","ASP","ZAPS","SAP","ZAP","SPA","I","PIZZAS","AS","PAS","A","PA","IS","PIZZA"];
      _loc1_.RACING_LIST = ["CRAG","CAIRN","CARING","CAR","GARN","CIGAR","GRAIN","ARCING","ARC","GRIN","AIR","A","I","RING","ACING","RACING","RANG","AN","RAN","RIG","RAG","GIN","RAIN","IN","GAIN","NAG","CAN","CAG"];
      _loc1_.SALADS_LIST = ["LASS","A","LA","ADS","SALADS","LADS","AD","SALSA","AS","ALAS","SAD","LAD","SALAD"];
      _loc1_.SCHOOL_LIST = ["LOCHS","LOCOS","LOOS","COOLS","COOS","OH","OOH","SO","SOLO","LO","COOL","SCHOOL","SOL","LOO","COO","SHOO","LOCO"];
      _loc1_.SHARKS_LIST = ["ASKS","SKA","ASK","HARKS","SHARKS","ARKS","HAS","AS","HARK","ARK","HA","A","ASH","SASH","RASH","SHARK"];
      _loc1_.SKIING_LIST = ["INKS","GINKS","GINS","IS","KINGS","INS","SIGN","SKIING","KING","SING","GIN","KIN","SKIN","IN","SIN","SKI","I","INK","SINK"];
      _loc1_.SNAKES_LIST = ["ASKS","SNEAKS","SKA","SEAS","SEA","SNAKES","SAKES","ASK","AS","SAKE","A","AN","SANE","SANK","SNAKE","SNEAK"];
      _loc1_.SOCCER_LIST = ["COSEC","ROES","ROSE","CEROS","CORES","CROCS","ORES","SO","ORE","SORE","SOCCER","OR","CORE","SCORE","ROE"];
      _loc1_.SUMMER_LIST = ["MUMS","RUES","RUSE","MUSE","RUMS","EMUS","US","USER","USE","SURE","SUMMER","SUE","REM","ME","SUM","EMU","RUM","SERUM","RUE","MUM"];
      _loc1_.VIDEOS_LIST = ["DIVE","DIVES","DOVES","DOVE","I","ODES","ODE","VIED","SOD","VIE","SO","VIDEOS","DOS","DO","DOSE","VISE","DOES","VIES","IS","IDS","DOE","VIDEO","ID","DIE","DIES","VOIDS","VOID","SIDE"];
      _loc2_.GAMESCORE = new _loc3_.gMyScoringSystem.Evar(0,"GAMESCORE","THE OVERALL SCORE");
      _loc2_.ROUNDSCORE = new _loc3_.gMyScoringSystem.Evar(0,"ROUNDSCORE","SCORE FOR CURRENT ROUND");
      _loc2_.ROUND = new _loc3_.gMyScoringSystem.Evar(0,"ROUND","THE CURRENT ROUND");
      _loc2_.PTSLEFT = new _loc3_.gMyScoringSystem.Evar(0,"ROUND","THE CURRENT ROUND");
      _loc1_.startup_tips = [_loc2_.IDS_TIPONE_TXT,_loc2_.IDS_TIPTWO_TXT,_loc2_.IDS_TIPTHREE_TXT,_loc2_.IDS_TIPFOUR_TXT];
   };
   _loc1_.begin = function()
   {
      this.prepRound();
   };
   _loc1_.refreshEvars = function()
   {
      displayscore = _root.GAMESCORE.show();
   };
   _loc1_.returnWordValues = function(word_length)
   {
      var _loc1_ = word_length * word_length;
      var _loc2_ = Math.floor(_loc1_ / 2);
      return _loc2_;
   };
   _loc1_.layoutScreen = function()
   {
      var _loc1_ = this;
      var _loc2_ = _root;
      _loc2_.attachMovie("playGroundMC","playGroundMC",_loc2_.depth.playGround);
      _loc1_.playGround = _loc2_.playGroundMC;
      _loc1_.clearAll.push(_loc1_.playGround);
      _loc1_.playGround.init();
      _loc2_.attachMovie("wordBankMC","wordBankMC",_loc2_.depth.WordBank);
      _loc1_.wordBank = _loc2_.wordBankMC;
      _loc1_.clearAll.push(_loc1_.wordBank);
      _loc1_.wordBank.init();
      _loc2_.attachMovie("scoreBoardMC","scoreboardMC",_loc2_.depth.scoreBoard);
      _loc1_.scoreBoard = _loc2_.scoreboardMC;
      _loc1_.clearAll.push(_loc1_.scoreBoard);
      _loc1_.scoreBoard.init();
   };
   _loc1_.prepRound = function()
   {
      var _loc1_ = this;
      var _loc2_ = _root;
      userWord = previousWord = undefined;
      _loc2_.ROUND.changeBy(1);
      _loc1_.layoutScreen();
      _loc1_.puzzle = new PuzzleObject();
      _loc1_.puzzle.init();
      _loc1_.correctAnswers = 0;
      _loc1_.totalAnswers = _loc1_.puzzle.subset.length;
      _loc1_.wordBank.layout();
      _loc1_.playground.layout();
      _loc1_.scoreboard.layout();
      _loc1_.scoreboard.setTimer(120000);
      var random_Tip = random(_loc1_.startup_tips.length - 1);
      var start_Tip = _loc1_.startup_tips[random_Tip];
      var _loc3_ = _loc1_.puzzle.maxNumPts;
      var half = Math.round(_loc3_ / 2);
      var added = 10 * _loc2_.ROUND.SHOW();
      var min_needed = Math.min(_loc3_,half + added);
      var round_score = _loc2_.GAMESCORE.show() + min_needed;
      _loc2_.ROUNDSCORE.changeto(round_score);
      var roundInfo = _loc2_.IDS_ROUND_HDR_TXT + _loc2_.ROUND.show() + _loc2_.IDS_START_HDR_TXT;
      var bodyInfo = _loc2_.IDS_GET_HDR_TXT + _loc2_.ROUNDSCORE.show() + _loc2_.IDS_PTS_HDR_TXT + "\n" + _loc2_.IDS_TIP_HDR_TXT + start_Tip;
      _loc1_.scoreboard.setPrompt(roundInfo,bodyInfo);
      _loc1_.scoreboard.refreshDisplay();
   };
   _loc1_.showAllAnswers = function()
   {
      var _loc2_;
      var _loc1_;
      var _loc3_;
      if(this.puzzleType == "DICTIONARY")
      {
         var w_list = _root.wordBankMC.wordList;
         var list_length = w_list.length;
         var w = 0;
         while(w < list_length)
         {
            _loc2_ = w_list[w];
            if(_loc2_.shown != 1)
            {
               _loc2_.showMyWord(1);
               _loc1_ = 0;
               while(_loc1_ < _loc2_.numTiles)
               {
                  _loc3_ = _loc2_["tile" + _loc1_];
                  _loc3_.gotoAndStop("answerState");
                  _loc1_ = _loc1_ + 1;
               }
            }
            w++;
         }
      }
   };
   _loc1_.cleanup = function()
   {
      var _loc3_ = this;
      userWord = previousWord = undefined;
      var max = _loc3_.clearAll.length;
      var _loc1_ = 0;
      var _loc2_;
      while(_loc1_ < max)
      {
         _loc2_ = _loc3_.clearAll[_loc1_];
         _loc2_.removeMovieClip();
         _loc1_ = _loc1_ + 1;
      }
      _loc3_.clearAll = [];
   };
   _loc1_.endRound = function()
   {
      var _loc1_ = this;
      var _loc2_ = _root;
      Key.removeListener(_loc1_.playground.keyListener);
      _loc1_.showAllAnswers();
      var pHeader = _loc2_.IDS_ROUND_HDR_TXT + _loc2_.ROUND.show() + _loc2_.IDS_CLEAR_HDR_TXT;
      var _loc3_ = "\n" + _loc2_.IDS_NXT_ROUND_TXT;
      if(_loc1_.correctAnswers == _loc1_.totalAnswers)
      {
         var pBody = _loc2_.IDS_GOTALL_TXT + _loc3_;
      }
      else if(_loc1_.puzzleType == "DICTIONARY")
      {
         var pBody = _loc2_.IDS_UNANSWERED_TXT + "\n" + _loc3_;
      }
      else
      {
         var pBody = _loc2_.IDS_REVEALED_TXT + _loc1_.correctAnswers + _loc2_.IDS_OUTOF_TXT + _loc1_.totalAnswers + _loc2_.IDS_ENDREVEAL_TXT + _loc3_;
      }
      _loc1_.scoreboard.setPrompt(pHeader,pBody);
      _loc1_.scoreBoard.attachMovie("sb_popUp","popUp",_loc1_.scoreboard.popUpDepth);
   };
   _loc1_.end = function(reason)
   {
      var _loc1_ = _root;
      var _loc2_ = this;
      userWord = previousWord = undefined;
      Key.removeListener(_loc2_.playground.keyListener);
      _loc2_.playGround.onGameEnd();
      var _loc3_;
      if(reason.toLowerCase() == "timeout")
      {
         if(_loc2_.puzzleType == "DICTIONARY")
         {
            var pBody2 = "\n" + _loc1_.IDS_UNANSWERED_TXT;
         }
         else
         {
            var pBody2 = "\n" + _loc1_.IDS_NOT_REVEALED_TXT;
         }
         var pHeader = _loc1_.IDS_GAMEOVER_TXT;
         _loc3_ = _loc1_.IDS_NOTENOUGH_TXT + "<BR>" + _loc1_.IDS_YOUNEEDED_TXT + " " + _loc1_.PTSLEFT.SHOW() + " " + _loc1_.IDS_POINTS_TXT + ".<BR>" + pBody2 + "\n" + _loc1_.IDS_CLICKENDGAME_TXT;
         _loc2_.scoreboard.setPrompt(pHeader,_loc3_);
         _loc2_.showAllAnswers();
      }
      else if(reason == "userQuit")
      {
         Game.cleanup();
         _loc1_.gotoAndPlay("gameoverframe");
      }
   };
}
