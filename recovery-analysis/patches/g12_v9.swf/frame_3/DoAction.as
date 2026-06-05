_global.MillsberryEvar = function(value)
{
   this.value = value;
};
MillsberryEvar.prototype.show = function()
{
   return this.value;
};
MillsberryEvar.prototype.changeBy = function(amount)
{
   this.value += amount;
   return this.value;
};
MillsberryEvar.prototype.changeby = MillsberryEvar.prototype.changeBy;
MillsberryEvar.prototype.changeTo = function(value)
{
   this.value = value;
   return this.value;
};
MillsberryEvar.prototype.changeto = MillsberryEvar.prototype.changeTo;
_global.MillsberryDictionary = function()
{
   this.wordlistLevel = 120;
   loadMovieNum(_level0.FG_GAME_BASE + "gamingsystem/flash_dictionary_en_v18.swf",this.wordlistLevel);
};
MillsberryDictionary.prototype.getWordRoot = function()
{
   return _root["_level" + this.wordlistLevel];
};
MillsberryDictionary.prototype.getPercentLoaded = function()
{
   var level = this.getWordRoot();
   var total = level.getBytesTotal();
   return total <= 0 ? 0 : level.getBytesLoaded() / total * 100;
};
MillsberryDictionary.prototype.category = function(word)
{
   var value = word.toLowerCase();
   var bucket = this.getWordRoot().w[value.length][value.charAt(0)];
   var result = bucket[value];
   return result == undefined ? 0 : result;
};
MillsberryDictionary.prototype.isANeopianWord = function(word)
{
   return this.category(word) == 2;
};
MillsberryDictionary.prototype.doScramble = function(word)
{
   var letters = word.toLowerCase().split("");
   var result = "";
   while(letters.length > 0)
   {
      result += letters.splice(random(letters.length),1)[0];
   }
   return result;
};
MillsberryDictionary.prototype.getRandomWord = function(length)
{
   var alphabet = "abcdefghijklmnopqrstuvwxyz";
   var words = new Array();
   var root = this.getWordRoot();
   var i = 0;
   while(i < alphabet.length)
   {
      var bucket = root.w[length][alphabet.charAt(i)];
      for(var word in bucket)
      {
         if(bucket[word] == 1)
         {
            words.push(word);
         }
      }
      i++;
   }
   return words[random(words.length)];
};
MillsberryDictionary.prototype.containsLetters = function(candidate,source)
{
   var letters = source.toLowerCase().split("");
   var i = 0;
   while(i < candidate.length)
   {
      var index = -1;
      var j = 0;
      while(j < letters.length)
      {
         if(letters[j] == candidate.charAt(i))
         {
            index = j;
            break;
         }
         j++;
      }
      if(index < 0)
      {
         return false;
      }
      letters.splice(index,1);
      i++;
   }
   return true;
};
MillsberryDictionary.prototype.getSubSet = function(source)
{
   var result = new Array();
   var alphabet = "abcdefghijklmnopqrstuvwxyz";
   var root = this.getWordRoot();
   var length = 2;
   while(length <= source.length)
   {
      var i = 0;
      while(i < alphabet.length)
      {
         var bucket = root.w[length][alphabet.charAt(i)];
         for(var word in bucket)
         {
            if(bucket[word] == 1 && this.containsLetters(word,source))
            {
               result.push(word);
            }
         }
         i++;
      }
      length++;
   }
   return result;
};
_global.gMyScoringSystem = new Object();
gMyScoringSystem.Evar = MillsberryEvar;
gMyScoringSystem.Dictionary = MillsberryDictionary;
gMyScoringSystem.reset = function()
{
};
gMyScoringSystem.setScore = function(value)
{
   this.score = value;
};
gMyScoringSystem.submitScore = function()
{
};
_global.gMyGMIStatus = new Object();
gMyGMIStatus.sendTrack = function()
{
};
fscommand("trapallkeys","true");
