class gmi.lang.Translator
{
   var IDSVars_array;
   var name;
   var onLoad;
   var pEventDispatcher;
   var targetDefault;
   var target_mc;
   var textField_array;
   var translationScriptPart2of2_str;
   var translator;
   var value;
   var westernLang_array;
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
   function Translator()
   {
      _global.NPTranslator = this;
      this.pEventDispatcher = new mx.events.EventDispatcher();
      this.pEventDispatcher.initialize(this);
      this.setDebug(false);
      this.setLang("EN");
      this.setTypeID(14);
      this.setItemID(53);
      this.setPlayMode("MANUAL");
      this.setTarget("_level0");
      this.setWesternLangs(["EN","PT","DE","FR","IT","ES"]);
      this.setReturnFormat("XML");
      this.textField_array = [];
      this.translationScriptPart2of2_str = "/transcontent/gettranslationxml.phtml";
      if(this.getPlayMode() == "AUTOMATIC")
      {
         this.toggleTargetPlayMode(false);
         this.translate();
      }
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
      this.lang_str = String(tValue).toUpperCase();
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
      return this.userHardCodedEmbedFonts_boolean != undefined ? this.userHardCodedEmbedFonts_boolean : this.getLangGroup() == "WE";
   }
   function setEmbedFonts(tValue)
   {
      this.userHardCodedEmbedFonts_boolean = tValue;
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
      if(this.targetDefault == undefined)
      {
         this.targetDefault = _level0;
      }
      return this.targetDefault;
   }
   function getTextFieldList()
   {
      return this.textField_array;
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
   function setLangGroup(tValue)
   {
      this.langGroup_str = String(tValue).toLowerCase();
   }
   function getLangGroup()
   {
      var _loc2_ = String("NW");
      var _loc3_ = this.getWesternLangs();
      for(var _loc4_ in _loc3_)
      {
         if(this.getLang().toUpperCase() == this.getWesternLangs()[_loc4_].toUpperCase())
         {
            _loc2_ = "WE";
            break;
         }
      }
      this.langGroup_str = String(_loc2_).toUpperCase();
      return this.langGroup_str;
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
      this.setTarget(tTarget);
      this.oTrace("translateToTarget(): " + tTarget);
      var _loc2_ = new LoadVars();
      _loc2_.translator = this;
      _loc2_.onLoad = function(tSuccess_b)
      {
         var _loc2_ = new Object();
         _loc2_.type = "onLoad";
         _loc2_.success = "true";
         _loc2_.target = this.translator;
         this.translator.dispatchEvent(_loc2_);
      };
      _loc2_.onData = function(tXML_str)
      {
         this.translator.oTrace("onData()");
         var _loc2_ = new XML();
         _loc2_.ignoreWhite = true;
         _loc2_.parseXML(tXML_str);
         if(_loc2_.firstChild.nodeName.toUpperCase() == "XLIFF")
         {
            this.translator.translateXML(_loc2_);
            this.onLoad(true);
         }
         else
         {
            this.onLoad(false);
         }
      };
      _loc2_.randomNumber = random(9999999);
      _loc2_.lang = this.getLang();
      _loc2_.type_id = this.getTypeID();
      _loc2_.item_id = this.getItemID();
      var _loc5_ = "";
      if(this.useWWWHost_boolean == true)
      {
         _loc5_ = this.getWWWHost() + this.translationScriptPart2of2_str;
      }
      else
      {
         _loc5_ = this.getTranslationScriptURL();
      }
      this.oTrace("sendAndLoad()");
      this.oTrace("\t URL: " + _loc5_);
      this.oTrace("\tpost: " + _loc2_.toString());
      _loc2_.sendAndLoad(_loc5_,_loc2_);
   }
   function translateXML(tTranslation_xml)
   {
      var _loc23_ = tTranslation_xml.firstChild;
      var _loc19_ = tTranslation_xml.firstChild.firstChild;
      var _loc17_ = new Array();
      var _loc18_ = function(tName, tValue)
      {
         this.name = tName;
         this.value = tValue;
         this.oTrace(this.name + " = " + this.value);
      };
      var _loc20_ = _loc19_.childNodes.length;
      var _loc11_ = 0;
      var _loc5_;
      var _loc16_;
      var _loc3_;
      var _loc6_;
      var _loc9_;
      var _loc12_;
      var _loc15_;
      var _loc10_;
      var _loc4_;
      var _loc2_;
      var _loc13_;
      var _loc8_;
      var _loc14_;
      var _loc7_;
      while(_loc11_ < _loc20_)
      {
         _loc5_ = _loc19_.childNodes[_loc11_];
         if(_loc5_.nodeName.toUpperCase() != "HEADER")
         {
            if(_loc5_.nodeName.toUpperCase() == "BODY")
            {
               _loc16_ = _loc5_.childNodes.length;
               _loc3_ = 0;
               while(_loc3_ < _loc16_)
               {
                  _loc6_ = _loc5_.childNodes[_loc3_];
                  _loc9_ = _loc6_.firstChild.firstChild;
                  _loc17_.push(new _loc18_(_loc6_.attributes.resname.toString(),_loc9_.toString()));
                  _loc3_ = _loc3_ + 1;
               }
            }
            else if(_loc5_.nodeName.toUpperCase() == "SYSTEM")
            {
               _loc12_ = _loc5_.firstChild;
               _loc15_ = _loc12_.childNodes.length;
               _loc10_ = [];
               _loc4_ = 0;
               while(_loc4_ < _loc15_)
               {
                  _loc2_ = _loc12_.childNodes[_loc4_];
                  _loc13_ = _loc2_.childNodes[0].firstChild.toString();
                  _loc8_ = _loc2_.childNodes[1].firstChild.toString().toUpperCase();
                  _loc14_ = _loc2_.childNodes[2].firstChild.toString();
                  _loc7_ = _loc2_.childNodes[3].firstChild.toString().toUpperCase();
                  if(_loc7_ == "WE")
                  {
                     _loc10_.push(_loc8_);
                  }
                  _loc4_ = _loc4_ + 1;
               }
               this.setWesternLangs(_loc10_);
               this.refreshAllTextFields();
            }
         }
         _loc11_ = _loc11_ + 1;
      }
      this.copyVariablesToLocal(_loc17_);
      var _loc21_ = this.getTarget();
      var _loc22_ = this.getVariableList();
      this.copyVariablesToTarget(_loc21_,_loc22_);
   }
   function copyVariablesToLocal(tTransVarList)
   {
      var _loc4_ = Object();
      this.oTrace("copyVariablesToLocal()");
      var _loc5_ = tTransVarList.length;
      var _loc2_ = 0;
      while(_loc2_ < _loc5_)
      {
         _loc4_[String(tTransVarList[_loc2_].name)] = unescape(String(tTransVarList[_loc2_].value));
         this.oTrace("\tvariable #" + _loc2_);
         this.oTrace("\t\tname: " + String(tTransVarList[_loc2_].name));
         this.oTrace("\t\tvalue: " + _loc4_[String(tTransVarList[_loc2_].name)]);
         _loc2_ = _loc2_ + 1;
      }
      this.setVariableList(_loc4_);
   }
   function copyVariablesToTarget(tTarget, tVariableList)
   {
      for(var _loc4_ in tVariableList)
      {
         tTarget[_loc4_] = tVariableList[_loc4_];
      }
      if(this.getPlayMode() == "AUTOMATIC")
      {
         this.toggleTargetPlayMode(true);
         this.setPlayMode("MANUAL");
      }
   }
   function toString()
   {
      return "[_global.NPTranslator]";
   }
   function addTextField(tTextFieldInstanceOrString, properties)
   {
      this.setDefaultTranslationTextFieldTarget(properties.target == undefined ? this.targetDefault : properties.target);
      var _loc2_ = new gmi.lang.TranslatableTextFieldInstance(tTextFieldInstanceOrString,this.getDefaultTranslationTextFieldTarget());
      if(properties.htmlText != undefined)
      {
         _loc2_.setHtmlText(properties.htmlText);
      }
      var _loc4_ = properties.font == undefined ? this.fontDefault_str : properties.font;
      _loc2_.setFont(_loc4_);
      _loc2_.setEmbedFonts(this.getEmbedFonts());
      _loc2_.refresh();
      this.textField_array.push(_loc2_);
      return _loc2_;
   }
   function refreshAllTextFields()
   {
      var _loc2_ = 0;
      while(_loc2_ < this.textField_array.length)
      {
         this.textField_array[_loc2_].setEmbedFonts(this.getEmbedFonts());
         this.textField_array[_loc2_].refresh();
         _loc2_ = _loc2_ + 1;
      }
   }
}
