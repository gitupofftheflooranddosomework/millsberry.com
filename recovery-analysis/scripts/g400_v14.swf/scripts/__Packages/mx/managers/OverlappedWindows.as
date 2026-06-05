class mx.managers.OverlappedWindows
{
   static var initialized = false;
   static var SystemManagerDependency = mx.managers.SystemManager;
   function OverlappedWindows()
   {
   }
   static function checkIdle(Void)
   {
      if(mx.managers.SystemManager.idleFrames > 10)
      {
         mx.managers.SystemManager.dispatchEvent({type:"idle"});
      }
      else
      {
         mx.managers.SystemManager.idleFrames++;
      }
   }
   static function __addEventListener(e, o, l)
   {
      if(e == "idle")
      {
         if(mx.managers.SystemManager.interval == undefined)
         {
            mx.managers.SystemManager.interval = setInterval(mx.managers.SystemManager.checkIdle,100);
         }
      }
      mx.managers.SystemManager._xAddEventListener(e,o,l);
   }
   static function __removeEventListener(e, o, l)
   {
      if(e == "idle")
      {
         if(mx.managers.SystemManager._xRemoveEventListener(e,o,l) == 0)
         {
            clearInterval(mx.managers.SystemManager.interval);
         }
      }
      else
      {
         mx.managers.SystemManager._xRemoveEventListener(e,o,l);
      }
   }
   static function onMouseDown(Void)
   {
      mx.managers.SystemManager.idleFrames = 0;
      mx.managers.SystemManager.isMouseDown = true;
      var _loc5_ = _root;
      var _loc3_;
      var _loc8_ = _root._xmouse;
      var _loc7_ = _root._ymouse;
      var _loc6_;
      var _loc4_;
      var _loc2_;
      if(mx.managers.SystemManager.form.modalWindow == undefined)
      {
         if(mx.managers.SystemManager.forms.length > 1)
         {
            _loc6_ = mx.managers.SystemManager.forms.length;
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               _loc2_ = mx.managers.SystemManager.forms[_loc4_];
               if(_loc2_._visible)
               {
                  if(_loc2_.hitTest(_loc8_,_loc7_))
                  {
                     if(_loc3_ == undefined)
                     {
                        _loc3_ = _loc2_.getDepth();
                        _loc5_ = _loc2_;
                     }
                     else if(_loc3_ < _loc2_.getDepth())
                     {
                        _loc3_ = _loc2_.getDepth();
                        _loc5_ = _loc2_;
                     }
                  }
               }
               _loc4_ = _loc4_ + 1;
            }
            if(_loc5_ != mx.managers.SystemManager.form)
            {
               mx.managers.SystemManager.activate(_loc5_);
            }
         }
      }
      var _loc9_ = mx.managers.SystemManager.form;
      _loc9_.focusManager._onMouseDown();
   }
   static function onMouseMove(Void)
   {
      mx.managers.SystemManager.idleFrames = 0;
   }
   static function onMouseUp(Void)
   {
      mx.managers.SystemManager.isMouseDown = false;
      mx.managers.SystemManager.idleFrames = 0;
   }
   static function activate(f)
   {
      var _loc1_;
      if(mx.managers.SystemManager.form != undefined)
      {
         if(mx.managers.SystemManager.form != f && mx.managers.SystemManager.forms.length > 1)
         {
            _loc1_ = mx.managers.SystemManager.form;
            _loc1_.focusManager.deactivate();
         }
      }
      mx.managers.SystemManager.form = f;
      f.focusManager.activate();
   }
   static function deactivate(f)
   {
      var _loc5_;
      var _loc3_;
      var _loc1_;
      var _loc2_;
      if(mx.managers.SystemManager.form != undefined)
      {
         if(mx.managers.SystemManager.form == f && mx.managers.SystemManager.forms.length > 1)
         {
            _loc5_ = mx.managers.SystemManager.form;
            _loc5_.focusManager.deactivate();
            _loc3_ = mx.managers.SystemManager.forms.length;
            _loc1_ = 0;
            while(_loc1_ < _loc3_)
            {
               if(mx.managers.SystemManager.forms[_loc1_] == f)
               {
                  _loc1_ += 1;
                  while(_loc1_ < _loc3_)
                  {
                     if(mx.managers.SystemManager.forms[_loc1_]._visible == true)
                     {
                        _loc2_ = mx.managers.SystemManager.forms[_loc1_];
                     }
                     _loc1_ = _loc1_ + 1;
                  }
                  mx.managers.SystemManager.form = _loc2_;
                  break;
               }
               if(mx.managers.SystemManager.forms[_loc1_]._visible == true)
               {
                  _loc2_ = mx.managers.SystemManager.forms[_loc1_];
               }
               _loc1_ = _loc1_ + 1;
            }
            _loc5_ = mx.managers.SystemManager.form;
            _loc5_.focusManager.activate();
         }
      }
   }
   static function addFocusManager(f)
   {
      mx.managers.SystemManager.forms.push(f);
      mx.managers.SystemManager.activate(f);
   }
   static function removeFocusManager(f)
   {
      var _loc3_ = mx.managers.SystemManager.forms.length;
      var _loc1_;
      _loc1_ = 0;
      while(_loc1_ < _loc3_)
      {
         if(mx.managers.SystemManager.forms[_loc1_] == f)
         {
            if(mx.managers.SystemManager.form == f)
            {
               mx.managers.SystemManager.deactivate(f);
            }
            mx.managers.SystemManager.forms.splice(_loc1_,1);
            return undefined;
         }
         _loc1_ = _loc1_ + 1;
      }
   }
   static function enableOverlappedWindows()
   {
      if(!mx.managers.OverlappedWindows.initialized)
      {
         mx.managers.OverlappedWindows.initialized = true;
         mx.managers.SystemManager.checkIdle = mx.managers.OverlappedWindows.checkIdle;
         mx.managers.SystemManager.__addEventListener = mx.managers.OverlappedWindows.__addEventListener;
         mx.managers.SystemManager.__removeEventListener = mx.managers.OverlappedWindows.__removeEventListener;
         mx.managers.SystemManager.onMouseDown = mx.managers.OverlappedWindows.onMouseDown;
         mx.managers.SystemManager.onMouseMove = mx.managers.OverlappedWindows.onMouseMove;
         mx.managers.SystemManager.onMouseUp = mx.managers.OverlappedWindows.onMouseUp;
         mx.managers.SystemManager.activate = mx.managers.OverlappedWindows.activate;
         mx.managers.SystemManager.deactivate = mx.managers.OverlappedWindows.deactivate;
         mx.managers.SystemManager.addFocusManager = mx.managers.OverlappedWindows.addFocusManager;
         mx.managers.SystemManager.removeFocusManager = mx.managers.OverlappedWindows.removeFocusManager;
      }
   }
}
