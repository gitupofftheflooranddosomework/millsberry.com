function playGame()
{
   _root.buttonSound();
   _root.gotoAndPlay("gameFrame");
}
function viewInstructions()
{
   _root.buttonSound();
   _root.gotoAndPlay("instructionsframe");
}
function viewControls()
{
   _root.buttonSound();
   _root.gotoAndPlay("controlsframe");
}
function endGame()
{
   _root.buttonSound();
   _root.game.destructor();
   delete game;
   _root.gotoAndPlay("gameoverframe");
}
function visitWebsite()
{
   _root.buttonSound();
   trace("visit website");
}
function back()
{
   _root.buttonSound();
   _root.gotoAndPlay("gameSetup");
}
function sendScore()
{
   _root.buttonSound();
   _root.gotoAndPlay("sendScoreFrame");
}
function assignKeyCode(pnum)
{
   _root.keycapture.showWin(pnum);
   _root.enable_controls_buttons = false;
}
