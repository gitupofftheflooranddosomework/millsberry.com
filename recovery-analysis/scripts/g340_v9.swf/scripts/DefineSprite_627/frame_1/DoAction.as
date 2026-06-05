function scrollDown(inc)
{
   gotoAndStop(1);
   if(_parent.content._y + inc > 0)
   {
      _parent.content._y = 0;
   }
   else if(_parent.content._y + inc < scrollLimit)
   {
      _parent.content._y = scrollLimit;
   }
   else
   {
      _parent.content._y += inc;
   }
   setTracker();
}
function setTracker()
{
   tracker._y = tracker.min + Math.floor(_parent.content._y / scrollLimit * (tracker.max - tracker.min));
}
autoScroll = 0;
scrollCoeff = 3;
stop();
