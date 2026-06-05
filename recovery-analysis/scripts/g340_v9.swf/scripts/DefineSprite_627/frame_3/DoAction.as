if(Math.abs(_parent.content._y - contentTarg) < 0.5)
{
   _parent.content._y = contentTarg;
   setTracker();
}
else
{
   gotoAndPlay(2);
}
