function setPower()
{
   MC_compass_powermeter.stop();
   power = Math.round(MC_compass_powermeter.powerCircle._xscale);
   _parent.setCompassTarget(angle,power);
}
MC_compass_powermeter._rotation = angle;
var power;
Btn_compass.onPress = setPower;
