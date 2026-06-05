class gs.OverwriteManager
{
   static var enabled;
   static var mode;
   static var version = 3.100000000000001;
   static var NONE = 0;
   static var ALL = 1;
   static var AUTO = 2;
   static var CONCURRENT = 3;
   function OverwriteManager()
   {
   }
   static function init($mode)
   {
      if(gs.TweenLite.version < 10.05)
      {
         trace("TweenLite warning: Your TweenLite class needs to be updated to work with OverwriteManager (or you may need to clear your ASO files). Please download and install the latest version from http://www.tweenlite.com.");
      }
      gs.TweenLite.overwriteManager = gs.OverwriteManager;
      gs.OverwriteManager.mode = $mode != undefined ? $mode : 2;
      gs.OverwriteManager.enabled = true;
      return gs.OverwriteManager.mode;
   }
   static function manageOverwrites($tween, $targetTweens)
   {
      var _loc12_ = $tween.vars;
      var _loc13_ = _loc12_.overwrite != undefined ? Number(_loc12_.overwrite) : gs.OverwriteManager.mode;
      if(_loc13_ < 2 || $targetTweens == undefined)
      {
         return undefined;
      }
      var _loc9_ = $tween.startTime;
      var _loc3_ = [];
      var _loc1_;
      var _loc14_;
      var _loc4_;
      _loc1_ = $targetTweens.length - 1;
      while(_loc1_ > -1)
      {
         _loc4_ = $targetTweens[_loc1_];
         if(_loc4_ != $tween && _loc4_.startTime <= _loc9_ && _loc4_.startTime + _loc4_.duration * 1000 / _loc4_.combinedTimeScale > _loc9_)
         {
            _loc3_[_loc3_.length] = _loc4_;
         }
         _loc1_ = _loc1_ - 1;
      }
      if(_loc3_.length == 0 || $tween.tweens.length == 0)
      {
         return undefined;
      }
      var _loc8_;
      var _loc7_;
      var _loc2_;
      var _loc6_;
      var _loc5_;
      if(_loc13_ == gs.OverwriteManager.AUTO)
      {
         _loc8_ = $tween.tweens;
         _loc7_ = {};
         _loc1_ = _loc8_.length - 1;
         while(_loc1_ > -1)
         {
            _loc6_ = _loc8_[_loc1_];
            if(_loc6_.isPlugin && _loc6_.name == "_MULTIPLE_")
            {
               _loc5_ = _loc6_.target.overwriteProps;
               _loc2_ = _loc5_.length - 1;
               while(_loc2_ > -1)
               {
                  _loc7_[_loc5_[_loc2_]] = true;
                  _loc2_ = _loc2_ - 1;
               }
            }
            else
            {
               _loc7_[_loc6_.name] = true;
            }
            _loc1_ = _loc1_ - 1;
         }
         _loc1_ = _loc3_.length - 1;
         while(_loc1_ > -1)
         {
            gs.OverwriteManager.killVars(_loc7_,_loc3_[_loc1_].vars,_loc3_[_loc1_].tweens);
            _loc1_ = _loc1_ - 1;
         }
      }
      else
      {
         _loc1_ = _loc3_.length - 1;
         while(_loc1_ > -1)
         {
            _loc3_[_loc1_].enabled = false;
            _loc1_ = _loc1_ - 1;
         }
      }
   }
   static function killVars($killVars, $vars, $tweens, $subTweens, $filters)
   {
      var _loc2_;
      var _loc5_;
      var _loc1_;
      _loc2_ = $tweens.length - 1;
      while(_loc2_ > -1)
      {
         _loc1_ = $tweens[_loc2_];
         if($killVars[_loc1_.name] != undefined)
         {
            $tweens.splice(_loc2_,1);
         }
         else if(_loc1_.isPlugin && _loc1_.name == "_MULTIPLE_")
         {
            _loc1_.target.killProps($killVars);
            if(_loc1_.target.overwriteProps.length == 0)
            {
               $tweens.splice(_loc2_,1);
            }
         }
         _loc2_ = _loc2_ - 1;
      }
      for(_loc5_ in $killVars)
      {
         delete $vars[_loc5_];
      }
   }
}
