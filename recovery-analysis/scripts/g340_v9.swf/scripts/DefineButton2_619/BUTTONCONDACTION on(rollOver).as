on(rollOver){
   _root.rollBtnSm();
   tellTarget("roll")
   {
      gotoAndPlay(_totalframes - _currentframe);
   }
}
