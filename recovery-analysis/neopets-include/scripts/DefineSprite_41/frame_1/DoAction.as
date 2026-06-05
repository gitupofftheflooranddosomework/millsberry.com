System.security.allowDomain("neopets.com");
if(_level0.FG_GAME_BASE == undefined)
{
   _level0.FG_GAME_BASE = "http://images50.neopets.com/";
}
if(_level0.FG_SCRIPT_BASE == undefined)
{
   _level0.FG_SCRIPT_BASE = "http://www.neopets.com/";
}
includeTracer = new np.projects.include.TracerClass(_level0.debug,"GAMING SYSTEM (_level100.include): ");
includeTracer.trace("Initializing...",true);
gameMsg = function(index, append)
{
   append += " - old call -";
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
   getURL("javascript:var cheatwin=window.open(\'http://www.neopets.com/games/cheatmonster.phtml\', \'popup\',\'width=380,height=420,scrollbars=0,menubar=0,toolbar=0,location=0,resizable=0,status=0\' );");
};
msg = function(index, append)
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
