final_score.text = _parent.score;
enter_initials.restrict = "A-Z";
enter_initials.setFocus();
btn_submit.onRelease = function()
{
   if(enter_initials.text.length == 3)
   {
      this._parent._parent._parent.myPR.activity(4);
      _parent.submitHighScoreInitials(enter_initials.text);
   }
   else
   {
      trace("Please enter your initials");
      enter_initials.setFocus();
   }
};
