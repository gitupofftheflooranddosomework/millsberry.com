translator = new np.lang.Translator();
includeTracer.trace("Translator: Created");
gameTranslationSuccess = false;
var gameTranslation_lis = new Object();
gameTranslation_lis.onLoad = function(event)
{
   _level0.game_bEmbedFonts = event.target.getLangGroup() == "WE";
   _level100.include.gameTranslationSuccess = true;
};
translator.addEventListener("onLoad",gameTranslation_lis);
setTranslatorTextFieldTarget = function(target)
{
   translator.setDefaultTranslationTextFieldTarget(target);
};
newGameTranslation = function()
{
   var _loc1_ = _level100.include.debug;
   if(_loc1_ == undefined || _loc1_ == 0)
   {
      _loc1_ = false;
   }
   else
   {
      _loc1_ = true;
   }
   translator.setPlayMode("MANUAL");
   translator.setDebug(_loc1_);
   translator.setTarget(_level0);
   if(_level0.FG_SCRIPT_BASE == undefined)
   {
      translator.setTranslationScriptURL("http://webdev.neopets.com/transcontent/gettranslationxml.phtml");
   }
   else
   {
      translator.setTranslationScriptURL(_level0.FG_SCRIPT_BASE + "transcontent/gettranslationxml.phtml");
   }
   translator.setLang(_level0.game_lang);
   translator.setTypeID(4);
   translator.setItemID(_level0.game_id);
   translator.translate();
};
