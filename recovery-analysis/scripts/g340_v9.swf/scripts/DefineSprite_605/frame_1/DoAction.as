this.updateName = function(name)
{
   var _loc3_ = _root.selectedChar;
   this.tCharText = "<P ALIGN=\'CENTER\'>" + name + "</P>";
};
this.updateAttributes = function()
{
   _root.buttonClick.start();
   var _loc3_ = _root.selectedChar;
   this.updateName(_loc3_.name);
   this.oMeter._xscale = _loc3_.offense * 10;
   this.dMeter._xscale = _loc3_.defense * 10;
   this.sMeter._xscale = _loc3_.speed * 10;
   var _loc4_ = _loc3_.linkage;
   this.showChar.gotoAndStop(_loc4_);
   this.tBio.scroll = 0;
   this.tBio.htmlText = "<P ALIGN=\'LEFT\'>" + _loc3_.bio + "</P>";
};
this.highlightRollovers = function(ref)
{
   var _loc2_ = 1;
   var _loc3_;
   while(_loc2_ < 4)
   {
      _loc3_ = this["char" + _loc2_];
      if(_loc3_ != ref)
      {
         _loc3_._alpha = 40;
      }
      _loc2_ = _loc2_ + 1;
   }
   ref._alpha = 100;
};
this.updateAttributes();
this.highlightRollovers(this.char1);
