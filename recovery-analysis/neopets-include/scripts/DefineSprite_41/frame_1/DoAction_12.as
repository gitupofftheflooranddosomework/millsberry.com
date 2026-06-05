function evar(value, name, comment)
{
   var _loc1_ = this;
   _loc1_.getHelp = function()
   {
      var _loc1_ = "";
      _loc1_ += "EVAR.getHelp()\n";
      _loc1_ += "------------------------\n";
      _loc1_ += "CONSTRUCTOR\n";
      _loc1_ += "\tmyEvar = new Evar(value,[nameString,comment])\n";
      _loc1_ += "PUBLIC METHODS\n";
      _loc1_ += "\tgetHelp()\n";
      _loc1_ += "\tchangeBy(amount); //change the value\n";
      _loc1_ += "\tchangeTo(value);  //change the value\n";
      _loc1_ += "\tshow();           //returns the value\n";
      return _loc1_;
   };
   _loc1_.evName = name;
   _loc1_.evComment = comment;
   _loc1_.objEvar = new np.projects.include.EvarClass(value,_loc1_.evName);
   includeTracer.trace("EVAR " + _loc1_.evName + " created: value = " + _loc1_.objEvar.show());
   _loc1_.changeBy = function(val)
   {
      this.objEvar.changeBy(val);
   };
   _loc1_.changeTo = function(val)
   {
      this.objEvar.changeTo(val);
   };
   _loc1_.show = function()
   {
      return this.objEvar.show();
   };
}
