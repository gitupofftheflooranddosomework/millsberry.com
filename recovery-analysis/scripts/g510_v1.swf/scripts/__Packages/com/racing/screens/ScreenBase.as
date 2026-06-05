class com.racing.screens.ScreenBase extends MovieClip
{
   var dly;
   function ScreenBase()
   {
      super();
   }
   function onHideComplete(c)
   {
      c._xscale = c._yscale = 190;
   }
   function showItem(c, incr)
   {
      gs.TweenMax.to(c,0.6,{_xscale:100,_yscale:100,ease:gs.easing.Bounce.easeOut,delay:this.dly + 0.2});
      gs.TweenMax.to(c,0.6,{_x:c.X,_y:c.Y,ease:gs.easing.Cubic.easeOut,delay:this.dly});
      this.dly += incr;
   }
   function defineCoords(c)
   {
      c.X = c._x;
      c.Y = c._y;
   }
}
