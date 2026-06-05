function NPCardSenderClass()
{
   this.init();
}
userProfile = function(requestArray)
{
   this.getHelp = function()
   {
      var _loc3_ = "";
      _loc3_ += "USERPROFILE.getHelp()\n";
      _loc3_ += "------------------------\n";
      _loc3_ += "CONSTRUCTOR\n";
      _loc3_ += "        myUserProfile = new UserProfile(requestArray) // pass an array of propNumbers for needed info\n";
      _loc3_ += "PUBLIC METHODS\n";
      _loc3_ += "        getHelp()\n";
      _loc3_ += "        getProp(propNumber)\n";
      _loc3_ += "        getPercentComplete()\n";
      _loc3_ += "                PARAMETERS (propNumber)\n";
      var _loc2_ = 0;
      while(_loc2_ < this.possibleProps.length)
      {
         _loc3_ += "                        " + this.possibleProps[_loc2_] + " = " + (_loc2_ + 1) + "\n";
         _loc2_ = _loc2_ + 1;
      }
      return _loc3_;
   };
   this.isOnline = function()
   {
      if(String(_root._url).indexOf("file") == -1)
      {
         return true;
      }
      return false;
   };
   this.Tracer = new _root._level100.include.Tracer();
   this.Tracer.setPrefix("UserProfile:        ");
   this.Tracer.setSuffix("");
   this.Tracer.setTraceOn(traceOn);
   this.Tracer.trace("Created // traceOn = " + this.Tracer.getTraceOn(),1);
   this.Tracer.setTraceOn(traceOn);
   this.requestArray = requestArray;
   this.possibleProps = ["scores_sent","high_score","user_age","user_gender","pet1_name","pet1_color","pet1_species","user_full_name","user_email","user_country","user_dob","pet2_name","pet3_name","pet4_name"];
   this.levelNum = 110;
   if(_root._level0.id == undefined)
   {
      this.game_id = 7;
   }
   else
   {
      this.game_id = _root._level0.id;
   }
   var _loc6_ = "";
   var _loc7_ = this.requestArray.length;
   var _loc4_ = 0;
   while(_loc4_ < _loc7_)
   {
      _loc6_ += this.requestArray[_loc4_] + ";";
      _loc4_ = _loc4_ + 1;
   }
   if(this.isOnline())
   {
      this.url = "http://www.neopets.com/high_scores/fg_get_info.phtml?game_id=" + this.game_id + "&type=" + _loc6_;
   }
   else
   {
      this.url = "http://dev.neopets.com/high_scores/fg_get_info.phtml?game_id=" + this.game_id + "&type=" + _loc6_;
   }
   loadVariablesNum(this.url,this.levelNum);
   this.getPercentComplete = function()
   {
      var _loc2_ = 0;
      while(_loc2_ < this.possibleProps.length)
      {
         if(this.getProp(_loc2_) != -1 && this.getProp(_loc2_) != "-1")
         {
            return 100;
         }
         _loc2_ = _loc2_ + 1;
      }
      return -1;
   };
   this.getProp = function(tRequest)
   {
      if(isNan(tRequest) == true)
      {
         return _root["_level" + this.levelNum][tRequest];
      }
      propIndex = tRequest;
      var _loc3_ = _root["_level" + this.levelNum][this.possibleProps[propIndex - 1]];
      if(_loc3_ == undefined)
      {
         return -1;
      }
      return _loc3_;
   };
};
NPCardSenderClass.prototype = new MovieClip();
Object.registerClass("NPCardSenderSymbol",NPCardSenderClass);
NPCardSenderClass.prototype.isOnline = function()
{
   if(String(_root._url).indexOf("file") == -1)
   {
      return true;
   }
   return false;
};
NPCardSenderClass.prototype.init = function()
{
   if(_level0.IDS_CARD_PREPARING_EMAIL_FORM == undefined)
   {
      _level0.IDS_CARD_PREPARING_EMAIL_FORM = "PREPARING EMAIL FORM";
   }
   if(_level0.IDS_CARD_PLEASE_COMPLETE_THE_FORM == undefined)
   {
      _level0.IDS_CARD_PLEASE_COMPLETE_THE_FORM = "PLEASE COMPLETE THE FORM";
   }
   if(_level0.IDS_CARD_VALIDATING_FORM == undefined)
   {
      _level0.IDS_CARD_VALIDATING_FORM = "VALIDATING FORM";
   }
   if(_level0.IDS_CARD_SENDING_FORM == undefined)
   {
      _level0.IDS_CARD_SENDING_FORM = "SENDING FORM";
   }
   if(_level0.IDS_CARD_I_AM_DONE == undefined)
   {
      _level0.IDS_CARD_I_AM_DONE = "I am Done";
   }
   if(_level0.IDS_CARD_UNDERAGE_SENDER_NAME == undefined)
   {
      _level0.IDS_CARD_UNDERAGE_SENDER_NAME = "A Neopets.com User";
   }
   if(_level0.IDS_CARD_UNDERAGE_SENDER_EMAIL == undefined)
   {
      _level0.IDS_CARD_UNDERAGE_SENDER_EMAIL = "friend@mailout.neopets.com";
   }
   if(_level0.IDS_CARD_UNDERAGE_RECIPIENT_NAME == undefined)
   {
      _level0.IDS_CARD_UNDERAGE_RECIPIENT_NAME = "A Friend of Neopets.com";
   }
   if(_level0.IDS_CARD_PLEASE_COMPLETE_AND_SUBMIT_FORM == undefined)
   {
      _level0.IDS_CARD_PLEASE_COMPLETE_AND_SUBMIT_FORM = "PLEASE COMPLETE AND SUBMIT FORM";
   }
   if(_level0.IDS_CARD_YOUR_FIRST_NAME == undefined)
   {
      _level0.IDS_CARD_YOUR_FIRST_NAME = "Your First Name:";
   }
   if(_level0.IDS_CARD_YOUR_EMAIL_ADDRESS == undefined)
   {
      _level0.IDS_CARD_YOUR_EMAIL_ADDRESS = "Your Email Address:";
   }
   if(_level0.IDS_CARD_FRIENDS_FIRST_NAME == undefined)
   {
      _level0.IDS_CARD_FRIENDS_FIRST_NAME = "Friend\'s First Name: ";
   }
   if(_level0.IDS_CARD_FRIENDS_EMAIL_ADDRESS == undefined)
   {
      _level0.IDS_CARD_FRIENDS_EMAIL_ADDRESS = "Friend\'s Email Address:";
   }
   this.setCardSenderSymbol(this.cardSenderSymbol);
   this.setExtraText(this.extraText);
   this.setPictureID(this.pictureID);
   if(_level0.age == undefined)
   {
      _level0.age = "1";
   }
   if(_level0.age == "0")
   {
      this.setIsUnderage13(true);
   }
   else
   {
      this.setIsUnderage13(false);
   }
   trace("NPCardSenderClass: Formated for < 13: " + this.getIsUnderage13());
   if(_level0.baseurl == undefined)
   {
      if(this.isOnline())
      {
         this.BASE_URL = "http://www.neopets.com/process_sendgreeting.phtml?";
      }
      else
      {
         this.BASE_URL = "http://dev.neopets.com/process_sendgreeting.phtml?";
      }
   }
   else
   {
      this.BASE_URL = "http://" + _level0.baseurl + "/process_sendgreeting.phtml?";
   }
   this.lastSubmissionSuccess = 0;
   this.setSize(this._width,this._height);
   this.setButtonState(1);
   if(!this.userIsKnown())
   {
      this.userProfile = new UserProfile([8,9]);
   }
   this.setMode(0);
   this.backGround.sendersNameTitle_txt.text = _level0.IDS_CARD_YOUR_FIRST_NAME;
   this.backGround.sendersEmailTitle_txt.text = _level0.IDS_CARD_YOUR_EMAIL_ADDRESS;
   this.backGround.recipientNameTitle_txt.text = _level0.IDS_CARD_FRIENDS_FIRST_NAME;
   this.backGround.recipientEmailTitle_txt.text = _level0.IDS_CARD_FRIENDS_EMAIL_ADDRESS;
};
NPCardSenderClass.prototype.userIsKnown = function()
{
   var _loc1_ = _level0.username != undefined and _level0.sender_email != undefined;
   return _loc1_;
};
NPCardSenderClass.prototype.setButtonState = function(state)
{
   this.state = state;
   if(this.state == 1)
   {
      this.backGround.submit_but.tabIndex = 5;
      this.backGround.submit_but.onRelease = function()
      {
         this._parent._parent.fireSubmitHandler();
      };
      this.backGround.cancel_but.tabIndex = 6;
      this.backGround.cancel_but.onRelease = function()
      {
         this._parent._parent.fireCancelHandler();
      };
   }
   else
   {
      this.setCancelHandler(undefined);
      this.setSubmitHandler(undefined);
   }
};
NPCardSenderClass.prototype.setCardSenderSymbol = function(cardSenderSymbol)
{
   this.cardSenderSymbol = cardSenderSymbol;
};
NPCardSenderClass.prototype.setSubmitHandler = function(handler, timeLine, parameters)
{
   this.pSubmitHandler = handler;
   this.pSubmitTimeLine = timeLine != undefined ? timeLine : this._parent;
   this.pSubmitParameters = parameters;
};
NPCardSenderClass.prototype.getSubmitHandler = function()
{
   return this.pSubmitHandler;
};
NPCardSenderClass.prototype.fireSubmitHandler = function()
{
   (this.pSubmitTimeline + "." + this.getSubmitHandler())(this.pSubmitParameters);
};
NPCardSenderClass.prototype.setCancelHandler = function(handler, timeLine, parameters)
{
   this.pCancelHandler = handler;
   this.pCancelTimeLine = timeLine != undefined ? timeLine : this._parent;
   this.pCancelParameters = parameters;
};
NPCardSenderClass.prototype.getCancelHandler = function()
{
   return this.pCancelHandler;
};
NPCardSenderClass.prototype.fireCancelHandler = function()
{
   (this.pCancelTimeline + "." + this.getCancelHandler())(this.pCancelParameters);
};
NPCardSenderClass.prototype.setSize = function(width, height)
{
   this.height = height;
   this.width = width;
   this.loadBackGround(this.cardSenderSymbol);
};
NPCardSenderClass.prototype.loadBackGround = function(cardSenderSymbol)
{
   this.cardSenderBounds_mc.unloadMovie();
   this.attachMovie(this.cardSenderSymbol,"backGround",1);
   this.backGround._width = this.width;
   this.backGround._height = this.height;
   this.setErrorText("");
   this.setSenderNameText("");
   this.setSenderEmailText("");
   this.setRecipientNameText("");
   this.setRecipientEmailText("");
};
NPCardSenderClass.prototype.setTitleText = function(message)
{
   this.backGround.title_txt.html = true;
   this.backGround.title_txt.htmlText = message;
};
NPCardSenderClass.prototype.getTitleText = function()
{
   return this.backGround.title_txt.htmlText;
};
NPCardSenderClass.prototype.setErrorText = function(message)
{
   this.backGround.error_txt.html = true;
   this.backGround.error_txt.htmlText = "<p align=\'center\'>" + message + "</p>";
};
NPCardSenderClass.prototype.getErrorText = function()
{
   return this.backGround.error_txt.htmlText;
};
NPCardSenderClass.prototype.setSenderNameText = function(message)
{
   this.backGround.senderName_txt.html = false;
   Selection.setFocus(this.backGround.senderName_txt);
   this.backGround.senderName_txt.tabIndex = 1;
   this.backGround.senderName_txt.text = message;
   this.backGround.senderName_txt.editable = !this.getIsUnderage13();
   this.backGround.senderName_txt.selectable = !this.getIsUnderage13();
   if(this.getIsUnderage13())
   {
      this.backGround.senderName_txt.backgroundColor = 13421772;
   }
};
NPCardSenderClass.prototype.getSenderNameText = function()
{
   return this.backGround.senderName_txt.htmlText;
};
NPCardSenderClass.prototype.setSenderEmailText = function(message)
{
   this.backGround.senderEmail_txt.html = false;
   this.backGround.senderEmail_txt.tabIndex = 2;
   this.backGround.senderEmail_txt.text = message;
   this.backGround.senderEmail_txt.editable = !this.getIsUnderage13();
   this.backGround.senderEmail_txt.selectable = !this.getIsUnderage13();
   if(this.getIsUnderage13())
   {
      this.backGround.senderEmail_txt.backgroundColor = 13421772;
   }
};
NPCardSenderClass.prototype.getSenderEmailText = function()
{
   return this.backGround.senderEmail_txt.htmlText;
};
NPCardSenderClass.prototype.setRecipientNameText = function(message)
{
   this.backGround.recipientName_txt.html = false;
   this.backGround.recipientName_txt.tabIndex = 3;
   this.backGround.recipientName_txt.text = message;
   this.backGround.recipientName_txt.editable = !this.getIsUnderage13();
   this.backGround.recipientName_txt.selectable = !this.getIsUnderage13();
   this.backGround.recipientName_txt.background = true;
   if(this.getIsUnderage13())
   {
      this.backGround.recipientName_txt.backgroundColor = 13421772;
   }
};
NPCardSenderClass.prototype.getRecipientNameText = function()
{
   return this.backGround.recipientName_txt.htmlText;
};
NPCardSenderClass.prototype.setRecipientEmailText = function(message)
{
   this.backGround.recipientEmail_txt.html = false;
   this.backGround.recipientEmail_txt.tabIndex = 4;
   this.backGround.recipientEmail_txt.text = message;
};
NPCardSenderClass.prototype.getRecipientEmailText = function()
{
   return this.backGround.recipientEmail_txt.htmlText;
};
NPCardSenderClass.prototype.setPictureID = function(id)
{
   this.pPictureID = id;
};
NPCardSenderClass.prototype.getPictureID = function()
{
   return this.pPictureID;
};
NPCardSenderClass.prototype.setIsUnderage13 = function(tUnderage13_boolean)
{
   this.pIsUnderage13_boolean = tUnderage13_boolean;
};
NPCardSenderClass.prototype.getIsUnderage13 = function()
{
   return this.pIsUnderage13_boolean;
};
NPCardSenderClass.prototype.setExtraText = function(extraText)
{
   this.pExtraText = extraText;
};
NPCardSenderClass.prototype.getExtraText = function()
{
   return this.pExtraText;
};
NPCardSenderClass.prototype.setCancelText = function(message)
{
   this.backGround.cancel_txt.html = false;
   this.backGround.cancel_txt.text = message;
};
NPCardSenderClass.prototype.setSubmitText = function(message)
{
   this.backGround.submit_txt.html = false;
   this.backGround.submit_txt.text = message;
};
NPCardSenderClass.prototype.goToNextMode = function()
{
   this.modeNumber = this.modeNumber + 1;
   this.setMode(this.modeNumber);
};
NPCardSenderClass.prototype.goToLastMode = function()
{
   this.modeNumber = Math.max(0,--this.modeNumber);
   this.setMode(this.modeNumber);
};
NPCardSenderClass.prototype.setMode = function(modeNumber)
{
   if(typeof arguments[0][0] == "number")
   {
      this.modeNumber = Number(arguments[0][0]);
      this.setRecipientNameText("");
      this.setRecipientEmailText("");
   }
   else
   {
      this.modeNumber = modeNumber;
   }
   switch(this.modeNumber)
   {
      case 0:
         this.setErrorText(_level0.IDS_CARD_PREPARING_EMAIL_FORM);
         this.setCancelText(this.cancelButtonText);
         this.setCancelHandler(this.onCancelHandler,_root);
         this.setSubmitText("");
         this.setSubmitHandler(undefined,undefined);
         this.setOnEnterFrame("loadingUserProfile");
         return;
      case 1:
         if(this.lastSubmissionSuccess == 1)
         {
            this.setErrorText(_level0.IDS_CARD_PLEASE_COMPLETE_THE_FORM);
         }
         this.setSubmitText(this.submitButtonText);
         this.setSubmitHandler("goToNextMode",this,[1,2,3]);
         this.setOnEnterFrame("fillOutForm");
         return;
      case 2:
         this.setErrorText(IDS_CARD_VALIDATING_FORM);
         this.setSubmitText("");
         this.setSubmitHandler(undefined);
         this.sendCard(this.getSenderNameText(),this.getSenderEmailText(),this.getRecipientNameText(),this.getRecipientEmailText(),this.getPictureID(),this.getExtraText());
         this.setErrorText(_level0.IDS_CARD_SENDING_FORM);
         this.setOnEnterFrame("sendingForm");
         return;
      case 3:
         this.setCancelText(_level0.IDS_CARD_I_AM_DONE);
         this.setCancelHandler(this.onCompletedHandler,_root);
         this.setSubmitText(this.sendAnotherCardButtonText);
         this.setSubmitHandler("setMode",this,[1]);
         this.setOnEnterFrame("sendingForm");
         return;
      default:
         trace("NPCardSenderClass:  CASE ERROR");
         return;
   }
};
NPCardSenderClass.prototype.setOnEnterFrame = function(modeName)
{
   this.onEnterFrame = this[modeName];
};
NPCardSenderClass.prototype.loadingUserProfile = function()
{
   if(this.userIsKnown())
   {
      if(this.getIsUnderage13())
      {
         this.setSenderNameText(_level0.IDS_CARD_UNDERAGE_SENDER_NAME);
         this.setSenderEmailText(_level0.IDS_CARD_UNDERAGE_SENDER_EMAIL);
         this.setRecipientNameText(_level0.IDS_CARD_UNDERAGE_RECIPIENT_NAME);
      }
      else
      {
         this.setSenderNameText(_level0.userName);
         this.setSenderEmailText(_level0.sender_email);
      }
      this.setErrorText(_level0.IDS_CARD_PLEASE_COMPLETE_AND_SUBMIT_FORM);
      this.gotoNextMode();
   }
   else if(this.userProfile.getPercentComplete() == 100)
   {
      if(this.getIsUnderage13())
      {
         this.setSenderNameText(_level0.IDS_CARD_UNDERAGE_SENDER_NAME);
         this.setSenderEmailText(_level0.IDS_CARD_UNDERAGE_SENDER_EMAIL);
         this.setRecipientNameText(_level0.IDS_CARD_UNDERAGE_RECIPIENT_NAME);
      }
      else
      {
         this.setSenderNameText(this.userProfile.getProp("username"));
         this.setSenderEmailText(this.userProfile.getProp(9));
      }
      this.setErrorText(_level0.IDS_CARD_PLEASE_COMPLETE_AND_SUBMIT_FORM);
      this.gotoNextMode();
   }
};
NPCardSenderClass.prototype.fillOutForm = function()
{
};
NPCardSenderClass.prototype.sendingForm = function()
{
};
NPCardSenderClass.prototype.doneForm = function()
{
};
NPCardSenderClass.prototype.sendCard = function(fromName, fromEmail, toName, toEmail, ProjectPictureID, projectExtraText)
{
   var _loc3_ = new LoadVars();
   _loc3_.cardSender = this;
   _loc3_.onLoad = function()
   {
      this.cardSender.setErrorText(String(this.error_str).toUpperCase());
      if(this.success != "1")
      {
         this.cardSender.goToLastMode();
      }
      else
      {
         this.cardSender.goToNextMode();
      }
      this.cardSender.lastSubmissionSuccess = this.success;
   };
   var _loc2_ = "";
   _loc2_ += "flash=1";
   _loc2_ += "&sender_name=" + escape(fromName);
   _loc2_ += "&sender_email=" + escape(fromEmail);
   _loc2_ += "&recipient_name=" + escape(toName);
   _loc2_ += "&recipient_email=" + escape(toEmail);
   _loc2_ += "&picture_id=" + escape(ProjectPictureID);
   _loc2_ += "&extra_text=" + escape(projectExtraText);
   var _loc4_ = this.BASE_URL + _loc2_;
   trace("CALLING-> " + _loc4_);
   _loc3_.sendAndLoad(_loc4_,_loc3_,"POST");
};
