class classes.HitCounter extends MovieClip
{
   var final_x;
   var hit1_txt;
   var hit2_txt;
   var hit_shadow_txt;
   var hit_txt;
   var init_x;
   var mybonus;
   function HitCounter()
   {
      super();
      this.init_x = this._x;
      this.final_x = this.init_x - 400;
      this._alpha = 100;
   }
   function init(phit, ptype)
   {
      this.mybonus = phit;
      this.hit_txt = this.mybonus + 1;
      this.hit_shadow_txt = this.mybonus + 1;
      var _loc3_;
      !ptype ? (_loc3_ = _level0.IDS_block_txt) : (_loc3_ = _level0.IDS_hit_txt);
      _root.CR.addContent(this.hit1_txt,"hit1",_loc3_);
      _root.CR.addContent(this.hit2_txt,"hit2",_loc3_);
      _root.CR.flushRegister();
   }
   function onEnterFrame()
   {
      this._x += this.final_x - this._x >> 1;
      if(this._x <= this.final_x + 10)
      {
         if(this._alpha > 0)
         {
            this._alpha -= 10;
         }
         else
         {
            this.destructor();
         }
      }
   }
   function destructor()
   {
      this.removeMovieClip();
   }
}
