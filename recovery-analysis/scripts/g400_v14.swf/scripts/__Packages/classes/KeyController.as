class classes.KeyController
{
   var currTime;
   var currentkeypressed;
   var funcset;
   var keycount;
   var keyptr;
   var keyset;
   var ptr;
   var uniquekeyset;
   static var keyMC = undefined;
   var lock = false;
   var id = 0;
   var timestamp = 0;
   var polldelay = 0;
   var anykey = false;
   var anykeyfunc = "";
   var anykeytarget = undefined;
   function KeyController(pdelay)
   {
      this.keyset = new Array();
      this.funcset = new Array();
      this.uniquekeyset = new Array();
      this.polldelay = pdelay;
      if(this.polldelay == -1)
      {
         trace("\nExclusive function activated");
      }
      if(!this.createMC())
      {
         trace("Warning: Key Controller not created");
      }
      else
      {
         trace("\n\nKEY CONTROLLER " + this.id + " INITIATED\n");
      }
   }
   function createMC()
   {
      var _loc7_ = false;
      if(classes.KeyController.keyMC == undefined)
      {
         classes.KeyController.keyMC = _root.createEmptyMovieClip("keyMC",1000001);
         classes.KeyController.keyMC._visible = false;
         classes.KeyController.keyMC.keyptr = new Array();
         classes.KeyController.keyMC.currTime = 0;
         classes.KeyController.keyMC.currentkeypressed = -1;
         classes.KeyController.keyMC.keycount = 0;
         classes.KeyController.keyMC.anykey = this.anykey;
         classes.KeyController.keyMC.onEnterFrame = function()
         {
            var _loc5_;
            var _loc4_;
            var _loc3_;
            var _loc2_;
            if(!this.anykey)
            {
               _loc5_ = 0;
               while(_loc5_ < this.keyptr.length)
               {
                  this.ptr = this.keyptr[_loc5_];
                  this.currTime = getTimer();
                  if(!this.ptr.lock)
                  {
                     if(this.ptr.polldelay > 0)
                     {
                        if(this.currTime > this.ptr.timestamp + this.ptr.polldelay)
                        {
                           this.ptr.timestamp = 0;
                        }
                     }
                     if(!(this.ptr.polldelay > 0 && this.ptr.timestamp > 0))
                     {
                        this.keycount = 0;
                        _loc4_ = 0;
                        while(_loc4_ < this.ptr.uniquekeyset.length)
                        {
                           if(!Key.isDown(this.ptr.uniquekeyset[_loc4_]))
                           {
                              this.keycount = this.keycount + 1;
                              if(this.keycount == this.ptr.uniquekeyset.length && this.currentkeypressed > 0)
                              {
                                 this.currentkeypressed = -1;
                              }
                           }
                           else if(this.currentkeypressed <= 0)
                           {
                              _loc3_ = 0;
                              for(; _loc3_ < this.ptr.keyset.length; _loc3_ = _loc3_ + 1)
                              {
                                 if(this.ptr.uniquekeyset[_loc4_] == this.ptr.keyset[_loc3_].actual)
                                 {
                                    if(this.ptr.polldelay == -1)
                                    {
                                       if(this.currentkeypressed == -1)
                                       {
                                          this.currentkeypressed = this.ptr.uniquekeyset[_loc4_];
                                       }
                                       else if(this.ptr.uniquekeyset[_loc4_] != this.currentkeypressed)
                                       {
                                          continue;
                                       }
                                    }
                                    _loc2_ = 0;
                                    while(_loc2_ < this.ptr.funcset.length)
                                    {
                                       if(this.ptr.funcset[_loc2_].virtual == this.ptr.keyset[_loc3_].virtual)
                                       {
                                          this.ptr.funcset[_loc2_].ref[this.ptr.funcset[_loc2_].func]();
                                          if(this.ptr.polldelay > 0)
                                          {
                                             if(this.ptr.timestamp == 0)
                                             {
                                                this.ptr.timestamp = getTimer();
                                             }
                                          }
                                       }
                                       _loc2_ = _loc2_ + 1;
                                    }
                                 }
                              }
                           }
                           _loc4_ = _loc4_ + 1;
                        }
                     }
                  }
                  _loc5_ = _loc5_ + 1;
               }
            }
         };
      }
      this.id = classes.KeyController.keyMC.keyptr.length;
      classes.KeyController.keyMC.keyptr[this.id] = this;
      if(classes.KeyController.keyMC != undefined)
      {
         _loc7_ = true;
      }
      return _loc7_;
   }
   function lockKeyCapture()
   {
      this.lock = true;
   }
   function unlockKeyCapture()
   {
      this.lock = false;
   }
   function compileUniqueKeys()
   {
      var _loc2_ = 0;
      var _loc3_ = 0;
      while(_loc3_ < this.keyset.length)
      {
         while(this.keyset[_loc3_].actual != this.uniquekeyset[_loc2_] && _loc2_ < this.uniquekeyset.length)
         {
            _loc2_ = _loc2_ + 1;
         }
         if(_loc2_ == this.uniquekeyset.length)
         {
            this.uniquekeyset[_loc2_] = this.keyset[_loc3_].actual;
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function addKey(pident, pkey)
   {
      var _loc2_ = this.findKey(pident);
      if(_loc2_ == -1)
      {
         this.keyset[this.keyset.length] = new Object();
         this.keyset[this.keyset.length - 1].virtual = pident;
         this.keyset[this.keyset.length - 1].actual = pkey;
         this.compileUniqueKeys();
         trace("Key Registered: " + this.keyset[this.keyset.length - 1].virtual + " / " + this.keyset[this.keyset.length - 1].actual);
      }
      else
      {
         trace("Key identifier already in use!");
      }
   }
   function changeKey(pident, pkey)
   {
      var _loc2_ = this.findKey(pident);
      if(_loc2_ > -1)
      {
         this.keyset[_loc2_].actual = pkey;
         delete this.uniquekeyset;
         this.uniquekeyset = new Array();
         this.compileUniqueKeys();
         trace("Key Reassigned: " + this.keyset[_loc2_].virtual + " / " + this.keyset[_loc2_].actual);
      }
      else
      {
         trace("Key not found for reassignment!");
      }
   }
   function findKey(pident)
   {
      var _loc2_ = 0;
      while(this.keyset[_loc2_].virtual != pident && _loc2_ < this.keyset.length)
      {
         _loc2_ = _loc2_ + 1;
      }
      if(_loc2_ == this.keyset.length)
      {
         _loc2_ = -1;
      }
      return _loc2_;
   }
   function unregisterKey(pident)
   {
      var _loc3_ = this.findKey(pident);
      var _loc2_;
      if(_loc3_ > -1)
      {
         _loc2_ = _loc3_;
         while(_loc2_ < this.keyset.length - 1)
         {
            this.keyset[_loc2_] = this.keyset[_loc2_ + 1];
            _loc2_ = _loc2_ + 1;
         }
         this.keyset.pop();
         this.compileUniqueKeys();
      }
   }
   function registerFunc(pident, pref, pfunc)
   {
      this.funcset[this.funcset.length] = new Object();
      this.funcset[this.funcset.length - 1].virtual = pident;
      this.funcset[this.funcset.length - 1].ref = pref;
      this.funcset[this.funcset.length - 1].func = pfunc;
      trace("mapped: " + this.funcset[this.funcset.length - 1].virtual + " -> " + this.funcset[this.funcset.length - 1].ref + "." + this.funcset[this.funcset.length - 1].func + "()");
   }
   function findFunc(pident, pref, pfunc)
   {
      var _loc2_ = 0;
      while((this.funcset[_loc2_].virtual != pident || this.funcset[_loc2_].ref != pref || this.funcset[_loc2_].func != pfunc) && _loc2_ < this.funcset.length)
      {
         _loc2_ = _loc2_ + 1;
      }
      if(_loc2_ == this.funcset.length)
      {
         _loc2_ = -1;
      }
      return _loc2_;
   }
   function unregisterFunc(pident, pref, pfunc)
   {
      var _loc3_ = this.findFunc(pident,pref,pfunc);
      var _loc2_;
      if(_loc3_ > -1)
      {
         _loc2_ = _loc3_;
         while(_loc2_ < this.funcset.length - 1)
         {
            this.funcset[_loc2_] = this.funcset[_loc2_ + 1];
            _loc2_ = _loc2_ + 1;
         }
         this.funcset.pop();
      }
   }
   function enableCheckAnyKey(panykeytarget, panykeyfunc)
   {
      this.anykey = true;
      classes.KeyController.keyMC.anykey = this.anykey;
      Key.addListener(this);
      this.anykeytarget = panykeytarget;
      this.anykeyfunc = panykeyfunc;
   }
   function anyKeyHandler()
   {
      if(this.anykeytarget != undefined)
      {
         this.anykeytarget[this.anykeyfunc]();
      }
   }
   function disableCheckAnyKey()
   {
      Key.removeListener(this);
      this.anykey = false;
      classes.KeyController.keyMC.anykey = this.anykey;
      this.anykeytarget = undefined;
      this.anykeyfunc = "";
   }
   function destroy()
   {
      Key.removeListener(this);
      classes.KeyController.keyMC.removeMovieClip();
      classes.KeyController.keyMC = undefined;
      this.keyset.splice(0);
      this.funcset.splice(0);
      this.uniquekeyset.splice(0);
      delete this.keyset;
      delete this.funcset;
      delete this.uniquekeyset;
   }
   function onKeyDown()
   {
      trace("onKeyDown Handler: " + Key.getCode());
      if(this.anykey)
      {
         this.anyKeyHandler();
      }
   }
}
