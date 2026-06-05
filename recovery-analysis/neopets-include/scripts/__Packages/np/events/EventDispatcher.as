class np.events.EventDispatcher
{
   static var _fEventDispatcher = undefined;
   static var exceptions = {move:1,draw:1,load:1};
   static var isTracing_boolean = false;
   function EventDispatcher()
   {
   }
   static function _removeEventListener(queue, event, handler)
   {
      var _loc3_ = queue;
      var _loc1_;
      var _loc2_;
      if(_loc3_ != undefined)
      {
         var l = _loc3_.length;
         _loc1_ = 0;
         while(_loc1_ < l)
         {
            _loc2_ = _loc3_[_loc1_];
            if(_loc2_ == handler)
            {
               _loc3_.splice(_loc1_,1);
               break;
            }
            _loc1_ = _loc1_ + 1;
         }
      }
   }
   static function initialize(object)
   {
      var _loc1_ = object;
      if(np.events.EventDispatcher.isTracing_boolean == true)
      {
         trace("@@EventDispatcher.initialize (" + _loc1_ + ")");
      }
      if(np.events.EventDispatcher._fEventDispatcher == undefined)
      {
         np.events.EventDispatcher._fEventDispatcher = new np.events.EventDispatcher();
      }
      _loc1_.addEventListener = np.events.EventDispatcher._fEventDispatcher.addEventListener;
      _loc1_.removeEventListener = np.events.EventDispatcher._fEventDispatcher.removeEventListener;
      _loc1_.dispatchEvent = np.events.EventDispatcher._fEventDispatcher.dispatchEvent;
      _loc1_.dispatchQueue = np.events.EventDispatcher._fEventDispatcher.dispatchQueue;
   }
   function dispatchQueue(queueObj, eventObj)
   {
      var _loc2_ = eventObj;
      var queueName = "__q_" + _loc2_.type;
      var queue = queueObj[queueName];
      var _loc1_;
      var _loc3_;
      if(queue != undefined)
      {
         var i;
         for(i in queue)
         {
            _loc1_ = queue[i];
            _loc3_ = typeof _loc1_;
            if(_loc3_ == "object" || _loc3_ == "movieclip")
            {
               if(_loc1_.handleEvent != undefined)
               {
                  _loc1_.handleEvent(_loc2_);
               }
               if(_loc1_[_loc2_.type] != undefined)
               {
                  if(np.events.EventDispatcher.exceptions[_loc2_.type] == undefined)
                  {
                     _loc1_[_loc2_.type](_loc2_);
                  }
               }
            }
            else
            {
               _loc1_.apply(queueObj,[_loc2_]);
            }
         }
      }
   }
   function dispatchEvent(eventObj)
   {
      var _loc1_ = eventObj;
      var _loc2_ = this;
      if(np.events.EventDispatcher.isTracing_boolean == true)
      {
         trace("@@" + _loc2_ + ".dispatchEvent() type: " + _loc1_.type);
      }
      if(_loc1_.target == undefined)
      {
         _loc1_.target = _loc2_;
      }
      _loc2_[_loc1_.type + "Handler"](_loc1_);
      _loc2_.dispatchQueue(_loc2_,_loc1_);
   }
   function addEventListener(event, handler)
   {
      var _loc2_ = this;
      var _loc3_ = event;
      if(np.events.EventDispatcher.isTracing_boolean == true)
      {
         trace("@@" + _loc2_ + ".addEventListener (" + _loc3_ + "," + handler + ")");
      }
      var _loc1_ = "__q_" + _loc3_;
      if(_loc2_[_loc1_] == undefined)
      {
         _loc2_[_loc1_] = new Array();
      }
      _global.ASSetPropFlags(_loc2_,_loc1_,1);
      np.events.EventDispatcher._removeEventListener(_loc2_[_loc1_],_loc3_,handler);
      _loc2_[_loc1_].push(handler);
   }
   function removeEventListener(event, handler)
   {
      var _loc1_ = event;
      if(np.events.EventDispatcher.isTracing_boolean == true)
      {
         trace("@@" + this + ".removeEventListener (" + _loc1_ + "," + handler + ")");
      }
      var _loc2_ = "__q_" + _loc1_;
      np.events.EventDispatcher._removeEventListener(this[_loc2_],_loc1_,handler);
   }
}
