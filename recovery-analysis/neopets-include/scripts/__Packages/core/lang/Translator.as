class core.lang.Translator
{
   var IDSVars_array;
   var defaultText;
   var lang_array;
   var pEventDispatcher;
   var targetDefault;
   var target_mc;
   var translatableTextField_array;
   var translator;
   var westernLang_array;
   var sDEBUG = "";
   static var TYPE_ID_GAME = 4;
   static var TYPE_ID_CONTENT = 14;
   static var DEFAULT_TEXT_TYPE_LOADING = "LOADING";
   static var DEFAULT_TEXT_TYPE_ERROR = "ERROR";
   var debug_boolean = false;
   var lang_str = undefined;
   var typeID_num = 0;
   var itemID_num = 0;
   var playMode_str = "";
   var userHardCodedEmbedFonts_boolean = undefined;
   var returnFormat_str = "";
   var fontDefault_str = "_sans";
   var useWWWHost_boolean = false;
   var WWWHost_str = "";
   var translationScriptURL_str = "";
   var langGroup_str = undefined;
   static var TYPE_RETURN_FORMAT = "XML";
   static var PLAY_MODE_AUTOMATIC = "AUTOMATIC";
   static var PLAY_MODE_MANUAL = "MANUAL";
   static var LANG_GROUP_WE = "WE";
   static var LANG_GROUP_NW = "NW";
   static var LANG_CODE_EN = "EN";
   static var LANG_CODE_PT = "PT";
   static var LANG_CODE_DE = "DE";
   static var LANG_CODE_FR = "FR";
   static var LANG_CODE_IT = "IT";
   static var LANG_CODE_ES = "ES";
   static var LANG_CODE_NL = "NL";
   static var LANG_CODE_JA = "JA";
   static var LANG_CODE_CH = "CH";
   static var LANG_CODE_ZH = "ZH";
   static var LANG_CODE_KO = "KO";
   function Translator()
   {
      var _loc1_ = this;
      _global.NPTranslator = _loc1_;
      _loc1_.pEventDispatcher = new np.events.EventDispatcher();
      _loc1_.pEventDispatcher.initialize(_loc1_);
      _loc1_.setDebug(false);
      if(_level0.lang != undefined)
      {
         _loc1_.setLang(_level0.lang);
      }
      else
      {
         _loc1_.setLang(core.lang.Translator.LANG_CODE_EN);
      }
      _loc1_.setTypeID(core.lang.Translator.TYPE_ID_GAME);
      _loc1_.setItemID(53);
      _loc1_.setPlayMode(core.lang.Translator.PLAY_MODE_MANUAL);
      _loc1_.setTarget("_level0");
      _loc1_.setWesternLangs([core.lang.Translator.LANG_CODE_EN,core.lang.Translator.LANG_CODE_PT,core.lang.Translator.LANG_CODE_DE,core.lang.Translator.LANG_CODE_FR,core.lang.Translator.LANG_CODE_IT,core.lang.Translator.LANG_CODE_ES,core.lang.Translator.LANG_CODE_NL]);
      var _loc2_ = new Array();
      _loc2_.push(core.lang.Translator.LANG_CODE_JA);
      _loc2_.push(core.lang.Translator.LANG_CODE_CH);
      _loc2_.push(core.lang.Translator.LANG_CODE_ZH);
      _loc2_.push(core.lang.Translator.LANG_CODE_KO);
      _loc2_ = _loc2_.concat(_loc1_.westernLang_array);
      _loc1_.setLangs(_loc2_);
      _loc1_.setReturnFormat(core.lang.Translator.TYPE_RETURN_FORMAT);
      _loc1_.translatableTextField_array = [];
      _loc1_.translationScriptPart2of2_str = "/transcontent/gettranslationxml.phtml";
      if(_loc1_.getPlayMode() == core.lang.Translator.PLAY_MODE_AUTOMATIC)
      {
         _loc1_.toggleTargetPlayMode(false);
         _loc1_.translate();
      }
      _loc1_.initDefaultText();
   }
   function getDefaultText(tTextType_str)
   {
      return Object(this.defaultText[this.getLang()])[tTextType_str];
   }
   function setDebug(tValue)
   {
      this.debug_boolean = Boolean(tValue);
   }
   function getDebug()
   {
      return this.debug_boolean;
   }
   function setLang(tValue)
   {
      if(tValue.length == 2)
      {
         this.lang_str = String(tValue).toUpperCase();
      }
      this.refreshAllTranslatableTextFields();
   }
   function getLang()
   {
      return this.lang_str;
   }
   function setTypeID(tValue)
   {
      this.typeID_num = Number(tValue);
   }
   function getTypeID()
   {
      return this.typeID_num;
   }
   function setItemID(tValue)
   {
      this.itemID_num = Number(tValue);
   }
   function getItemID()
   {
      return this.itemID_num;
   }
   function setPlayMode(tValue)
   {
      this.playMode_str = String(tValue).toUpperCase();
   }
   function getPlayMode()
   {
      return this.playMode_str;
   }
   function getEmbedFonts()
   {
      var _loc1_ = this;
      var _loc2_ = Boolean(_loc1_.userHardCodedEmbedFonts_boolean != undefined ? _loc1_.userHardCodedEmbedFonts_boolean : _loc1_.getLangGroup() == core.lang.Translator.LANG_GROUP_WE);
      return _loc2_;
   }
   function setEmbedFonts(tValue)
   {
      this.userHardCodedEmbedFonts_boolean = tValue;
      this.refreshAllTranslatableTextFields();
   }
   function setReturnFormat(tValue)
   {
      this.returnFormat_str = tValue;
   }
   function getReturnFormat()
   {
      return this.returnFormat_str;
   }
   function setTarget(tValue)
   {
      this.target_mc = tValue;
   }
   function getTarget()
   {
      return this.target_mc;
   }
   function setVariableList(tValue)
   {
      this.IDSVars_array = tValue;
   }
   function getVariableList()
   {
      return this.IDSVars_array;
   }
   function setDefaultFont(tValue)
   {
      this.fontDefault_str = tValue;
   }
   function getDefaultFont()
   {
      return this.fontDefault_str;
   }
   function setDefaultTranslationTextFieldTarget(tValue)
   {
      this.targetDefault = tValue;
   }
   function getDefaultTranslationTextFieldTarget()
   {
      var _loc1_ = this;
      if(_loc1_.targetDefault == undefined)
      {
         _loc1_.targetDefault = _level0;
      }
      return _loc1_.targetDefault;
   }
   function getTranslatableTextFieldList()
   {
      return this.translatableTextField_array;
   }
   function setWWWHost(tValue)
   {
      this.useWWWHost_boolean = true;
      this.WWWHost_str = tValue;
   }
   function getWWWHost()
   {
      return this.WWWHost_str;
   }
   function setTranslationScriptURL(tValue)
   {
      this.translationScriptURL_str = tValue;
   }
   function getTranslationScriptURL()
   {
      return this.translationScriptURL_str;
   }
   function setWesternLangs(tValue)
   {
      this.westernLang_array = tValue;
   }
   function getWesternLangs()
   {
      return this.westernLang_array;
   }
   function setLangs(tValue)
   {
      this.lang_array = tValue;
   }
   function getLangs()
   {
      return this.lang_array;
   }
   function setLangGroup(tValue)
   {
      this.langGroup_str = String(tValue).toLowerCase();
   }
   function getLangGroup()
   {
      var _loc1_ = this;
      var _loc2_ = String(core.lang.Translator.LANG_GROUP_NW);
      var _loc3_ = _loc1_.getWesternLangs();
      for(var i in _loc3_)
      {
         if(_loc1_.getLang().toUpperCase() == String(_loc1_.getWesternLangs()[i]).toUpperCase())
         {
            _loc2_ = core.lang.Translator.LANG_GROUP_WE;
            break;
         }
      }
      _loc1_.langGroup_str = String(_loc2_).toUpperCase();
      return _loc1_.langGroup_str;
   }
   function dispatchEvent(eventObj)
   {
      this.pEventDispatcher.dispatchEvent(eventObj);
   }
   function addEventListener(event_str, listener_obj)
   {
      this.pEventDispatcher.addEventListener(event_str,listener_obj);
   }
   function removeEventListener(event_str, listener_obj)
   {
      this.pEventDispatcher.removeEventListener(event_str,listener_obj);
   }
   function initDefaultText()
   {
      var _loc1_ = this;
      _loc1_.defaultText = new Object();
      for(var i in _loc1_.lang_array)
      {
         _loc1_.defaultText[_loc1_.lang_array[i]] = new Object();
      }
      var _loc2_ = "...";
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_EN])[core.lang.Translator.DEFAULT_TEXT_TYPE_LOADING] = unescape("Loading") + _loc2_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_PT])[core.lang.Translator.DEFAULT_TEXT_TYPE_LOADING] = unescape("Carregando") + _loc2_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_DE])[core.lang.Translator.DEFAULT_TEXT_TYPE_LOADING] = unescape("Am Laden") + _loc2_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_FR])[core.lang.Translator.DEFAULT_TEXT_TYPE_LOADING] = unescape("Chargement") + _loc2_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_IT])[core.lang.Translator.DEFAULT_TEXT_TYPE_LOADING] = unescape("Caricando") + _loc2_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_ES])[core.lang.Translator.DEFAULT_TEXT_TYPE_LOADING] = unescape("Cargando") + _loc2_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_NL])[core.lang.Translator.DEFAULT_TEXT_TYPE_LOADING] = unescape("Laden") + _loc2_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_JA])[core.lang.Translator.DEFAULT_TEXT_TYPE_LOADING] = unescape("%E3%83%AD%E3%83%BC%E3%83%89%E4%B8%AD") + _loc2_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_CH])[core.lang.Translator.DEFAULT_TEXT_TYPE_LOADING] = unescape("%E4%B8%8B%E8%BD%BD%E4%B8%AD") + _loc2_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_ZH])[core.lang.Translator.DEFAULT_TEXT_TYPE_LOADING] = unescape("%E4%B8%8B%E8%BC%89%E4%B8%AD") + _loc2_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_KO])[core.lang.Translator.DEFAULT_TEXT_TYPE_LOADING] = unescape("%EB%A1%9C%EB%94%A9") + _loc2_;
      var _loc3_ = ": #";
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_EN])[core.lang.Translator.DEFAULT_TEXT_TYPE_ERROR] = unescape("Error") + _loc3_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_PT])[core.lang.Translator.DEFAULT_TEXT_TYPE_ERROR] = unescape("Erro") + _loc3_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_DE])[core.lang.Translator.DEFAULT_TEXT_TYPE_ERROR] = unescape("Fehler") + _loc3_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_FR])[core.lang.Translator.DEFAULT_TEXT_TYPE_ERROR] = unescape("Erreur") + _loc3_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_IT])[core.lang.Translator.DEFAULT_TEXT_TYPE_ERROR] = unescape("Errore") + _loc3_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_ES])[core.lang.Translator.DEFAULT_TEXT_TYPE_ERROR] = unescape("Error") + _loc3_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_NL])[core.lang.Translator.DEFAULT_TEXT_TYPE_ERROR] = unescape("Error") + _loc3_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_JA])[core.lang.Translator.DEFAULT_TEXT_TYPE_ERROR] = unescape("%E3%82%A8%E3%83%A9%E3%83%BC") + _loc3_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_CH])[core.lang.Translator.DEFAULT_TEXT_TYPE_ERROR] = unescape("%E9%94%99%E8%AF%AF") + _loc3_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_ZH])[core.lang.Translator.DEFAULT_TEXT_TYPE_ERROR] = unescape("%E9%8C%AF%E8%AA%A4") + _loc3_;
      Object(_loc1_.defaultText[core.lang.Translator.LANG_CODE_KO])[core.lang.Translator.DEFAULT_TEXT_TYPE_ERROR] = unescape("%EC%97%90%EB%9F%AC") + _loc3_;
   }
   function oTrace(tMessage_str)
   {
      if(this.getDebug())
      {
         trace("TRANSLATOR: " + tMessage_str);
      }
   }
   function toggleTargetPlayMode(tPlayMode_b)
   {
      if(tPlayMode_b == true)
      {
         _root[this.getTarget()].play();
      }
      else
      {
         _root[this.getTarget()].stop();
      }
   }
   function translate()
   {
      this.translateToTarget(this.getTarget());
   }
   function translateToTarget(tTarget)
   {
      var _loc1_ = this;
      _loc1_.setTarget(tTarget);
      _loc1_.oTrace("translateToTarget(): " + tTarget);
      var _loc2_ = new LoadVars();
      _loc2_.translator = _loc1_;
      _loc2_.onLoad = function(tSuccess_b)
      {
         var _loc1_ = new Object();
         _loc1_.type = "onLoad";
         _loc1_.success = "true";
         _loc1_.target = this.translator;
         this.translator.dispatchEvent(_loc1_);
      };
      _loc2_.onData = function(tXML_str)
      {
         var _loc2_ = this;
         _loc2_.translator.oTrace("onData()");
         var _loc1_ = new XML();
         _loc1_.ignoreWhite = true;
         _loc1_.parseXML(tXML_str);
         if(_loc1_.firstChild.nodeName.toUpperCase() == "XLIFF")
         {
            _loc2_.translator.translateXML(_loc1_);
            _loc2_.onLoad(true);
         }
         else
         {
            _loc2_.onLoad(false);
         }
      };
      _loc2_.randomNumber = random(9999999);
      _loc2_.lang = _loc1_.getLang();
      _loc2_.type_id = _loc1_.getTypeID();
      _loc2_.item_id = _loc1_.getItemID();
      var tURL_str = "";
      if(_loc1_.useWWWHost_boolean == true)
      {
         tURL_str = _loc1_.getWWWHost() + _loc1_.translationScriptPart2of2_str;
      }
      else
      {
         tURL_str = _loc1_.getTranslationScriptURL();
      }
      _loc1_.oTrace("sendAndLoad()");
      _loc1_.oTrace("\t URL: " + tURL_str);
      _loc1_.oTrace("\tpost: " + _loc2_.toString());
      _loc2_.sendAndLoad(tURL_str,_loc2_,"POST");
   }
   function translateXML(tTranslation_xml)
   {
      var tXLIFF_xml = tTranslation_xml.firstChild;
      var tFile_xml = tTranslation_xml.firstChild.firstChild;
      var tTransVarList = new Array();
      var transVar = function(tName, tValue)
      {
         var _loc1_ = this;
         _loc1_.name = tName;
         _loc1_.value = tValue;
         _loc1_.oTrace(_loc1_.name + " = " + _loc1_.value);
      };
      var l = tFile_xml.childNodes.length;
      var t = 0;
      var _loc3_;
      var _loc2_;
      var _loc1_;
      while(t < l)
      {
         var tSectionNode = tFile_xml.childNodes[t];
         if(tSectionNode.nodeName.toUpperCase() != "HEADER")
         {
            if(tSectionNode.nodeName.toUpperCase() == "BODY")
            {
               var tSectionLength = tSectionNode.childNodes.length;
               _loc3_ = 0;
               while(_loc3_ < tSectionLength)
               {
                  var tUnitNode = tSectionNode.childNodes[_loc3_];
                  var tSourceText = tUnitNode.firstChild.firstChild;
                  tTransVarList.push(new transVar(tUnitNode.attributes.resname.toString(),tSourceText.toString()));
                  _loc3_ = _loc3_ + 1;
               }
            }
            else if(tSectionNode.nodeName.toUpperCase() == "SYSTEM")
            {
               var tLangs_xmlnode = tSectionNode.firstChild;
               var tLangsMax_num = tLangs_xmlnode.childNodes.length;
               var tWesternLang_array = [];
               _loc2_ = 0;
               while(_loc2_ < tLangsMax_num)
               {
                  _loc1_ = tLangs_xmlnode.childNodes[_loc2_];
                  var tName_str = _loc1_.childNodes[0].firstChild.toString();
                  var tCode_str = _loc1_.childNodes[1].firstChild.toString().toUpperCase();
                  var tEnabled_str = _loc1_.childNodes[2].firstChild.toString();
                  var tLangGroup_str = _loc1_.childNodes[3].firstChild.toString().toUpperCase();
                  if(tLangGroup_str == core.lang.Translator.LANG_GROUP_WE)
                  {
                     tWesternLang_array.push(tCode_str);
                  }
                  _loc2_ = _loc2_ + 1;
               }
               this.setWesternLangs(tWesternLang_array);
               this.refreshAllTranslatableTextFields();
            }
         }
         t++;
      }
      this.copyVariablesToLocal(tTransVarList);
      var tTarget = Object(this.getTarget());
      var tVariableList = this.getVariableList();
      this.copyVariablesToTarget(tTarget,tVariableList);
   }
   function copyVariablesToLocal(tTransVarList)
   {
      var _loc2_ = tTransVarList;
      var _loc3_ = this;
      var tIDSVars = new Object();
      _loc3_.oTrace("copyVariablesToLocal()");
      var tLength_num = _loc2_.length;
      var _loc1_ = 0;
      while(_loc1_ < tLength_num)
      {
         tIDSVars[String(Object(_loc2_[_loc1_]).name)] = unescape(String(Object(_loc2_[_loc1_]).value));
         _loc3_.oTrace("\tvariable #" + _loc1_);
         _loc3_.oTrace("\t\tname: " + String(Object(_loc2_[_loc1_]).name));
         _loc3_.oTrace("\t\tvalue: " + tIDSVars[String(Object(_loc2_[_loc1_]).name)]);
         _loc1_ = _loc1_ + 1;
      }
      _loc3_.setVariableList(tIDSVars);
   }
   function copyVariablesToTarget(tTarget, tVariableList)
   {
      var _loc1_ = tVariableList;
      var _loc2_ = tTarget;
      for(var _loc3_ in _loc1_)
      {
         _loc2_[_loc3_] = _loc1_[_loc3_];
      }
      if(this.getPlayMode() == core.lang.Translator.PLAY_MODE_AUTOMATIC)
      {
         this.toggleTargetPlayMode(true);
         this.setPlayMode(core.lang.Translator.PLAY_MODE_MANUAL);
      }
   }
   function toString()
   {
      return "[_global.NPTranslator]";
   }
   function inArray(tNeedle, tHaystack_array)
   {
      var _loc1_ = tHaystack_array;
      var _loc3_ = tNeedle;
      for(var _loc2_ in _loc1_)
      {
         if(_loc1_[_loc2_] == _loc3_)
         {
            return true;
         }
      }
      return false;
   }
   function indexInArray(tNeedle, tHaystack_array)
   {
      var _loc2_ = tHaystack_array;
      var _loc3_ = tNeedle;
      var _loc1_ = 0;
      while(_loc1_ < _loc2_.length)
      {
         if(_loc2_[_loc1_].getInstance() == _loc3_.getInstance() || _loc2_[_loc1_].getInstance() == undefined)
         {
            return _loc1_;
         }
         _loc1_ = _loc1_ + 1;
      }
      return -1;
   }
   function removeTranslatableTextField(tTranslatableTextFieldInstance)
   {
      var _loc2_ = this;
      var _loc1_ = _loc2_.indexInArray(tTranslatableTextFieldInstance,_loc2_.translatableTextField_array);
      if(_loc1_ != -1)
      {
         _loc2_.translatableTextField_array.splice(_loc1_,1);
      }
   }
   function addTextField(tTextFieldInstanceOrString, properties)
   {
      var _loc2_ = properties;
      var _loc3_ = this;
      _loc3_.setDefaultTranslationTextFieldTarget(_loc2_.target == undefined ? _loc3_.targetDefault : _loc2_.target);
      var tSuppressRefresh_boolean = true;
      var _loc1_ = new core.lang.TranslatableTextFieldInstance(tTextFieldInstanceOrString,_loc3_.getDefaultTranslationTextFieldTarget(),tSuppressRefresh_boolean);
      _loc1_.setEmbedFonts(_loc3_.getEmbedFonts(),tSuppressRefresh_boolean);
      if(_loc2_.htmlText != undefined)
      {
         _loc1_.setHtmlText(_loc2_.htmlText);
      }
      var tFont_str = _loc2_.font == undefined ? _loc3_.fontDefault_str : _loc2_.font;
      _loc1_.setFont(tFont_str,tSuppressRefresh_boolean);
      if(_loc2_.useHTMLFontFace == true)
      {
         _loc1_.setUseHTMLFontFace(true,tSuppressRefresh_boolean);
      }
      _loc3_.removeTranslatableTextField(_loc1_);
      _loc3_.translatableTextField_array.push(_loc1_);
      return _loc1_;
   }
   function refreshAllTranslatableTextFields()
   {
      var _loc2_ = this;
      var _loc1_ = 0;
      while(_loc1_ < _loc2_.translatableTextField_array.length)
      {
         if(_loc2_.translatableTextField_array[_loc1_].getInstance() != undefined)
         {
            _loc2_.translatableTextField_array[_loc1_].setEmbedFonts(_loc2_.getEmbedFonts());
            _loc2_.translatableTextField_array[_loc1_].refresh();
         }
         else
         {
            _loc2_.removeTranslatableTextField(_loc2_.translatableTextField_array[_loc1_]);
            _loc1_ = _loc1_ - 1;
         }
         _loc1_ = _loc1_ + 1;
      }
   }
}
