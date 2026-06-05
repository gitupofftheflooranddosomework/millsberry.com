_root.challengecardCode = function()
{
   _root.endPrompt.attachMovie("prompt_challengeCard_mc","challengecard_mc",1000);
};
_root.endgamecode = function()
{
   trace("endgamecode()");
   Key.removeListener(_root.world);
   _root.world.player.removeItem(gList.actorList);
   _root.makePrompt("gameOver");
   _root.world.player.removeMovieClip();
};
