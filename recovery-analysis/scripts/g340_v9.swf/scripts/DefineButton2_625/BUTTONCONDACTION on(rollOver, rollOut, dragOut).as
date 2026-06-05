on(rollOver, rollOut, dragOut){
   _root.rollBtnSm();
   tellTarget("roll")
   {
      gotoAndPlay(_totalframes - _currentframe);
   }
}
