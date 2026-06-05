this.waitForPreTranslation = function()
{
   if(_level100.include.preloaderTranslationSuccess)
   {
      this.loadLocalGameTranslation();
   }
};
this.waitForTranslation = function()
{
   if(_level100.include.gameTranslationSuccess)
   {
      this.onEnterFrame = startTransitionToFinish;
   }
};
this.waitforInclude = function()
{
   var _loc2_ = _level100.getBytesLoaded();
   var _loc3_ = _level100.getBytesTotal();
   var _loc4_;
   if(!isNaN(_loc3_) && _loc3_ > 0 && (!isNaN(_loc2_) && _loc2_ > 0))
   {
      _loc4_ = int(_loc2_ / _loc3_ * 100);
      if(_loc4_ >= 100)
      {
         if(_level0.debug)
         {
            trace("Bios: Include " + _loc4_ + "% Loaded // debug = " + _level0.debug);
         }
         this.onEnterFrame = undefined;
         this.postLoading(true);
      }
   }
};
this.postLoading = function(bLocal)
{
   var _loc4_ = this;
   _root.resetall = function()
   {
      _level100.include.reset();
   };
   _level100.include.game_level = 0;
   _root.resetvar = _level100.include.resetvar;
   _root.evar = _level100.include.evar;
   _level0.resetvar = _level100.include.resetvar;
   _level0.evar = _level100.include.evar;
   var _loc5_ = false;
   if(newMeterX != undefined && newMeterY != undefined)
   {
      if(newMeterX != -1 && newMeterY != -1)
      {
         _loc5_ = true;
      }
   }
   var _loc6_;
   var _loc7_;
   var _loc8_;
   var _loc9_;
   var _loc10_;
   var _loc11_;
   if(_loc5_)
   {
      _level0.bMeterSet = true;
      if(!bLocal)
      {
         _loc6_ = _loc4_._parent._width / 10;
         _loc7_ = _loc4_._parent._height / 10;
         _level100.include._width = 300 / _loc6_ * 100;
         _level100.include._height = 120 / _loc7_ * 100;
         _loc8_ = newMeterX / _loc6_ * 100;
         _loc9_ = newMeterY / _loc7_ * 100;
         _level100.include._x = _loc8_ + _level100.include._width / 2;
         _level100.include._y = _loc9_ + _level100.include._height / 2;
      }
      else
      {
         _level100.include._x = newMeterX + _level100.include._width / 2;
         _level100.include._y = newMeterY + _level100.include._height / 2;
      }
   }
   else
   {
      _loc10_ = centerx / _loc4_._parent._width * _level0._width;
      _loc11_ = centery / _loc4_._parent._height * _level0._height;
      _level100.include._x = _loc10_;
      _level100.include._y = _loc11_;
      _level100.include._width = _level0._width * (meterwidthratio / 100);
      _level100.include._height = _level0._height * (meterheightratio / 100);
   }
   _level100.include.scoresentframe = scoresentframe;
   _level100.include.debug = debug;
   _level100.include.offline = debug;
   _level100.include.minscorevalue = minscorevalue;
   _level100.include.metervisible = metervisible;
   _level100.include.customizedmeter = new Object();
   if(custommetercolors == 1)
   {
      _level100.include.customizedmeter.color = new Object();
      _level100.include.customizedmeter.color.text1 = text1;
      _level100.include.customizedmeter.color.text2 = text2;
      _level100.include.customizedmeter.color.text3 = text3;
   }
   if(custommeterswf != "")
   {
      _level100.include.customizedmeter.swf = custommeterswf;
      _level100.include.initScoringMeter();
   }
   if(bLocal)
   {
      if(_loc4_._parent.translation == 1)
      {
         _level100.include.setTranslatorTextFieldTarget(_level0);
         _loc4_.loadLocalGameTranslation();
      }
      else
      {
         _loc4_.onEnterFrame = startTransitionToFinish;
      }
   }
   else
   {
      _level100.include.setTranslatorTextFieldTarget(_level10);
      _loc4_.onEnterFrame = startTransitionToFinish;
   }
};
this.loadLocalGameTranslation = function()
{
   var _loc2_ = this;
   if(_loc2_._parent.game_id != undefined && _loc2_._parent.game_lang != undefined && _loc2_._parent.game_id != -1 && _loc2_._parent.game_lang != -1)
   {
      if(_level100.include.game_id == undefined)
      {
         _level100.include.game_id = _loc2_._parent.game_id;
         _level100.include.game_lang = String(_loc2_._parent.game_lang);
      }
      _level100.include.newGameTranslation();
      _loc2_.onEnterFrame = _loc2_.waitForTranslation;
   }
   else
   {
      _loc2_.onEnterFrame = startTransitionToFinish;
   }
};
