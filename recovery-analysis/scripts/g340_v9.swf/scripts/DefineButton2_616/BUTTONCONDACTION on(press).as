on(press){
   _root.rollBtnSm();
   autoScroll = 1;
   if(_ymouse < tracker.min + tracker._height / 2)
   {
      contentTarg = 0;
      trackerTarg = tracker.min;
   }
   else if(_ymouse > tracker.max + tracker._height / 2)
   {
      contentTarg = scrollLimit;
      trackerTarg = tracker.max;
   }
   else
   {
      contentTarg = Math.floor((_ymouse - tracker.min + tracker._height / 2) / (tracker.max - tracker.min + tracker._height) * scrollLimit);
      trackerTarg = Math.floor(_ymouse - tracker._height / 2);
   }
   gotoAndPlay(2);
}
