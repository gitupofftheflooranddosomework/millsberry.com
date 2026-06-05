on(release, keyPress "<Enter>"){
   var errorMsg = [];
   if(this.iName == undefined)
   {
      errorMsg.push("Name");
   }
   if(this.iMail == undefined)
   {
      errorMsg.push("Email");
   }
   if(errorMsg.length > 0)
   {
      var max = errorMsg.length;
      var message = "You forgot the following information:  ";
      var x = 0;
      while(x < max)
      {
         message += errorMsg[x];
         if(x < max - 1)
         {
            message += ", ";
         }
         x++;
      }
      this.errorMessage.play();
      this.errorMessage.bg.gotoAndStop("error");
      this.errorMessage.tText = "<P ALIGN=\'CENTER\'>Error. " + message + "</P>";
      return undefined;
   }
   if(this.dataListener != undefined)
   {
      this.dataListener.removeMovieClip();
   }
   this.createEmptyMovieClip("dataListener",9999);
   this.dataListener.onData = function()
   {
      var _loc1_ = this;
      var _loc2_ = 1;
      for(var x in _loc1_)
      {
         _loc2_ = _loc2_ + 1;
      }
      var _loc3_ = "";
      if(_loc1_.str != "success")
      {
         if(_loc1_.str == "error_db")
         {
            _loc3_ += "Database Error";
         }
         else if(_loc1_.str == "error_max")
         {
            _loc3_ += "You Have Reached The Max Email Limit For The Day. Please Try Again Tomorrow.";
         }
         else if(_loc1_.str == "error_invalid_email")
         {
            _loc3_ += "Invalid Email";
         }
         else if(_loc1_.str == "error_profanity")
         {
            _loc3_ += "Profanity Is Not Allowed.";
         }
         else if(_loc1_.str == undefined)
         {
            _loc3_ += "Connection Error. Please Try Again";
         }
         var messageBox = _loc1_._parent.errorMessage;
         messageBox.play();
         messageBox.bg.gotoAndStop("error");
         messageBox.tText = "<P ALIGN=\'CENTER\'>Error. " + _loc3_ + "</P>";
      }
      else
      {
         var messageBox = _loc1_._parent.errorMessage;
         messageBox.play();
         messageBox.tText = "<P ALIGN=\'CENTER\'>Challenge Card Sent</P>";
         messageBox.bg.gotoAndStop("success");
         _loc1_._parent.iMail = "";
         _loc1_._parent.iName = "";
      }
   };
   var x_action = "email";
   var x_sender = username;
   var x_score = _root.GAMESCORE.show();
   var x_recipient = this.iName;
   var x_email = this.iMail;
   var x_card_state = "I earned " + _root.GAMESCORE.show() + " Neopoints in the Cinnamon Toast Crunch Swirl game. Can you beat me?";
   var theurl = "http://www.neopets.com/games/cinnamon/process_cinnamon.inc?x_action=" + x_action + "&x_recipient=" + x_recipient + "&x_score=" + x_score + "&x_email=" + x_email + "&x_card_state=" + x_card_state;
   loadVariables(theurl,this.dataListener,"POST");
}
