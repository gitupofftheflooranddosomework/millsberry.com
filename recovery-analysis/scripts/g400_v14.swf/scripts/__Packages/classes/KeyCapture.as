class classes.KeyCapture extends MovieClip
{
   var aktiv;
   var assignto;
   var invalidkeys;
   var reservedkeys;
   var soundcontroller;
   var specialkeys;
   var textcontroller;
   function KeyCapture()
   {
      super();
      this.textcontroller = _root.CR;
      this.soundcontroller = _root.SC;
      this._x = 320;
      this._y = 240;
      this._visible = false;
      this.aktiv = false;
      this.invalidkeys = new Array();
      this.specialkeys = new Array();
      this.reservedkeys = new Array();
      this.configSpecialKeys();
      this.configReservedKeys();
   }
   function init()
   {
      return this;
   }
   function configSpecialKeys()
   {
      this.specialkeys[0] = [16,_level0.IDS_key_shift];
      this.specialkeys[1] = [17,_level0.IDS_key_ctrl];
      this.specialkeys[2] = [13,_level0.IDS_key_enter];
      this.specialkeys[3] = [37,_level0.IDS_key_left];
      this.specialkeys[4] = [38,_level0.IDS_key_up];
      this.specialkeys[5] = [39,_level0.IDS_key_right];
      this.specialkeys[6] = [40,_level0.IDS_key_down];
      this.specialkeys[7] = [32,_level0.IDS_key_space];
      this.specialkeys[8] = [112,_level0.IDS_key_f1];
      this.specialkeys[9] = [113,_level0.IDS_key_f2];
      this.specialkeys[10] = [114,_level0.IDS_key_f3];
      this.specialkeys[11] = [115,_level0.IDS_key_f4];
      this.specialkeys[12] = [116,_level0.IDS_key_f5];
      this.specialkeys[13] = [117,_level0.IDS_key_f6];
      this.specialkeys[14] = [118,_level0.IDS_key_f7];
      this.specialkeys[15] = [119,_level0.IDS_key_f8];
      this.specialkeys[16] = [120,_level0.IDS_key_f9];
      this.specialkeys[17] = [121,_level0.IDS_key_f10];
      this.specialkeys[18] = [122,_level0.IDS_key_f11];
      this.specialkeys[19] = [123,_level0.IDS_key_f12];
      this.specialkeys[20] = [20,_level0.IDS_key_caps];
      this.specialkeys[21] = [144,_level0.IDS_key_num];
      this.specialkeys[22] = [45,_level0.IDS_key_ins];
      this.specialkeys[23] = [46,_level0.IDS_key_del];
      this.specialkeys[24] = [35,_level0.IDS_key_end];
      this.specialkeys[25] = [36,_level0.IDS_key_home];
      this.specialkeys[26] = [33,_level0.IDS_key_pgup];
      this.specialkeys[27] = [34,_level0.IDS_key_pgdown];
   }
   function configReservedKeys()
   {
   }
   function getSpecialKey(pnum)
   {
      var _loc3_ = "";
      var _loc2_ = 0;
      while(_loc2_ < this.specialkeys.length)
      {
         if(pnum == this.specialkeys[_loc2_][0])
         {
            _loc3_ = this.specialkeys[_loc2_][1];
         }
         _loc2_ = _loc2_ + 1;
      }
      return _loc3_;
   }
   function showWin(pnum)
   {
      this.assignto = pnum;
      Key.addListener(this);
      this.textcontroller.changeContent("controls1 key",_level0["IDS_controls1_key" + pnum + "_txt"]);
      this._visible = true;
      this.aktiv = true;
   }
   function closeWin()
   {
      Key.removeListener(this);
      this._visible = false;
      _root.enable_controls_buttons = true;
      this.aktiv = false;
   }
   function onKeyDown()
   {
      var _loc6_;
      var _loc8_;
      var _loc5_;
      var _loc4_;
      var _loc3_;
      var _loc7_;
      if(this.aktiv)
      {
         _loc6_ = Key.getCode();
         _loc8_ = Key.getAscii();
         _loc5_ = true;
         _loc4_ = 0;
         while(_loc4_ < _root.assignedkeys.length)
         {
            if(_loc5_)
            {
               if(_loc4_ != this.assignto)
               {
                  if(_root.assignedkeys[_loc4_] == _loc6_)
                  {
                     _loc5_ = false;
                  }
               }
               _loc3_ = 0;
               while(_loc3_ < this.reservedkeys.length)
               {
                  if(_loc6_ == this.reservedkeys[_loc3_])
                  {
                     _loc5_ = false;
                  }
                  _loc3_ = _loc3_ + 1;
               }
            }
            _loc4_ = _loc4_ + 1;
         }
         if(_loc5_)
         {
            _loc7_ = "";
            _loc7_ = this.getSpecialKey(_loc6_);
            if(_loc7_ == "")
            {
               _loc7_ = String.fromCharCode(_loc8_);
            }
            _root.keyname[this.assignto] = _loc7_;
            trace("new key: " + _loc7_);
            this.textcontroller.changeContent("assignedkey" + this.assignto,_level0.IDS_key_opener + _root.keyname[this.assignto] + _level0.IDS_key_closer);
            _root.assignedkeys[this.assignto] = _loc6_;
            this.closeWin();
         }
         else
         {
            this.soundcontroller.playSound("error");
         }
      }
   }
   function destructor()
   {
      this.removeMovieClip();
   }
}
