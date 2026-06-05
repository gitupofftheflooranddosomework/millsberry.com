class mx.transitions.BroadcasterMX
{
   var _listeners;
   static var version = "1.1.0.52";
   function BroadcasterMX()
   {
   }
   static function initialize(o, dontCreateArray)
   {
      if(o.broadcastMessage != undefined)
      {
         delete o.broadcastMessage;
      }
      o.addListener = mx.transitions.BroadcasterMX.prototype.addListener;
      o.removeListener = mx.transitions.BroadcasterMX.prototype.removeListener;
      if(!dontCreateArray)
      {
         o._listeners = new Array();
      }
   }
   function addListener(o)
   {
      this.removeListener(o);
      if(this.broadcastMessage == undefined)
      {
         this.broadcastMessage = mx.transitions.BroadcasterMX.prototype.broadcastMessage;
      }
      return this._listeners.push(o);
   }
   function removeListener(o)
   {
      var _loc2_ = this._listeners;
      var _loc3_ = _loc2_.length;
      while(_loc3_--)
      {
         if(_loc2_[_loc3_] == o)
         {
            _loc2_.splice(_loc3_,1);
            if(!_loc2_.length)
            {
               this.broadcastMessage = undefined;
            }
            return true;
         }
      }
      return false;
   }
   function broadcastMessage()
   {
      var _loc5_ = String(arguments.shift());
      var _loc4_ = this._listeners.concat();
      var _loc6_ = _loc4_.length;
      var _loc3_ = 0;
      while(_loc3_ < _loc6_)
      {
         _loc4_[_loc3_][_loc5_].apply(_loc4_[_loc3_],arguments);
         _loc3_ = _loc3_ + 1;
      }
   }
}
