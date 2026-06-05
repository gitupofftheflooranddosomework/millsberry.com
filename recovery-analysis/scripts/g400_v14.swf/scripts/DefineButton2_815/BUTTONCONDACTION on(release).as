on(release){
   if(_root.enable_controls_buttons)
   {
      _root.resetKeys();
      var i = 0;
      while(i < _root.assignedkeys.length)
      {
         _root.CR.changeContent("assignedkey" + i,_level0.IDS_key_opener + _root.keyname[i] + _level0.IDS_key_closer);
         i++;
      }
      _root.buttonSound();
   }
}
