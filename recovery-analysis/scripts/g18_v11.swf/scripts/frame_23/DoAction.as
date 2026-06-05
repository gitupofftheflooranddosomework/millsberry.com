stop();
_root.clearScreen();
if(_root.GAMESCORE.show() >= 400)
{
   _root.minToFeed = true;
}
if(_root.minToFeed)
{
   _root.feedToggle.gotoAndStop(2);
}
gMyNeoStatus.sendTag("Game Finished");
