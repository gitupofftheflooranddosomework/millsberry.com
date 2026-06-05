_global.playGroundObject = function()
{
};
playGroundObject.prototype = new MovieClip();
var obj = _global.playGroundObject.prototype;
obj.init = function()
{
   var _loc1_ = this;
   _loc1_._x = Screen.centerX;
   _loc1_._y = Screen.centerY - 75;
   _loc1_.depth = 0;
   _loc1_.takenLetterList = new Array();
   _loc1_.lastTakenLetters = new Array();
};
obj.layout = function()
{
   var _loc1_ = this;
   _loc1_.layoutBlocks();
   _loc1_.setUpKeys();
   _loc1_.setUpInput();
   _loc1_.center();
};
obj.setUpKeys = function()
{
   var _loc3_ = this;
   _loc3_.keyListener = new Object();
   _loc3_.keyListener.onKeyUp = function()
   {
      var _loc2_ = Key.getCode();
      var _loc3_ = String.fromCharCode(Key.getCode());
      var _loc1_ = Game.playGround;
      if(_loc2_ == 32)
      {
         _loc1_.doScramble();
      }
      else if(_loc2_ == 8)
      {
         _loc1_.backSpaceKey();
      }
      else if(_loc2_ == 9)
      {
         _loc1_.cancelBlocks();
      }
      else if(_loc2_ == 16 or _loc2_ == 13)
      {
         _loc1_.enterFunctions();
      }
      else
      {
         _loc1_.userInput(_loc3_,"key");
      }
   };
   Key.addListener(_loc3_.keyListener);
};
obj.setUpInput = function()
{
   var _loc3_ = this;
   _global.userWord = "";
   _loc3_.keysToListenFor = new Object();
   var _loc1_ = 0;
   var _loc2_;
   while(_loc1_ < Game.puzzle.scrambledWord.length)
   {
      _loc2_ = Game.puzzle.scrambledWord.charAt(_loc1_);
      _loc3_.keysToListenFor[_loc2_]++;
      _loc1_ = _loc1_ + 1;
   }
};
obj.userInput = function(letter, input_type)
{
   var _loc3_ = this;
   letter = letter.toUpperCase();
   if(_loc3_.keysToListenFor[letter] == undefined)
   {
      return -1;
   }
   var _loc2_;
   var _loc1_;
   if(input_type != "mouse")
   {
      var max = _loc3_.blockList.length;
      _loc2_ = 0;
      while(_loc2_ < max)
      {
         _loc1_ = _loc3_.blockList[_loc2_];
         if(_loc1_.letter == letter and _loc1_.getTaken() != 1)
         {
            _loc1_.setTakenTo(1);
            _loc3_.takenLetterList.push(_loc1_);
            break;
         }
         _loc2_ = _loc2_ + 1;
      }
   }
};
obj.previousButtonCode = function()
{
   var _loc3_ = this;
   var letters = previousWord.split("");
   var max = _loc3_.lastTakenLetters.length;
   var _loc1_ = 0;
   var _loc2_;
   while(_loc1_ < max)
   {
      _loc2_ = _loc3_.lastTakenLetters[_loc1_];
      _loc2_.setTakenTo(1);
      _loc3_.takenLetterList.push(_loc2_);
      _loc1_ = _loc1_ + 1;
   }
};
obj.cancelBlocks = function()
{
   var _loc3_ = this.takenLetterList;
   var max = _loc3_.length;
   var _loc1_ = 0;
   var _loc2_;
   while(_loc1_ < max)
   {
      _loc2_ = _loc3_[_loc1_];
      _loc2_.setTargetTo("home");
      _loc2_.setTakenTo(0);
      _loc1_ = _loc1_ + 1;
   }
   this.takenLetterList = [];
};
obj.backSpaceKey = function()
{
   var _loc1_;
   var _loc3_;
   var _loc2_;
   if(userWord.length > 0)
   {
      _loc1_ = this.takenLetterList;
      _loc3_ = _loc1_.length - 1;
      _loc2_ = _loc1_[_loc3_];
      _loc2_.setTargetTo("home");
      _loc2_.setTakenTo(0);
      _loc1_.length -= 1;
      this.lastTakenLetters.length -= 1;
   }
};
obj.enterFunctions = function()
{
   var _loc2_ = this;
   var _loc1_ = _loc2_.takenLetterList.length;
   if(_loc1_ > 0)
   {
      _loc2_.enterButtonCode();
   }
   else
   {
      _loc2_.previousButtonCode();
   }
};
obj.enterButtonCode = function()
{
   var _loc1_ = _root;
   this.lastTakenLetters = this.takenLetterList.slice(0);
   _global.previousWord = userWord;
   var game_puzzle = Game.puzzle.subset;
   var max = game_puzzle.length;
   var word_to_check = userWord.toUpperCase();
   var x = 0;
   var _loc2_;
   var _loc3_;
   while(true)
   {
      if(x >= max)
      {
         var pHeader = _loc1_.IDS_SORRY_TXT;
         var pBody = "\"" + userWord + "\"" + " " + _loc1_.IDS_NOTWORD_TXT;
         _loc1_.scoreboardMC.setPrompt(pHeader,pBody);
         _loc1_.wrongSound.start();
         this.cancelBlocks();
         break;
      }
      var thisWord = Game.puzzle.subset[x];
      var puzzle_word = thisWord.subWord;
      if(puzzle_word == userWord)
      {
         var answered = thisWord.already_answered;
         if(!answered)
         {
            thisWord.already_answered = 1;
            _loc1_.correctSound.start();
            var pHeader = _loc1_.IDS_GREATJOB_TXT;
            var pBody = "\"" + puzzle_word + "\"" + _loc1_.IDS_ISCODE_TXT;
            _loc1_.scoreboardMC.setPrompt(pHeader,pBody);
            var rewarded_points = userWord.length;
            Game.correctAnswers++;
            var pts_award = Game.returnWordValues(rewarded_points);
            _loc1_.GAMESCORE.changeby(pts_award);
            _loc1_.scoreboardMC.showScore();
            var w_list = _loc1_.wordBankMC.wordList;
            var list_length = w_list.length;
            _loc2_ = 0;
            while(_loc2_ < list_length)
            {
               _loc3_ = w_list[_loc2_];
               if(_loc3_.word == userWord)
               {
                  _loc3_.showMyWord(1);
               }
               _loc2_ = _loc2_ + 1;
            }
            if(Game.correctAnswers == Game.totalAnswers)
            {
               Game.scoreboard.toggleTo("on");
               Game.endround();
            }
         }
         else
         {
            var pHeader = _loc1_.IDS_SORRY_TXT;
            var pBody = "\"" + puzzle_word + "\"" + " " + _loc1_.IDS_ALREADYANSWERED_TXT;
            _loc1_.scoreboardMC.setPrompt(pHeader,pBody);
            _loc1_.wrongSound.start();
         }
         this.cancelBlocks();
         break;
      }
      x++;
   }
};
obj.doScramble = function()
{
   var _loc2_ = this;
   _root.scrambleSound.start();
   var _loc1_ = new Array();
   for(var _loc3_ in _loc2_.blockList)
   {
      do
      {
         var r = random(_loc2_.blockList.length);
      }
      while(_loc1_[r] != undefined);
      _loc1_[r] = _loc2_.blockList[_loc3_];
      _loc1_[r].setXOutByCol(r);
      if(_loc1_[r].getTaken() != 1)
      {
         _loc1_[r].setTargetTo("home",undefined,1);
      }
   }
   _loc2_.blockList = _loc1_;
};
obj.layoutBlocks = function()
{
   var _loc2_ = this;
   _loc2_.blockList = new Array();
   var _loc1_ = 0;
   var _loc3_;
   while(_loc1_ < Game.puzzle.scrambledWord.length)
   {
      var letter = Game.puzzle.scrambledWord.charAt(_loc1_);
      var sourceName = "blockMC";
      var targetName = "block" + _loc1_;
      var depthNum = ++_loc2_.depth;
      _loc2_.attachMovie(sourceName,targetName,depthNum);
      _loc3_ = _loc2_[targetName];
      var row = 1;
      var col = _loc1_;
      _loc3_.init(letter,row,col);
      _loc2_.blockList.push(_loc3_);
      _loc1_ = _loc1_ + 1;
   }
};
obj.center = function()
{
   this._x = _root.game_bg._x + _root.game_bg._width / 2 - this._width / 2;
};
obj.onGameEnd = function()
{
   var _loc3_ = this;
   var _loc2_ = _loc3_.blockList.length;
   var _loc1_ = 0;
   while(_loc1_ < _loc2_)
   {
      _loc3_.blockList[_loc1_].onGameEnd();
      _loc1_ = _loc1_ + 1;
   }
};
Object.registerClass("playGroundMC",playGroundObject);
