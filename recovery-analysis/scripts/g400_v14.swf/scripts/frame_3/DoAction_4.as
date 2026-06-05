fscommand("trapallkeys","true");
var sText = "\n";
sText += "Game Vars are stored in object _MB8_GAME_DATA\n";
sText += "Additional Vars are stored in object _MB8_GAME_DATA.objAddVars\n";
for(prop in _MB8_GAME_DATA)
{
   if(prop == "objAddVars")
   {
      sText += "> Additional Vars Start\n";
      for(prop in _MB8_GAME_DATA.objAddVars)
      {
         sText += "_MB8_GAME_DATA.objAddVars." + prop + " = " + _MB8_GAME_DATA.objAddVars[prop] + "\n";
      }
      sText += "> Additional Vars End\n";
   }
   else
   {
      sText += "_MB8_GAME_DATA." + prop + " = " + _MB8_GAME_DATA[prop] + "\n";
   }
}
trace(sText);
