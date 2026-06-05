this.blocker_but.useHandCursor = 0;
var tExtraText = "I reached Level " + _root.eLevel.show() + " and earned " + _root.eScore.show() + " Points! How well will you do?";
cardSender_cmp.setExtraText(tExtraText);
var tTitleText = "<p align =\'center\'>SEND A CHALLENGE CARD TO A FRIEND\n\nEarn 100 Neopoints* and send a Challenge Card to your friends with the text:\n \'" + cardSender_cmp.getExtraText() + "\'\n\n</p><p align=\'right\'>*Max 3 times daily</p>";
cardSender_cmp.setTitleText(tTitleText);
_root.onCancelHandler = function()
{
   _root.endprompt.challengecard_mc.removeMovieClip();
};
_root.onCompletedHandler = function()
{
   _root.endprompt.challengecard_mc.removeMovieClip();
};
