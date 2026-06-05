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
   var _loc1_ = _level100.getBytesLoaded();
   var _loc2_ = _level100.getBytesTotal();
   var _loc3_;
   if(!isNaN(_loc2_) && _loc2_ > 0 && (!isNaN(_loc1_) && _loc1_ > 0))
   {
      _loc3_ = int(_loc1_ / _loc2_ * 100);
      if(_loc3_ >= 100)
      {
         if(_level0.debug)
         {
            trace("Bios: Include " + _loc3_ + "% Loaded // debug = " + _level0.debug);
         }
         this.onEnterFrame = undefined;
         this.postLoading(true);
      }
   }
};
this.postLoading = function(bLocal)
{
   var _loc1_ = this;
   _root.resetall = function()
   {
      _level100.include.reset();
   };
   _level100.include.game_level = 0;
   _root.resetvar = _level100.include.resetvar;
   _root.evar = _level100.include.evar;
   _level0.resetvar = _level100.include.resetvar;
   _level0.evar = _level100.include.evar;
   var bNewPosition = false;
   if(newMeterX != undefined && newMeterY != undefined)
   {
      if(newMeterX != -1 && newMeterY != -1)
      {
         bNewPosition = true;
      }
   }
   var _loc3_;
   var _loc2_;
   if(bNewPosition)
   {
      _level0.bMeterSet = true;
      if(!bLocal)
      {
         _loc3_ = _loc1_._parent._width / 10;
         _loc2_ = _loc1_._parent._height / 10;
         _level100.include._width = 300 / _loc3_ * 100;
         _level100.include._height = 120 / _loc2_ * 100;
         var newX = newMeterX / _loc3_ * 100;
         var newY = newMeterY / _loc2_ * 100;
         _level100.include._x = newX + _level100.include._width / 2;
         _level100.include._y = newY + _level100.include._height / 2;
      }
      else
      {
         _level100.include._x = newMeterX + _level100.include._width / 2;
         _level100.include._y = newMeterY + _level100.include._height / 2;
      }
   }
   else
   {
      var offsetx = centerx / _loc1_._parent._width * _level0._width;
      var offsety = centery / _loc1_._parent._height * _level0._height;
      _level100.include._x = offsetx;
      _level100.include._y = offsety;
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
      if(_loc1_._parent.translation == 1)
      {
         _level100.include.setTranslatorTextFieldTarget(_level0);
         _loc1_.loadLocalGameTranslation();
      }
      else
      {
         _loc1_.onEnterFrame = startTransitionToFinish;
      }
   }
   else
   {
      _level100.include.setTranslatorTextFieldTarget(_level10);
      _loc1_.onEnterFrame = startTransitionToFinish;
   }
};
this.loadLocalGameTranslation = function()
{
   var _loc1_ = this;
   if(_loc1_._parent.game_id != undefined && _loc1_._parent.game_lang != undefined && _loc1_._parent.game_id != -1 && _loc1_._parent.game_lang != -1)
   {
      if(_level100.include.game_id == undefined)
      {
         _level100.include.game_id = _loc1_._parent.game_id;
         _level100.include.game_lang = String(_loc1_._parent.game_lang);
      }
      _level100.include.newGameTranslation();
      _loc1_.onEnterFrame = _loc1_.waitForTranslation;
   }
   else
   {
      _loc1_.onEnterFrame = startTransitionToFinish;
   }
};
