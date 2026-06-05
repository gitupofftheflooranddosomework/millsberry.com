elapsedtime = getTimer() / 1000 - sendtime;
if(elapsedtime >= 30)
{
   scoring_meter.showMsg(7);
   gotoAndStop("promptuserframe");
}
else
{
   gotoAndStop("scoreidle");
   play();
}
