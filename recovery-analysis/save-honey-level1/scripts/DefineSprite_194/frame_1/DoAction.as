tfTopScores.text = "";
var userInList = false;
trace("compare user\'s initials and score: " + _parent.userInitials + " : " + _parent.score);
var i = 0;
while(i < _parent.aScores.length)
{
   tfTopScores.text += _parent.aScores[i].name._value + "\t" + _parent.aScores[i].score._value + "\n";
   if(!userInList and _parent.userInitials == _parent.aScores[i].name._value and String(_parent.score) == _parent.aScores[i].score._value)
   {
      MC_Panel_Topscoresarrow._y += tfTopScores.textHeight;
      userInList = true;
   }
   i++;
}
MC_Panel_Topscoresarrow._visible = userInList;
btn_playagain.onRelease = function()
{
   this._parent._parent._parent.myPR.activity(this._parent._parent._parent.myPR.activityID.Game.RESTART);
   _parent.gotoAndStop("game");
};
btn_challengeafriend.onRelease = function()
{
   this._parent._parent._parent.myPR.activity(3);
   _parent.gotoAndStop("CAF");
};
btn_gotolevel2.onRelease = function()
{
   trace(this + " / " + _parent.myPR);
   this._parent._parent._parent.myPR.launchURL(_root.clickTag1);
};
