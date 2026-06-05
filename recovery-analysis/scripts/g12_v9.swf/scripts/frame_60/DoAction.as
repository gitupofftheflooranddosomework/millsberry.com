stop();
var score_num = _root.GAMESCORE.show();
var score_msg;
if(score_num < 100)
{
   score_msg = _root.IDS_BAD_MSG;
}
else if(score_num >= 100 && score_num < 200)
{
   score_msg = _root.IDS_GOOD_MSG;
}
else if(score_num >= 200)
{
   score_msg = _root.IDS_BETTER_MSG;
}
this.endText.htmlText = "<P ALIGN=\'CENTER\'><FONT SIZE=\'16\'>" + _root.IDS_YOU_REACHED_LEVEL_TXT + " " + _root.ROUND.show() + "<BR>" + _root.IDS_YOURSCORE_TXT + ": " + score_num + "<BR>" + score_msg + "</FONT></P>";
