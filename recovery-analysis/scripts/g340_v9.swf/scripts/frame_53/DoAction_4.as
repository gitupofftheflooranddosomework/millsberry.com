function makeScoreboard()
{
   _root.world.attachMovie("sb","sb",gDepths.sb);
   if(_root.characterSelected == 2)
   {
      _root.world.sb.type1._visible = 0;
      _root.world.sb.type2._visible = 1;
   }
   else
   {
      _root.world.sb.type1._visible = 1;
      _root.world.sb.type2._visible = 0;
   }
   _root.world.sb.setEmptyDigits = function(numDigits, num)
   {
      if(num == undefined)
      {
         return undefined;
      }
      var _loc5_ = num.toString();
      var _loc3_ = _loc5_.length;
      if(_loc3_ >= numDigits)
      {
         return num;
      }
      var _loc2_ = "";
      var _loc1_ = 0;
      while(_loc1_ < numDigits - _loc3_)
      {
         _loc2_ += "0";
         _loc1_ = _loc1_ + 1;
      }
      _loc2_ += _loc5_;
      return _loc2_;
   };
   _root.world.sb.refresh = function()
   {
      _global.translator.addTextField(this.tScore,{htmlText:_level0.IDS_score + this.setEmptyDigits(4,_root.eScore.show() + "</font></p>")});
      _global.translator.addTextField(this.tLives,{htmlText:_level0.IDS_lives + _root.eLives.show() + "</font></p>"});
      _global.translator.addTextField(this.tLevel,{htmlText:_level0.IDS_level + _root.eLevel.show() + "</font></p>"});
      var _loc4_ = _root.world.player;
      var _loc5_ = _loc4_.defense + 1;
      trace("DEFENSE: " + _loc4_.defense);
      this.shieldMeter.gotoAndStop(_loc5_);
      _global.translator.addTextField(this.tOffense,{htmlText:_level0.IDS_attack + _loc4_.currentWeapon.typeNum + " - " + _loc4_.offenseNum + "</font></p>"});
      _global.translator.addTextField(this.tBombs,{htmlText:_level0.IDS_special + " x " + _root.eBombs.show() + "</font></p>"});
   };
}
