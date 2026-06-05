_root.CR.addContent(summary_txt,"Summary Title",_level0.IDS_summary_txt);
_root.CR.addContent(press_space_txt,"Press Space",_level0.IDS_press_space_txt);
_root.CR.addContent(accuracy_txt,"accuracy_txt",_level0.IDS_accuracy_txt);
_root.CR.addContent(response_txt,"response_txt",_level0.IDS_response_txt);
_root.CR.addContent(result_txt,"result_txt","");
_root.CR.addContent(score_txt,"score_txt",_level0.IDS_stagescore_txt);
_root.CR.addContent(comment_txt,"comment",_root.grading_comment_txt);
if(_root.stagecount < 7)
{
   if(_root.stageres)
   {
      _root.CR.addContent(passed_txt,"passed_txt",_level0.IDS_passed_txt);
   }
   else
   {
      _root.CR.addContent(passed_txt,"passed_txt",_level0.IDS_failed_txt);
   }
}
else
{
   _root.CR.addContent(passed_txt,"passed_txt","");
}
this.percent_txt = _root.stageratio + "%";
this.time_txt = _root.stageresponse + "s";
this.scoreval_txt = _root.stagescore;
_root.CR.flushRegister();
_root.game.spaceReady();
stop();
