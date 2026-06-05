class classes.Prompt extends MovieClip
{
   function Prompt()
   {
      super();
      this.gotoAndStop("startofgame");
   }
   function activate()
   {
      this._visible = true;
   }
   function deactivate()
   {
      this._visible = false;
   }
   function destructor()
   {
      this.removeMovieClip();
   }
}
