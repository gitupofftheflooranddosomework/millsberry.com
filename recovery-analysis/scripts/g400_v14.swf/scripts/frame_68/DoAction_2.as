trace("RESTITUYE GAME");
var game = new classes.Game();
var stageratio = 0;
var stagecount = 0;
var stageresponse = 0;
var stagescore = 0;
var stageres = false;
if(KC != undefined)
{
   trace("Killing keycontroller");
   KC.destroy();
   delete KC;
}
var KC = new classes.KeyController(-1);
KC.addKey("NumLU",_root.assignedkeys[0]);
KC.addKey("NumRU",_root.assignedkeys[1]);
KC.addKey("NumLD",_root.assignedkeys[2]);
KC.addKey("NumRD",_root.assignedkeys[3]);
KC.registerFunc("NumLU",game,"upLeft");
KC.registerFunc("NumRU",game,"upRight");
KC.registerFunc("NumLD",game,"downLeft");
KC.registerFunc("NumRD",game,"downRight");
var i = 1;
while(i < 4)
{
   if(_root["UNLOCKSPECIAL" + i].show() == 1)
   {
      game.unlockStage(i);
   }
   i++;
}
