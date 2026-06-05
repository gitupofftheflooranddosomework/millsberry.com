on(rollOut, dragOut){
   tellTarget("roll")
   {
      if(_currentframe < _totalframes / 2)
      {
         gotoAndPlay(_totalframes - _currentframe);
      }
   }
}
