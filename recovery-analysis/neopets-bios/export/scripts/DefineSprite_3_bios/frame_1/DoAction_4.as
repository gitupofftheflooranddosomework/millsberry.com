this.copyInProps = function()
{
   var _loc2_ = this;
   var _loc3_ = _root;
   trace("copyInProps");
   var _loc1_;
   if(_level10.getBytesTotal() > 0)
   {
      _loc1_ = 10;
   }
   else
   {
      _loc1_ = 0;
   }
   trace("for level " + _loc1_);
   for(var prop in _loc3_["_level" + _loc1_].BIOS)
   {
      _loc2_[prop] = _loc3_["_level" + _loc1_].BIOS[prop];
      trace("COPIED: " + prop + " = " + _loc2_[prop]);
   }
};
this.getIncludePercentLoaded = function()
{
   var _loc1_ = int(_level100.getBytesLoaded() / _level100.getBytesTotal() * 100);
   return _loc1_;
};
this.waitforInclude = function()
{
   var _loc2_ = this;
   var _loc1_ = getIncludePercentLoaded();
   if(_loc1_ < 100)
   {
      trace("BIOS:  ???????Include " + _loc1_ + "% Loaded // debug = " + _loc2_.debug);
   }
   else
   {
      trace("BIOS:  Include " + _loc1_ + "% Loaded // debug = " + _loc2_.debug);
      _loc2_.onEnterFrame = undefined;
      _loc2_.postLoading();
   }
};
this.postLoading = function()
{
   var _loc3_ = _root;
   _loc3_.resetall = function()
   {
      _level100.include.reset();
   };
   _level100.include.game_level = 0;
   _loc3_.resetvar = _level100.include.resetvar;
   _loc3_.evar = _level100.include.evar;
   _level0.resetvar = _level100.include.resetvar;
   _level0.evar = _level100.include.evar;
   var _loc2_ = centerx / _width * _level0._width;
   var _loc1_ = centery / _height * _level0._height;
   _level100.include._x = _loc2_;
   _level100.include._y = _loc1_;
   _level100.include._width = _level0._width * (meterwidthratio / 100);
   _level100.include._height = _level0._height * (meterheightratio / 100);
   _level100.include.scoresentframe = scoresentframe;
   _level100.include.debug = debug;
   _level100.include.offline = debug;
   _level100.include.minscorevalue = minscorevalue;
   _level100.include.metervisible = metervisible;
   if(custommetercolors == 1 or custommetertext == 1)
   {
      _level100.include.customizedmeter = new Object();
      if(custommetercolors == 1)
      {
         _level100.include.customizedmeter.color = new Object();
         _level100.include.customizedmeter.color.background = background;
         _level100.include.customizedmeter.color.text1 = text1;
         _level100.include.customizedmeter.color.text2 = text2;
         _level100.include.customizedmeter.color.text3 = text3;
         _level100.include.customizedmeter.color.meter = meter;
         _level100.include.customizedmeter.color.marks = marks;
      }
      if(custommetertext == 1)
      {
         _level100.include.customizedmeter.text = new Object();
         _level100.include.customizedmeter.text.scoremessage = scoremessage;
         _level100.include.customizedmeter.text.successmessage = successmessage;
         _level100.include.customizedmeter.text.replaybuttonmessage = replaybuttonmessage;
      }
   }
   this.onEnterFrame = startTransitionToFinish;
};
