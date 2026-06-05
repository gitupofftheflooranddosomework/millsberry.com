class classes.Dummy extends MovieClip
{
   var game_ptr;
   function Dummy()
   {
      super();
   }
   function pointBack(pptr)
   {
      this.game_ptr = pptr;
   }
   function resume()
   {
      this.gotoAndStop("static");
      _root.game.doneAnimation();
   }
   function readyToFight()
   {
      this.gotoAndStop("static");
      this.game_ptr.startStage();
   }
   function punched(pdir)
   {
      if(pdir == 0)
      {
         this.gotoAndStop("beatLU");
      }
      else if(pdir == 1)
      {
         this.gotoAndStop("beatRU");
      }
      else if(pdir == 2)
      {
         this.gotoAndStop("beatLD");
      }
      else if(pdir == 3)
      {
         this.gotoAndStop("beatRD");
      }
   }
   function blocked(pdir)
   {
      if(pdir == 0)
      {
         this.gotoAndStop("blockLU");
      }
      else if(pdir == 1)
      {
         this.gotoAndStop("blockRU");
      }
      else if(pdir == 2)
      {
         this.gotoAndStop("blockLD");
      }
      else if(pdir == 3)
      {
         this.gotoAndStop("blockRD");
      }
   }
   function destructor()
   {
      this.removeMovieClip();
   }
}
