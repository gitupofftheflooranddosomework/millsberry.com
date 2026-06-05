function buttonSound()
{
   SC.playSound("click");
}
function resetKeys()
{
   _root.assignedkeys[0] = _root.KEY_UPPER_LEFT;
   _root.assignedkeys[1] = _root.KEY_UPPER_RIGHT;
   _root.assignedkeys[2] = _root.KEY_LOWER_LEFT;
   _root.assignedkeys[3] = _root.KEY_LOWER_RIGHT;
   _root.keyname[0] = _root.KEYNAME_UPPER_LEFT;
   _root.keyname[1] = _root.KEYNAME_UPPER_RIGHT;
   _root.keyname[2] = _root.KEYNAME_LOWER_LEFT;
   _root.keyname[3] = _root.KEYNAME_LOWER_RIGHT;
}
var SC = new classes.SoundController(["click","error","playerblock","dummyblock","dummy_punch0","dummy_punch1","dummy_punch2","player_punch0","player_punch1","player_punch2"]);
var KEY_UPPER_LEFT = 103;
var KEY_UPPER_RIGHT = 105;
var KEY_LOWER_LEFT = 97;
var KEY_LOWER_RIGHT = 99;
var KEYNAME_UPPER_LEFT = "7";
var KEYNAME_UPPER_RIGHT = "9";
var KEYNAME_LOWER_LEFT = "1";
var KEYNAME_LOWER_RIGHT = "3";
if(assignedkeys == undefined)
{
   var assignedkeys = new Array();
   var keyname = new Array();
   resetKeys();
}
_root.unlock1 = true;
_root.unlock2 = false;
_root.unlock3 = false;
var CURRENTBELT = new ScoringSystem.Evar(0,"","");
var POINTSNEEDED = new ScoringSystem.Evar(0,"","");
var POSTSNEEDED = new ScoringSystem.Evar(0,"","");
var dataLoader = new LoadVars();
dataLoader.onLoad = function(success)
{
   if(success)
   {
      _level0.VAR_currbelt = this.cur_level;
      _level0.VAR_points_needed = this.points_needed;
      _level0.VAR_posts_needed = this.num_posts;
      _root.CURRENTBELT.changeBy(_level0.VAR_currbelt);
      _root.POINTSNEEDED.changeBy(_level0.VAR_points_needed);
      _root.POSTSNEEDED.changeBy(_level0.VAR_posts_needed);
      trace("Data Loaded");
      trace("CURRENTBELT = " + _root.CURRENTBELT.show());
      trace("POINTSNEEDED = " + _root.POINTSNEEDED.show());
      trace("POSTSNEEDED = " + _root.POSTSNEEDED.show());
      _root.gotoAndPlay("resetAllFrame");
   }
};
dataLoader.load("/communitycenter/dojo/sensei_vars.phtml?uniqsid=" + int(Math.random() * 10000));
var UNLOCKSPECIAL1 = new ScoringSystem.Evar(0,"","");
var UNLOCKSPECIAL2 = new ScoringSystem.Evar(0,"","");
var UNLOCKSPECIAL3 = new ScoringSystem.Evar(0,"","");
var i = 1;
while(i < 4)
{
   if(_root["unlock" + i] == undefined || !_root["unlock" + i])
   {
      _root["UNLOCKSPECIAL" + i].changeBy(0);
   }
   else
   {
      _root["UNLOCKSPECIAL" + i].changeBy(1);
   }
   i++;
}
stop();
