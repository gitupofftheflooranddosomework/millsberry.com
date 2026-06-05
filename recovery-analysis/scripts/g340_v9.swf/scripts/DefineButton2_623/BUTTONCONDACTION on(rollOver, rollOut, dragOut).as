on(rollOver, rollOut, dragOut){
   if(this.autoScroll == "on")
   {
      _root.subpanel.gotoAndPlay("still");
      this.autoScroll = "off";
   }
   tellTarget("roll")
   {
      gotoAndPlay(_totalframes - _currentframe);
   }
}
