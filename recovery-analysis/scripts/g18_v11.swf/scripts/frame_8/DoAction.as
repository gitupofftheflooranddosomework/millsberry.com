if(useDictionary)
{
   p = int(_root.myDictionary.getPercentLoaded());
   var output = "<p align = \'center\'><font size = \'12\' color = \'#ffffff\'>" + p + _level0.ttext_loadingthedictionary + "</p></font>";
   if(p < 100 or p == undefined)
   {
      _root.gotoAndPlay(_root._currentframe - 1);
   }
}
else
{
   this.play();
}
