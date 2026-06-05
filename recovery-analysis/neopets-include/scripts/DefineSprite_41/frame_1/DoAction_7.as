dictionary = function(traceOn)
{
   var _loc1_ = this;
   _loc1_.getHelp = function()
   {
      var _loc1_ = "";
      _loc1_ += "DICTIONARY.getHelp()\n";
      _loc1_ += "------------------------\n";
      _loc1_ += "CONSTRUCTOR\n";
      _loc1_ += "\tmyDictionary = new Dictionary(traceOn)\n";
      _loc1_ += "PUBLIC METHODS\n";
      _loc1_ += "\tgetPercentLoaded();\t\t\t\t\t\t\t//returns 0-100\n";
      _loc1_ += "\tisAWord(string);\t\t\t\t\t\t\t\t//returns 0,1\n";
      _loc1_ += "\tisADictionaryWord(string);\t\t\t\t\t//returns 0,1\n";
      _loc1_ += "\tisANeopianWord(string);\t\t\t\t\t\t//returns 0,1\n";
      _loc1_ += "\tgetContainedWords(string);\t\t\t\t\t\t\t\t//returns array of strings\n";
      _loc1_ += "\tgetContainedDictionaryWords(string);\t\t\t\t\t//returns array of strings\n";
      _loc1_ += "\tgetContainedNeopianWords(string);\t\t\t\t\t\t//returns array of strings\n";
      _loc1_ += "\tgetRandomWord([length,firstletter]);\t//returns string\n";
      _loc1_ += "\tgetSubset(string);\t\t\t\t\t\t\t//returns array of strings\n";
      _loc1_ += "\tdoScramble(string);\t\t\t\t\t\t\t//returns a new string\n";
      _loc1_ += "\tgetAlphabet(); \t\t\t\t\t\t\t\t//returns array of strings\n";
      return _loc1_;
   };
   _loc1_.alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
   _loc1_.alphabet_object = new Object();
   var _loc2_ = 0;
   while(_loc2_ < _loc1_.alphabet.length)
   {
      _loc1_.alphabet_object[_loc1_.alphabet[_loc2_]] = _loc1_.alphabet[_loc2_];
      _loc2_ = _loc2_ + 1;
   }
   var versionNum = _level0.game_dict_ver;
   var server = _level0.FG_GAME_BASE;
   _loc1_.wordlist_url = server + "games/utilities/flash_dictionary/flash_dictionary_en_v" + versionNum + ".swf";
   _loc1_.wordlist_level = 120;
   _loc1_.savedLengths = new Array();
   _loc1_.maxwordlength = 8;
   _loc1_.minwordlength = 2;
   loadMovieNum(_loc1_.wordlist_url,_loc1_.wordlist_level);
   _loc1_.wl_donecheck = function(wordlength, letter)
   {
      if(wordlength == undefined)
      {
      }
      if(letter == undefined)
      {
         return -1;
      }
      return _root["_level" + this.wordlist_level].w[wordlength][letter];
   };
   _loc1_.wl_checkloaded = function(wordlength, letter)
   {
      var _loc1_ = this;
      var _loc2_ = _loc1_.getPercentLoaded();
      if(_loc2_ == 100)
      {
         _loc1_.wl = _loc1_.wl_donecheck;
         return _loc1_.wl(wordlength,letter);
      }
   };
   _loc1_.wl = _loc1_.wl_checkloaded;
   _loc1_.getPercentLoaded = function()
   {
      var _loc2_ = _root["_level" + this.wordlist_level];
      var _loc1_ = _loc2_.getBytesLoaded() / _loc2_.getBytesTotal() * 100;
      if(isNaN(_loc1_))
      {
         _loc1_ = 0;
      }
      return _loc1_;
   };
   _loc1_.catagorizeWord = function(userword)
   {
      var _loc1_ = userword;
      _loc1_ = _loc1_.toLowerCase();
      var _loc3_ = Number(_loc1_.length);
      var firstchar = _loc1_.charAt(0);
      var _loc2_ = this.wl(_loc3_,firstchar)[_loc1_];
      if(_loc2_ == undefined)
      {
         _loc2_ = 0;
      }
      return _loc2_;
   };
   _loc1_.isAWord = function(userword)
   {
      var _loc1_ = this.catagorizeWord(userWord);
      if(_loc1_ > 0)
      {
         return 1;
      }
      return 0;
   };
   _loc1_.isABadWord = function(userword)
   {
      var _loc1_ = this.catagorizeWord(userWord);
      if(_loc1_ == -1)
      {
         return 1;
      }
      return 0;
   };
   _loc1_.isADictionaryWord = function(userword)
   {
      var _loc1_ = this.catagorizeWord(userWord);
      if(_loc1_ == 1)
      {
         return 1;
      }
      return 0;
   };
   _loc1_.isANeopianWord = function(userword)
   {
      var _loc1_ = this.catagorizeWord(userWord);
      if(_loc1_ == 2)
      {
         return 1;
      }
      return 0;
   };
   _loc1_.getAlphabet = function()
   {
      return this.alphabet.slice(0,this.alphabet.length);
   };
   _loc1_.doScramble = function(userword)
   {
      var _loc2_ = userword;
      _loc2_ = _loc2_.toLowerCase();
      var _loc3_ = Number(_loc2_.length);
      var _loc1_ = new Array();
      var scrambledWord = new String();
      var fillCount = 0;
      while(true)
      {
         var r = random(_loc3_);
         if(_loc1_[r] != 1)
         {
            _loc1_[r] = 1;
            scrambledWord += _loc2_.charAt(r);
            fillCount++;
            if(fillCount >= _loc2_.length)
            {
               break;
            }
         }
      }
      return scrambledWord;
   };
   _loc1_.getRandomWord = function(wordLength, startingLetter)
   {
      var _loc2_ = this;
      var originalWordLength = wordLength;
      var originalStartingLetter = startingLetter;
      if(arguments.length == 1)
      {
         if(typeof wordlength == "string")
         {
            var startingletter = wordlength;
            wordlength = undefined;
         }
         else if(typeof wordlength == "number")
         {
            var wordlength = wordlength;
            startingletter = undefined;
         }
      }
      if(wordlength == undefined)
      {
         var wordlength = random(_loc2_.maxwordlength) + 1;
      }
      else
      {
         if(wordlength < 1)
         {
            return -1;
         }
         if(wordlength > _loc2_.maxwordlength)
         {
            return -1;
         }
      }
      if(wordlength == 1)
      {
         if(startingletter == undefined)
         {
            return _loc2_.alphabet[random(_loc2_.alphabet.length)];
         }
         return startingletter;
      }
      if(startingletter == undefined)
      {
         var startingletter = _loc2_.alphabet[random(_loc2_.alphabet.length)];
      }
      var arraylength = _loc2_.findLength(_loc2_.wl(wordlength,startingletter));
      var _loc1_;
      var _loc3_;
      do
      {
         var wl = _loc2_.wl(wordlength,startingletter);
         _loc3_ = random(arrayLength);
         _loc1_ = _loc2_.wordAtSpot(wl,_loc3_);
         var wordlength = _loc1_.length;
         var letter = _loc1_.charAt(0);
      }
      while(_root["_level" + _loc2_.wordlist_level].w[wordlength][letter][_loc1_] == -1);
      if(_loc1_ == -1)
      {
         if(originalWordLength != undefined and originalStartingLetter != undefined)
         {
            return -1;
         }
         _loc1_ = _loc2_.getRandomWord(originalWordLength,originalStartingLetter);
      }
      return _loc1_;
   };
   _loc1_.findLength = function(obj)
   {
      var _loc2_ = obj;
      var _loc1_ = 0;
      for(var _loc3_ in _loc2_)
      {
         _loc1_ = _loc1_ + 1;
      }
      return _loc1_;
   };
   _loc1_.wordAtSpot = function(obj, stopSpot)
   {
      var _loc2_ = stopSpot;
      var _loc3_ = obj;
      var _loc1_ = 0;
      for(var i in _loc3_)
      {
         if((_loc1_ = _loc1_ + 1) >= _loc2_)
         {
            return i;
         }
      }
      return -1;
   };
   _loc1_.traceObject = function(obj)
   {
      var _loc1_ = obj;
      for(var _loc2_ in _loc1_)
      {
         if(typeof _loc1_[_loc2_] == "string")
         {
            trace("\t" + _loc1_[_loc2_]);
         }
      }
   };
   _loc1_.factorial = function(x)
   {
      var _loc1_ = x;
      if(_loc1_ < 0)
      {
         return undefined;
      }
      if(_loc1_ <= 1)
      {
         return 1;
      }
      return _loc1_ * this.factorial(_loc1_ - 1);
   };
};
Dictionary.prototype.getSubset = function(userword)
{
   fstart = getTimer();
   var maxlength = Number(userword.length);
   if(maxLength > 7)
   {
      return -1;
   }
   var minlength = 2;
   var userwordarray = new Array();
   var l = 0;
   while(l < userword.length)
   {
      userwordarray[userwordarray.length] = userword.charAt(l);
      l++;
   }
   this.permute = function(letters)
   {
      var _loc3_ = letters;
      var num = _loc3_.length;
      var letters_copy = new Array();
      var _loc2_ = 0;
      while(_loc2_ < _loc3_.length)
      {
         letters_copy[letters_copy.length] = _loc3_[_loc2_];
         _loc2_ = _loc2_ + 1;
      }
      var _loc1_;
      if(num == 0)
      {
         var out = new Object();
      }
      else if(num == 1)
      {
         var out = new Object();
         out[_loc3_.toString()] = _loc3_.toString();
      }
      else if(num == 2)
      {
         var out = new Object();
         out[_loc3_[0] + _loc3_[1]] = _loc3_[0] + _loc3_[1];
         out[_loc3_[1] + _loc3_[0]] = _loc3_[1] + _loc3_[0];
      }
      else
      {
         var out = new Object();
         var i = 0;
         while(i <= _loc3_.length)
         {
            _loc3_ = new Array();
            _loc2_ = 0;
            while(_loc2_ < letters_copy.length)
            {
               _loc3_[_loc3_.length] = letters_copy[_loc2_];
               _loc2_ = _loc2_ + 1;
            }
            var car = _loc3_.splice(i,1).toString();
            out[car] = car;
            var cdr = _loc3_.slice(0,_loc3_.length);
            _loc1_ = this.permute(cdr);
            var cdr_listlength = 0;
            for(var j in _loc1_)
            {
               cdr_listlength++;
               out[car + _loc1_[j]] = car + _loc1_[j];
               out[_loc1_[j]] = _loc1_[j];
            }
            i++;
         }
      }
      return out;
   };
   perms = this.permute(userwordarray);
   isawordstart = getTimer();
   var finalgoodoutput = new Array();
   counter = 0;
   for(var p in perms)
   {
      counter++;
      var tempword = perms[p].toString();
      var i = getTimer();
      var verified = this.isAWord(tempword);
      if(verified > 0)
      {
         finalgoodoutput.push(tempword);
      }
   }
   return finalgoodoutput;
};
