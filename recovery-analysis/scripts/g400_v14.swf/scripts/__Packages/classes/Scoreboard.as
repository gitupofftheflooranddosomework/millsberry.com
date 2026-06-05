class classes.Scoreboard extends MovieClip
{
   var average_reaction;
   var belts_mc;
   var consechit;
   var correct_hits;
   var curr_belt;
   var currentstagescore;
   var ench;
   var gameptr;
   var hench;
   var lasthit;
   var maxscore;
   var pass;
   var ratio;
   var score;
   var scorecountstage;
   var scoreval_txt;
   var stage;
   var thisscore;
   var total_hits;
   var total_reaction;
   function Scoreboard()
   {
      super();
      this.ench = 1 + int(Math.random() * 43);
      if(_root.CURRENTBELT.show() + 1 > 7)
      {
         this.curr_belt = 8 * this.ench;
      }
      else
      {
         this.curr_belt = (_root.CURRENTBELT.show() + 1) * this.ench;
      }
      this.belts_mc.gotoAndStop(this.curr_belt / this.ench);
      this.score = 0;
      this.ratio = 0;
      this.scorecountstage = 1;
      this.currentstagescore = 0;
      this.scoreval_txt = 0;
      this.lasthit = false;
      this.consechit = 0;
      this.thisscore = 0;
   }
   function init(pmc, pstage)
   {
      this.gameptr = pmc;
      this.stage = pstage * this.ench;
      this.assignPassingMarks(this.gameptr);
   }
   function getAP(pn)
   {
      var _loc1_ = int(pn * 10 * 1.5);
      return _loc1_;
   }
   function assignPassingMarks(pmc)
   {
      this.pass = new Array();
      this.pass[0] = 50;
      this.pass[1] = 55;
      this.pass[2] = 60;
      this.pass[3] = 60;
      this.pass[4] = 65;
      this.pass[5] = 65;
      this.pass[6] = 70;
      this.pass[7] = 70;
      this.pass[8] = 75;
      this.pass[9] = 75;
      this.maxscore = new Array();
      this.maxscore[0] = this.getAP(10);
      this.maxscore[1] = this.getAP(16);
      this.maxscore[2] = this.getAP(27);
      this.maxscore[3] = this.getAP(34);
      this.maxscore[4] = this.getAP(40);
      this.maxscore[5] = this.getAP(45);
      this.maxscore[6] = this.getAP(49);
      this.maxscore[7] = this.getAP(52);
      this.maxscore[8] = this.getAP(54);
      this.maxscore[9] = this.getAP(55);
      var _loc2_ = 0;
      while(_loc2_ < this.pass.length)
      {
         this.pass[_loc2_] *= this.ench;
         this.maxscore[_loc2_] *= this.ench;
         _loc2_ = _loc2_ + 1;
      }
   }
   function getMaxScore(pnum)
   {
      var _loc2_ = this.maxscore[pnum] / this.ench;
      return _loc2_;
   }
   function getPassingMark(pnum)
   {
      var _loc2_ = _root.POINTSNEEDED.show();
      return _loc2_;
   }
   function resetConsec()
   {
      this.consechit = 0;
   }
   function getConsec()
   {
      return this.consechit / this.hench;
   }
   function addThisScore(pnum)
   {
      this.thisscore += pnum * this.hench;
   }
   function getThisScore()
   {
      return this.thisscore / this.hench;
   }
   function resetThisScore()
   {
      this.thisscore = 0;
   }
   function compileHits(phit, preact)
   {
      if(phit)
      {
         this.correct_hits += this.hench;
         if(this.consechit > 0)
         {
            this.gameptr.makeHitSprite(this.getConsec());
         }
         this.addThisScore(5 + this.getConsec());
         this.consechit += this.hench;
      }
      else
      {
         this.consechit = 0;
      }
      this.total_hits += this.hench;
      this.total_reaction += preact;
      this.lasthit = phit;
   }
   function resetHits()
   {
      this.hench = 1 + int(Math.random() * 37);
      this.correct_hits = 0;
      this.total_hits = 0;
      this.ratio = 0;
      this.total_reaction = 0;
      this.resetThisScore();
      if(!this.ifPassed())
      {
         this.resetScore();
      }
   }
   function consolidateHits(plaststage)
   {
      var _loc5_ = this.stage / this.ench - 1;
      var _loc4_ = false;
      this.ratio = int(this.correct_hits / this.total_hits * 100);
      this.average_reaction = int(this.total_reaction / (this.total_hits / this.hench) / 10);
      this.average_reaction /= 100;
      var _loc3_ = this.average_reaction * 1000;
      _loc3_ = _root.game.getCurrentWaitTime() - _loc3_;
      _loc3_ /= _root.game.getCurrentWaitTime();
      if(_loc5_ > 6)
      {
         _loc3_ += 0.7 * (_loc5_ / 10);
      }
      if(_loc3_ > 1)
      {
         _loc3_ = 1;
      }
      this.currentstagescore = int(this.getThisScore() * _loc3_);
      this.currentstagescore *= this.ench;
      _root.stagescore = this.getCurrentStageScore();
      _loc4_ = this.ifPassed();
      _root.stagecount = _loc5_ + 1;
      _root.stageres = _loc4_;
      _root.stageratio = this.ratio;
      _root.stageresponse = this.average_reaction;
      _root.grading_comment_txt = _level0.IDS_comment_bad_txt;
      this.addScore(this.getCurrentStageScore());
      if(_loc4_)
      {
         !plaststage ? (_root.grading_comment_txt = _level0.IDS_comment_good_txt) : (_root.grading_comment_txt = _level0.IDS_comment_end_txt);
      }
   }
   function getCurrentStageScore()
   {
      return this.currentstagescore / this.ench;
   }
   function addScore(pscore)
   {
      this.score += this.ench * pscore;
      this.scoreval_txt = this.score / this.ench;
   }
   function resetScore(pscore)
   {
      this.score = 0;
      this.scoreval_txt = this.score;
   }
   function getScore()
   {
      return this.score / this.ench;
   }
   function getStage()
   {
      return this.stage / this.ench;
   }
   function upgradeBelt()
   {
      this.curr_belt += this.ench;
      if(this.curr_belt / this.ench <= 8)
      {
         this.belts_mc.gotoAndStop(this.curr_belt / this.ench);
      }
      this.stage += this.ench;
   }
   function ifPassed()
   {
      var _loc3_ = false;
      var _loc4_ = this.getCurrentStageScore();
      var _loc2_ = this.getPassingMark(this.stage / this.ench - 1);
      if(_loc2_ == 0)
      {
         _loc2_ = 1;
      }
      if(_loc4_ >= _loc2_)
      {
         _loc3_ = true;
      }
      return _loc3_;
   }
   function destructor()
   {
      _root.GAMESCORE.changeBy(this.getScore());
      this.removeMovieClip();
   }
}
