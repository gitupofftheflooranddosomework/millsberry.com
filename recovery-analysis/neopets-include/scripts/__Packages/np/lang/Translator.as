class np.lang.Translator extends core.lang.Translator
{
   var setTranslationScriptURL;
   var translationScriptPart2of2_str;
   function Translator()
   {
      super();
      np.utilities.Server.addAllAllowedDomains();
      this.setTranslationScriptURL(np.utilities.Server.WEB_SERVER_BASE_URL + this.translationScriptPart2of2_str);
   }
   function addTextField(tTextFieldInstanceOrString, properties)
   {
      return super.addTextField(tTextFieldInstanceOrString,properties);
   }
   function setTranslatorXML(aXMLNode)
   {
      var _loc1_ = aXMLNode;
      var _loc2_ = this;
      var tLang_str = _loc1_.childNodes[0].firstChild.toString();
      var _loc3_ = Number(_loc1_.childNodes[1].firstChild.toString());
      var tItemID_num = Number(_loc1_.childNodes[2].firstChild.toString());
      var tScriptURL_str = _loc1_.childNodes[3].firstChild.toString();
      _loc2_.setLang(tLang_str);
      _loc2_.setTypeID(_loc3_);
      _loc2_.setItemID(tItemID_num);
      _loc2_.setTranslationScriptURL(tScriptURL_str);
   }
}
