if(useDictionary)
{
   p = int(_root.myDictionary.getPercentLoaded());
   var output = "<p align = \'center\'><font size = \'18\' color = \'#ffffff\'>" + _level0.IDS_loadingthedictionary + " " + p + "%</p></font>";
   if(p < 100 or p == undefined)
   {
      _root.gotoAndPlay(_root._currentframe - 1);
   }
}
else
{
   this.play();
}
