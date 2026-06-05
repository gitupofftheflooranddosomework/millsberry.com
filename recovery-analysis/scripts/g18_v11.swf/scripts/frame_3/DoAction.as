_global.MillsberryEvar = function(value)
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
MillsberryEvar.prototype.changeTo = function(value)
{
   this.value = value;
   return this.value;
};
_global.gMyScoringSystem = new Object();
gMyScoringSystem.Evar = MillsberryEvar;
gMyScoringSystem.reset = function()
{
};
gMyScoringSystem.setScore = function(value)
{
   this.score = value;
};
gMyScoringSystem.submitScore = function()
{
};
_global.gMyGMIStatus = new Object();
gMyGMIStatus.sendTrack = function()
{
};
Function.prototype.extend = function(superClass)
{
   var _loc1_ = this;
   _loc1_.prototype.__proto__ = superClass.prototype;
   _loc1_.prototype.__constructor__ = superClass;
   ASSetPropFlags(_loc1_.prototype,["__constructor__"],1);
};
ASSetPropFlags(Function.prototype,["extend"],1);
MovieClip.prototype.mcExtends = function(superClass)
{
   var _loc3_ = superClass;
   var _loc2_;
   var _loc1_;
   if(typeof _loc3_ == "function")
   {
      this.__proto__ = _loc3_.prototype;
      if(typeof this.attachMovie == "undefined")
      {
         _loc2_ = this.__proto__;
         _loc1_ = _loc2_.__proto__.__proto__;
         while(_loc1_ != null)
         {
            _loc1_ = _loc1_.__proto__;
            _loc2_ = _loc2_.__proto__;
         }
         _loc2_.__proto__ = MovieClip.prototype;
      }
      arguments.splice(0,1);
      _loc3_.apply(this,arguments);
   }
};
ASSetPropFlags(MovieClip.prototype,["mcExtends"],1);
