if(_root.user_petName == -1)
{
   prevFrame();
}
else
{
   _root.feedButtonUnformattedText = "Feed " + _root.user_petName + " Cinnamon Toast Crunch";
   _root.feedButtonText = "<P align=\'center\'>" + _root.feedButtonUnformattedText + "</P>";
}
if(_root.minToFeed)
{
   _root.feedToggle.gotoAndStop(2);
}
stop();
