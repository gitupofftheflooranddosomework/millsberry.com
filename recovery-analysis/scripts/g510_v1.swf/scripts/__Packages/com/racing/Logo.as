class com.racing.Logo extends MovieClip
{
   static var __inst;
   static var coords = {home:[450,85,85],drivers:[330,60,55],tracks:[330,60,55],results:[330,60,55]};
   function Logo()
   {
      super();
      com.racing.Logo.__inst = this;
      this._x = Stage.width + 500;
      com.racing.Logo.hide();
   }
   static function update(ste, d)
   {
      var _loc1_ = d;
      var _loc2_ = com.racing.Logo.coords[ste][2];
      var _loc4_ = com.racing.Logo.coords[ste][0];
      var _loc3_ = com.racing.Logo.coords[ste][1];
      gs.TweenMax.to(com.racing.Logo.__inst,0.4,{_xscale:_loc2_,_yscale:_loc2_,ease:gs.easing.Cubic.easeInOut,delay:_loc1_ + 0.1});
      gs.TweenMax.to(com.racing.Logo.__inst,0.4,{_x:_loc4_,_y:_loc3_,ease:gs.easing.Back.easeInOut,delay:_loc1_});
   }
   static function hide()
   {
      gs.TweenMax.to(com.racing.Logo.__inst,0.5,{_x:Stage.width + 500,ease:gs.easing.Back.easeInOut});
   }
}
