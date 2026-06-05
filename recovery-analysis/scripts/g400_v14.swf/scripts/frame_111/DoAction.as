var objTF_dict = Translator.addTextField(txtLoadingDict);
objTF_dict.setHtmlText(_level0.IDS_GENERIC_GAME_LOADING_THE_DICTIONARY);
var Dictionary = _level100.include._MB8_Dictionary;
Dictionary.loadDictionary();
_root.onEnterFrame = function()
{
   var _loc2_ = int(Dictionary.getPercentLoaded());
   txtLoadingDict.htmlText = "<P ALIGN=\"CENTER\">" + _loc2_ + "% " + _transLevel.IDS_GENERIC_GAME_LOADING_THE_DICTIONARY + "</P>";
   if(_loc2_ >= 100)
   {
      trace("Dictionary loaded 100%");
      _root.onEnterFrame = undefined;
      _root.play();
   }
};
stop();
