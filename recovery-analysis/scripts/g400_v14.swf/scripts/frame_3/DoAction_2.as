var MillsberryEvar = function(value)
{
   this.value = value;
};
MillsberryEvar.prototype.show = function()
{
   return this.value;
};
MillsberryEvar.prototype.changeBy = function(amount)
{
   this.value += amount;
   return this.value;
};
var ScoringSystem = new Object();
ScoringSystem.Evar = MillsberryEvar;
ScoringSystem.reset = function()
{
};
ScoringSystem.submitScore = function(value)
{
   this.score = value;
};
_MB8_GAME_DATA = _root._MB8_GAME_DATA;
if(_MB8_GAME_DATA == undefined)
{
   _MB8_GAME_DATA = {bDictionary:false,bMeterVisible:false,objAddVars:{}};
}
