class classes.SoundController
{
   var soundList;
   var soundMCList;
   var soundObj;
   var start;
   static var soundMC;
   var bgm_id = -1;
   static var sound_state = 0;
   static var playable = true;
   var bgmplaying = false;
   function SoundController(plist)
   {
      this.soundList = new Array();
      this.soundObj = new Array();
      this.soundMCList = new Array();
      var _loc4_;
      if(classes.SoundController.soundMC == undefined || classes.SoundController.soundMC == null)
      {
         _loc4_ = int(Math.random() * 1000);
         while(_root["soundMC" + _loc4_] != undefined)
         {
            _loc4_ = int(Math.random() * 1000);
         }
         classes.SoundController.soundMC = _root.createEmptyMovieClip("soundMC" + _loc4_,1000000);
      }
      this.soundList = plist;
      var _loc3_ = 0;
      while(_loc3_ < this.soundList.length)
      {
         _loc4_ = int(Math.random() * 10000);
         while(classes.SoundController.soundMC[_loc4_] != undefined)
         {
            _loc4_ = int(Math.random() * 1000);
         }
         this.soundMCList[_loc3_] = classes.SoundController.soundMC.createEmptyMovieClip(_loc4_.toString(),_loc4_);
         this.soundObj[_loc3_] = new Sound(this.soundMCList[_loc3_]);
         this.soundObj[_loc3_].attachSound(this.soundList[_loc3_]);
         _loc3_ = _loc3_ + 1;
      }
   }
   function findSound(psoundname)
   {
      var _loc2_ = 0;
      var _loc5_ = -1;
      var _loc3_ = false;
      while(_loc2_ < this.soundList.length && !_loc3_)
      {
         this.soundList[_loc2_] != psoundname ? _loc2_++ : (_loc3_ = true);
      }
      if(_loc3_)
      {
         _loc5_ = _loc2_;
      }
      return _loc5_;
   }
   function playSound(psoundname)
   {
      var _loc2_;
      if(classes.SoundController.playable)
      {
         if(classes.SoundController.sound_state == 0 || classes.SoundController.sound_state == 1)
         {
            _loc2_ = this.findSound(psoundname);
            if(_loc2_ >= 0)
            {
               this.soundObj[_loc2_].stop(this.soundList[_loc2_]);
               this.soundObj[_loc2_].start(0,1);
            }
         }
      }
   }
   function stopSound(psoundname)
   {
      var _loc2_ = this.findSound(psoundname);
      if(_loc2_ >= 0)
      {
         this.soundObj[_loc2_].stop(this.soundList[_loc2_]);
      }
   }
   function setSoundVolume(psoundname, pval)
   {
      var _loc2_ = this.findSound(psoundname);
      if(_loc2_ >= 0)
      {
         this.soundObj[_loc2_].setVolume(pval);
      }
   }
   function setSoundPan(psoundname, pval)
   {
      var _loc2_ = this.findSound(psoundname);
      if(_loc2_ >= 0)
      {
         this.soundObj[_loc2_].setPan(pval);
      }
   }
   function getSoundPosition(pposn, pmaxposn)
   {
      var _loc1_ = int((pposn - pmaxposn / 2) / (pmaxposn / 2) * 100);
      return _loc1_;
   }
   function setBGM(psoundname)
   {
      this.bgm_id = this.findSound(psoundname);
   }
   function playBGM()
   {
      if(classes.SoundController.playable && !this.bgmplaying)
      {
         if(classes.SoundController.sound_state == 0 || classes.SoundController.sound_state == 3)
         {
            if(this.bgm_id >= 0)
            {
               this.bgmplaying = true;
               this.soundObj[this.bgm_id].start(0,99);
               this.soundObj[this.bgm_id].onSoundComplete = function()
               {
                  this.start(0,99);
               };
            }
         }
      }
   }
   function stopBGM()
   {
      if(this.bgm_id >= 0)
      {
         this.soundObj[this.bgm_id].onSoundComplete = null;
         this.soundObj[this.bgm_id].stop(this.soundList[this.bgm_id]);
         this.bgmplaying = false;
      }
   }
   function setBGMVolume(pval)
   {
      this.soundObj[this.bgm_id].setVolume(pval);
   }
   function turnOn()
   {
      classes.SoundController.playable = true;
      classes.SoundController.sound_state = 0;
      this.updateSoundStatus();
   }
   function turnOff()
   {
      classes.SoundController.playable = false;
      classes.SoundController.sound_state = 2;
      this.updateSoundStatus();
   }
   function updateSoundStatus()
   {
      if(classes.SoundController.sound_state == 2 || classes.SoundController.sound_state == 3)
      {
         for(var _loc2_ in this.soundObj)
         {
            if(_loc2_ != this.bgm_id)
            {
               this.soundObj[_loc2_].stop(this.soundList[_loc2_]);
            }
         }
      }
      !(classes.SoundController.sound_state == 1 || classes.SoundController.sound_state == 2) ? this.playBGM() : this.stopBGM();
   }
   function toggleSound()
   {
      if(classes.SoundController.playable)
      {
         this.turnOff();
         return 0;
      }
      this.turnOn();
      return 1;
   }
   function getSoundState()
   {
      return classes.SoundController.sound_state;
   }
   function toggleSoundState()
   {
      classes.SoundController.sound_state = (classes.SoundController.sound_state + 1) % 4;
      this.updateSoundStatus();
      return classes.SoundController.sound_state;
   }
   function destruct()
   {
      var _loc2_ = 0;
      while(_loc2_ < this.soundList.length)
      {
         this.soundObj[_loc2_].stop(this.soundList[_loc2_]);
         delete this.soundObj[_loc2_];
         this.soundMCList[_loc2_].removeMovieClip();
         _loc2_ = _loc2_ + 1;
      }
      delete this.soundList;
      delete this.soundObj;
      delete this.soundMCList;
   }
}
