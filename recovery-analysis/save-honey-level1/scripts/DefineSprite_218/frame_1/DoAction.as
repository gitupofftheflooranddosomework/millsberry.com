btn_playagain.onRelease = function()
{
   this._parent._parent._parent.myPR.activity(this._parent._parent._parent.myPR.activityID.Game.RESTART);
   _parent.gotoAndStop("game");
};
btn_gotolevel2.onRelease = function()
{
   trace(this + " / " + _parent.myPR);
   this._parent._parent._parent.myPR.launchURL(_root.clickTag1);
};
var popo = _parent;
var isCAForSTAF = "CAF";
