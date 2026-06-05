class classes.Game
{
   var action;
   var allowspace;
   var correctmove;
   var currTime;
   var curr_move_length;
   var curr_sequence_length;
   var currdir;
   var current_i;
   var current_move;
   var current_stage;
   var current_wait_time;
   var defence_array;
   var dummy;
   var firstcheck;
   var flashing;
   var gstage;
   var hccounter;
   var in_play;
   var lasthold;
   var myscore;
   var mysubmit;
   var no_moves;
   var offense_array;
   var on_offense;
   var prompt;
   var ptr;
   var reactiontime;
   var robot_choice;
   var scoreboard;
   var startTime;
   var submitreq;
   var timer;
   var userdir;
   var usermove;
   var waittime;
   var TOTAL_STAGES = 10;
   var FINAL_STAGE = 1;
   var MAX_WAIT_TIME = 1000;
   var MIN_WAIT_TIME = 250;
   var SPECITEM = 0;
   var specitem1 = 0;
   var specitem2 = 0;
   var specitem3 = 0;
   function Game()
   {
      this.allowspace = false;
      this.hccounter = 0;
      this.firstcheck = true;
      this.current_stage = _root.CURRENTBELT.show() + 1;
      this.FINAL_STAGE = _root.CURRENTBELT.show() + 1;
      if(_root.CURRENTBELT.show() >= 7)
      {
         this.FINAL_STAGE = 7;
         if(_root.CURRENTBELT.show() >= 7)
         {
            this.current_stage = 8;
         }
      }
      this.current_wait_time = 0;
      this.myscore = 0;
      this.current_move = 0;
      this.current_i = 0;
      this.in_play = false;
      this.on_offense = false;
      this.action = false;
      this.flashing = false;
      this.lasthold = false;
      this.usermove = false;
      this.correctmove = 13 + int(Math.random() * 13) + 1;
      this.assignSubmit();
      this.generateMoves();
      this.SPECITEM = int(Math.random() * 13) + 1;
      this.gstage = _root.attachMovie("GameStage","GS",50);
      var _loc3_ = 0;
      while(_loc3_ < 4)
      {
         this.gstage["Hand" + _loc3_].hand.gotoAndStop("static");
         _loc3_ = _loc3_ + 1;
      }
      this.scoreboard = this.gstage.attachMovie("Scoreboard","SB",200);
      this.prompt = this.gstage.attachMovie("Prompt","prompt",100);
      this.timer = this.gstage.createEmptyMovieClip("timer",1000);
      this.timer._visible = false;
      this.scoreboard.init(this,this.current_stage);
      trace("FINAL STAGE IS " + this.FINAL_STAGE);
   }
   function assignSubmit()
   {
      this.submitreq = new Array();
      this.submitreq[0] = 6;
      this.submitreq[1] = 18;
      this.submitreq[2] = 30;
      this.submitreq[3] = 45;
      this.submitreq[4] = 63;
      this.submitreq[5] = 90;
   }
   function makeHitSprite(pnum)
   {
      if(this.on_offense)
      {
         this.gstage.attachMovie("HitCounter","hc" + this.hccounter,70 + this.hccounter,{_x:650,_y:20}).init(pnum,true);
      }
      else
      {
         this.gstage.attachMovie("HitCounter","hc" + this.hccounter,70 + this.hccounter,{_x:650,_y:20}).init(pnum,false);
      }
      this.hccounter = (this.hccounter + 1) % 10;
   }
   function getSubmit()
   {
      return this.mysubmit / this.SPECITEM;
   }
   function unlockStage(pnum)
   {
      if(pnum == 1)
      {
         this.specitem1 = this.SPECITEM;
      }
      if(pnum == 2)
      {
         this.specitem2 = this.SPECITEM;
      }
      if(pnum == 3)
      {
         this.specitem3 = this.SPECITEM;
      }
   }
   function testMoves()
   {
      if(this.offense_array != undefined)
      {
         delete this.offense_array;
      }
      if(this.defence_array != undefined)
      {
         delete this.defence_array;
      }
      this.offense_array = new Array();
      this.defence_array = new Array();
      var _loc3_ = 0;
      var _loc2_;
      while(_loc3_ < this.TOTAL_STAGES)
      {
         this.offense_array[_loc3_] = new Array();
         this.defence_array[_loc3_] = new Array();
         this.offense_array[_loc3_][0] = new Array();
         this.defence_array[_loc3_][0] = new Array();
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            this.offense_array[_loc3_][0][_loc2_] = _loc2_ % 4;
            this.defence_array[_loc3_][0][_loc2_] = _loc2_ % 4;
            _loc2_ = _loc2_ + 1;
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function generateMoves()
   {
      var _loc8_ = 0;
      if(this.offense_array != undefined)
      {
         delete this.offense_array;
      }
      if(this.defence_array != undefined)
      {
         delete this.defence_array;
      }
      this.offense_array = new Array();
      this.defence_array = new Array();
      var _loc3_ = 0;
      var _loc2_;
      var _loc7_;
      var _loc4_;
      var _loc6_;
      var _loc5_;
      while(_loc3_ < this.TOTAL_STAGES)
      {
         trace("\nSTAGE " + (_loc3_ + 1));
         if(_loc3_ > 0)
         {
            _loc8_ = _loc3_ - 1;
         }
         else
         {
            _loc8_ = _loc3_;
         }
         this.offense_array[_loc3_] = new Array();
         this.defence_array[_loc3_] = new Array();
         _loc2_ = 0;
         while(_loc2_ < this.TOTAL_STAGES)
         {
            this.offense_array[_loc3_][_loc2_] = new Array();
            this.defence_array[_loc3_][_loc2_] = new Array();
            _loc2_ >= _loc8_ ? (_loc7_ = _loc8_ + 1) : (_loc7_ = _loc2_ + 1);
            _loc4_ = 0;
            while(_loc4_ < _loc7_)
            {
               if(_loc4_ == 0)
               {
                  this.offense_array[_loc3_][_loc2_][_loc4_] = int(Math.random() * 4);
                  this.defence_array[_loc3_][_loc2_][_loc4_] = int(Math.random() * 4);
               }
               else
               {
                  this.offense_array[_loc3_][_loc2_][_loc4_] = (this.offense_array[_loc3_][_loc2_][_loc4_ - 1] + int(Math.random() * 2) + 1) % 4;
                  this.defence_array[_loc3_][_loc2_][_loc4_] = (this.defence_array[_loc3_][_loc2_][_loc4_ - 1] + int(Math.random() * 2) + 1) % 4;
               }
               if(_loc2_ > 0)
               {
                  if(this.offense_array[_loc3_][_loc2_ - 1][_loc4_] != undefined)
                  {
                     _loc6_ = this.offense_array[_loc3_][_loc2_][_loc4_];
                     _loc5_ = this.offense_array[_loc3_][_loc2_ - 1][_loc4_];
                     if(_loc6_ == _loc5_)
                     {
                        this.offense_array[_loc3_][_loc2_][_loc4_] = (this.offense_array[_loc3_][_loc2_][_loc4_] + 1) % 4;
                     }
                  }
                  if(this.defence_array[_loc3_][_loc2_ - 1][_loc4_] != undefined)
                  {
                     _loc6_ = this.defence_array[_loc3_][_loc2_][_loc4_];
                     _loc5_ = this.defence_array[_loc3_][_loc2_ - 1][_loc4_];
                     if(_loc6_ == _loc5_)
                     {
                        this.defence_array[_loc3_][_loc2_][_loc4_] = (this.defence_array[_loc3_][_loc2_][_loc4_] + 1) % 4;
                     }
                  }
               }
               _loc4_ = _loc4_ + 1;
            }
            trace(this.offense_array[_loc3_][_loc2_]);
            trace(this.defence_array[_loc3_][_loc2_]);
            _loc2_ = _loc2_ + 1;
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function regenMoves(pstage)
   {
      trace("\n/////// REGENERATING MOVES ///////");
      var _loc8_ = 0;
      var _loc4_ = pstage - 1;
      if(_loc4_ > 0)
      {
         _loc8_ = _loc4_ - 1;
      }
      else
      {
         _loc8_ = _loc4_;
      }
      var _loc3_ = 0;
      var _loc7_;
      var _loc2_;
      var _loc6_;
      var _loc5_;
      while(_loc3_ < this.TOTAL_STAGES)
      {
         _loc3_ >= _loc8_ ? (_loc7_ = _loc8_ + 1) : (_loc7_ = _loc3_ + 1);
         _loc2_ = 0;
         while(_loc2_ < _loc7_)
         {
            if(_loc2_ == 0)
            {
               this.offense_array[_loc4_][_loc3_][_loc2_] = int(Math.random() * 4);
               this.defence_array[_loc4_][_loc3_][_loc2_] = int(Math.random() * 4);
            }
            else
            {
               this.offense_array[_loc4_][_loc3_][_loc2_] = (this.offense_array[_loc4_][_loc3_][_loc2_ - 1] + int(Math.random() * 2) + 1) % 4;
               this.defence_array[_loc4_][_loc3_][_loc2_] = (this.defence_array[_loc4_][_loc3_][_loc2_ - 1] + int(Math.random() * 2) + 1) % 4;
            }
            if(_loc3_ > 0)
            {
               if(this.offense_array[_loc4_][_loc3_ - 1][_loc2_] != undefined)
               {
                  _loc6_ = this.offense_array[_loc4_][_loc3_][_loc2_];
                  _loc5_ = this.offense_array[_loc4_][_loc3_ - 1][_loc2_];
                  if(_loc6_ == _loc5_)
                  {
                     this.offense_array[_loc4_][_loc3_][_loc2_] = (this.offense_array[_loc4_][_loc3_][_loc2_] + 1) % 4;
                  }
               }
               if(this.defence_array[_loc4_][_loc3_ - 1][_loc2_] != undefined)
               {
                  _loc6_ = this.defence_array[_loc4_][_loc3_][_loc2_];
                  _loc5_ = this.defence_array[_loc4_][_loc3_ - 1][_loc2_];
                  if(_loc6_ == _loc5_)
                  {
                     this.defence_array[_loc4_][_loc3_][_loc2_] = (this.defence_array[_loc4_][_loc3_][_loc2_] + 1) % 4;
                  }
               }
            }
            _loc2_ = _loc2_ + 1;
         }
         _loc3_ = _loc3_ + 1;
      }
      trace("DONE\n");
   }
   function startTimerFunction(ptime)
   {
      this.timer.startTime = -1;
      this.timer.currTime = 0;
      this.timer.waittime = ptime;
      this.timer.reactiontime = 0;
      this.timer.ptr = this;
      this.timer.onEnterFrame = function()
      {
         if(this.startTime >= 0)
         {
            if(this.startTime == 0)
            {
               this.startTime = getTimer();
               this.reactiontime = 0;
            }
            else
            {
               !this.ptr.flashing ? (this.currTime = getTimer() + this.waittime) : (this.currTime = getTimer());
               this.reactiontime = this.currTime - this.startTime;
               if(this.reactiontime >= this.waittime)
               {
                  this.reactiontime = this.waittime;
                  if(!this.ptr.action)
                  {
                     this.ptr.playLED();
                     this.startTime = 0;
                  }
                  else if(this.startTime >= 0)
                  {
                     this.startTime = -1;
                  }
               }
            }
         }
         if(this.ptr.lasthold && !this.ptr.action)
         {
            this.ptr.lasthold = false;
            this.ptr.nextSequence();
         }
      };
   }
   function getCurrentWaitTime()
   {
      return this.timer.waittime;
   }
   function proceedTimerFunction()
   {
      this.timer.startTime = 0;
      this.action = false;
   }
   function stopTimerFunction()
   {
      this.timer.onEnterFrame = undefined;
   }
   function nextSequence()
   {
      if(this.current_i == this.curr_move_length)
      {
         this.current_i = 0;
         if(this.current_move < this.curr_sequence_length - 1)
         {
            this.current_move = this.current_move + 1;
         }
         else
         {
            this.current_move = 0;
            this.stopTimerFunction();
            this.in_play = false;
            if(!this.on_offense)
            {
               this.on_offense = true;
               trace("ON OFFENSE!!");
               this.prompt.gotoAndStop("offense");
            }
            else
            {
               this.on_offense = false;
               trace("STAGE " + this.current_stage + " ENDS!!! (" + this.FINAL_STAGE + ")");
               if(this.current_stage < this.FINAL_STAGE)
               {
                  this.scoreboard.consolidateHits(false);
               }
               else if(this.current_stage == 7 && this.specitem1 == this.SPECITEM)
               {
                  this.scoreboard.consolidateHits(false);
               }
               else if(this.current_stage == 8 && this.specitem2 == this.SPECITEM)
               {
                  this.scoreboard.consolidateHits(false);
               }
               else if(this.current_stage == 9 && this.specitem3 == this.SPECITEM)
               {
                  this.scoreboard.consolidateHits(false);
               }
               else
               {
                  this.scoreboard.consolidateHits(true);
               }
               this.prompt.gotoAndStop("stage");
            }
            this.prompt.activate();
         }
      }
   }
   function playLED()
   {
      var _loc2_;
      if(!this.on_offense)
      {
         _loc2_ = this.defence_array;
      }
      else
      {
         _loc2_ = this.offense_array;
      }
      if(!this.action)
      {
         if(this.flashing)
         {
            this.gstage["led" + _loc2_[this.current_stage - 1][this.current_move][this.current_i - 1]].gotoAndStop("turnoff");
            this.flashing = false;
            this.action = true;
            if(this.userdir == this.correctmove)
            {
               this.playAction(this.currdir);
            }
            else if(this.userdir < 0)
            {
               this.playAction(this.currdir);
            }
            else
            {
               !this.on_offense ? this.playAction(this.currdir) : this.playAction(this.userdir);
            }
         }
         else
         {
            if(_loc2_[this.current_stage - 1][this.current_move][this.current_i] != undefined)
            {
               this.flashing = true;
               this.gstage["led" + _loc2_[this.current_stage - 1][this.current_move][this.current_i]].gotoAndStop("turnon");
               this.usermove = false;
            }
            if(this.current_i == _loc2_[this.current_stage - 1][this.current_move].length)
            {
               if(!this.lasthold)
               {
                  this.lasthold = true;
               }
            }
            else
            {
               this.current_i = this.current_i + 1;
               this.curr_move_length = _loc2_[this.current_stage - 1][this.current_move].length;
               this.curr_sequence_length = _loc2_[this.current_stage - 1].length;
               this.currdir = _loc2_[this.current_stage - 1][this.current_move][this.current_i - 1];
               this.userdir = -1;
            }
         }
      }
   }
   function playAction(phand)
   {
      if(this.action)
      {
         this.gstage["Hand" + phand].hand.gotoAndPlay("action");
      }
   }
   function playPunchSound(ptype)
   {
      var _loc2_ = int(Math.random() * 3);
      if(ptype)
      {
         _root.SC.playSound("player_punch" + _loc2_);
      }
      else
      {
         _root.SC.playSound("dummy_punch" + _loc2_);
      }
   }
   function playBlockSound(ptype)
   {
      if(ptype)
      {
         _root.SC.playSound("playerblock");
      }
      else
      {
         _root.SC.playSound("dummyblock");
      }
   }
   function punchDummy()
   {
      if(this.on_offense)
      {
         if(this.userdir == this.correctmove)
         {
            this.scoreboard.compileHits(true,this.timer.reactiontime);
            this.dummy.punched(this.currdir);
            this.playPunchSound(false);
         }
         else
         {
            this.scoreboard.compileHits(false,this.current_wait_time);
            if(this.userdir < 4 && this.userdir >= 0)
            {
               this.dummy.blocked(this.userdir);
            }
            else
            {
               this.dummy.blocked(this.currdir);
            }
            this.playBlockSound(false);
         }
      }
      else if(this.userdir == this.correctmove)
      {
         this.scoreboard.compileHits(true,this.timer.reactiontime);
         this.dummy.blocked(this.currdir);
         this.playBlockSound(true);
      }
      else
      {
         this.scoreboard.compileHits(false,this.current_wait_time);
         this.dummy.punched(this.currdir);
         this.playPunchSound(true);
      }
      this.no_moves = this.no_moves + 1;
   }
   function doneAnimation()
   {
      this.proceedTimerFunction();
   }
   function spaceReady()
   {
      _root.KC.enableCheckAnyKey(this,"proceedGame");
      this.allowspace = true;
   }
   function proceedGame()
   {
      var _loc4_;
      var _loc3_;
      var _loc5_;
      var _loc6_;
      if(!this.in_play && this.allowspace)
      {
         _root.KC.disableCheckAnyKey();
         this.allowspace = false;
         this.in_play = true;
         this.scoreboard.resetConsec();
         if(this.dummy != undefined)
         {
            this.dummy.destructor();
         }
         if(!this.on_offense)
         {
            if(!this.firstcheck)
            {
               trace("MOVES DONE: " + this.no_moves);
               if(this.scoreboard.ifPassed())
               {
                  trace("STAGE " + this.current_stage + " PASSED");
                  this.current_stage = this.current_stage + 1;
                  this.scoreboard.upgradeBelt();
               }
               else
               {
                  trace("STAGE " + this.current_stage + " FAILED");
                  this.regenMoves(this.current_stage);
                  if(this.current_stage <= 0)
                  {
                     this.current_stage = 1;
                  }
               }
            }
            else
            {
               this.firstcheck = false;
            }
            this.scoreboard.resetHits();
            trace("\nSTAGE " + this.current_stage);
            if(this.current_stage > this.FINAL_STAGE)
            {
               _loc4_ = true;
               if(this.FINAL_STAGE >= 7)
               {
                  if(this.current_stage == this.FINAL_STAGE + 1)
                  {
                     if(this.specitem1 == this.SPECITEM)
                     {
                        this.robot_choice = int(Math.random() * 3);
                        _loc4_ = false;
                     }
                  }
                  else if(this.current_stage == this.FINAL_STAGE + 2)
                  {
                     if(this.specitem1 == this.SPECITEM && this.specitem2 == this.SPECITEM)
                     {
                        _loc4_ = false;
                     }
                  }
                  else if(this.current_stage == this.FINAL_STAGE + 3)
                  {
                     if(this.specitem1 == this.SPECITEM && this.specitem2 == this.SPECITEM && this.specitem3 == this.SPECITEM)
                     {
                        _loc4_ = false;
                     }
                  }
               }
               if(_loc4_)
               {
                  _root.endGame();
               }
            }
            this.no_moves = 0;
            this.dummy = this.gstage.dummy.attachMovie("Player","dummy_sprite",10);
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               if(this.current_stage <= 7)
               {
                  this.gstage["Hand" + _loc3_].gotoAndStop("dummy" + this.current_stage);
               }
               else if(this.current_stage == 8)
               {
                  this.gstage["Hand" + _loc3_].gotoAndStop("dummy" + (8 + this.robot_choice));
               }
               else
               {
                  this.gstage["Hand" + _loc3_].gotoAndStop("dummy" + (this.current_stage + 2));
               }
               this.gstage["Hand" + _loc3_].hand.gotoAndStop("static");
               _loc3_ = _loc3_ + 1;
            }
         }
         else
         {
            if(this.current_stage <= 7)
            {
               this.dummy = this.gstage.dummy.attachMovie("Dummy_Type_" + (this.current_stage - 1),"dummy_sprite",10);
            }
            else
            {
               _loc5_ = 0;
               if(this.current_stage == 8)
               {
                  _loc5_ = 7 + this.robot_choice;
               }
               else
               {
                  _loc5_ = this.current_stage + 1;
               }
               this.dummy = this.gstage.dummy.attachMovie("Dummy_Type_" + _loc5_,"dummy_sprite",10);
            }
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               this.gstage["Hand" + _loc3_].gotoAndStop("player");
               this.gstage["Hand" + _loc3_].hand.gotoAndStop("static");
               _loc3_ = _loc3_ + 1;
            }
         }
         this.dummy.pointBack(this);
         _loc6_ = (this.MAX_WAIT_TIME - this.MIN_WAIT_TIME) / this.TOTAL_STAGES;
         this.current_wait_time = int(this.MAX_WAIT_TIME - _loc6_ * (this.current_stage - 1));
         this.prompt.deactivate();
         this.dummy.gotoAndPlay("ready");
      }
   }
   function startStage()
   {
      this.startTimerFunction(this.current_wait_time);
      this.proceedTimerFunction();
   }
   function checkInput(puserdir)
   {
      if(this.flashing && !this.usermove)
      {
         this.usermove = true;
         this.timer.startTime = -1;
         if(puserdir == this.currdir)
         {
            this.userdir = this.correctmove;
         }
         else
         {
            this.userdir = puserdir;
         }
         this.playLED();
      }
   }
   function upLeft()
   {
      this.checkInput(0);
   }
   function upRight()
   {
      this.checkInput(1);
   }
   function downLeft()
   {
      this.checkInput(2);
   }
   function downRight()
   {
      this.checkInput(3);
   }
   function destructor()
   {
      this.prompt.destructor();
      this.scoreboard.destructor();
      this.dummy.destructor();
      this.timer.removeMovieClip();
      this.gstage.removeMovieClip();
   }
}
