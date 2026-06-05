function setDirection()
{
   MC_Compass_Arrowanim.stop();
   gotoAndStop("compass_power_on");
   angle = Math.round(MC_Compass_Arrowanim.MC_compass_arrow._rotation);
}
stop();
MC_Compass_Arrowanim.play();
var angle;
Btn_compass.onPress = setDirection;
