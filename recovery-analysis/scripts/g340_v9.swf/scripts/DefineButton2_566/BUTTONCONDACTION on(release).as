on(release){
   _global.GMIStatus.sendTrack(1);
   _root.buttonClick.start();
   _root.selectedChar = gCharOne;
   _root.characterSelected = 1;
   _root.gotoAndPlay("gamestartframe");
}
