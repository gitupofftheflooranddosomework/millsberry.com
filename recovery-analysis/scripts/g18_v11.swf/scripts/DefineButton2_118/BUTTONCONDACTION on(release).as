on(release){
   gameOver = true;
   if(_root.ball._y <= 30)
   {
      _root.gotoAndPlay("gameoverframe");
   }
}
