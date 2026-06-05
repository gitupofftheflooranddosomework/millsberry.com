class classes.ContentRegister
{
   var defaultfont;
   var register_array;
   var translator_object;
   function ContentRegister(pobject, pdefaultfont)
   {
      this.register_array = new Array();
      this.translator_object = pobject;
      this.defaultfont = pdefaultfont;
      this.resetFont();
   }
   function setFont(pfontname)
   {
      this.translator_object.setDefaultFont(pfontname);
   }
   function resetFont()
   {
      this.setFont(this.defaultfont);
   }
   function addContent(ptarget, pid, pinittext)
   {
      var _loc2_ = this.register_array.length;
      if(this.findLoc(pid) != -1)
      {
         trace("\nCR_ERR: [" + pid + "] duplicated");
      }
      else
      {
         this.register_array[_loc2_] = new Object();
         this.register_array[_loc2_].ref = this.translator_object.addTextField(ptarget,{htmlText:pinittext});
         this.register_array[_loc2_].id = pid;
         this.register_array[_loc2_].symref = ptarget;
         this.resetFont();
      }
   }
   function findLoc(pid)
   {
      var _loc2_ = 0;
      var _loc4_ = -1;
      while(this.register_array[_loc2_].id != pid && _loc2_ < this.register_array.length)
      {
         _loc2_ = _loc2_ + 1;
      }
      if(this.register_array[_loc2_].id == pid)
      {
         _loc4_ = _loc2_;
      }
      return _loc4_;
   }
   function changeContent(pid, ptext)
   {
      var _loc2_ = this.findLoc(pid);
      _loc2_ <= -1 ? (trace("\nContent ID: " + pid + " is invalid\n"),§§push(undefined),undefined) : this.register_array[_loc2_].ref.setHtmlText(ptext);
      this.resetFont();
   }
   function refreshRef(pid)
   {
      var _loc2_ = this.findLoc(pid);
      _loc2_ <= -1 ? (trace("\nContent ID: " + pid + " is invalid\n"),§§push(undefined),undefined) : (this.register_array[_loc2_].ref = this.translator_object.addTextField(this.register_array[_loc2_].symref,{htmlText:""}));
   }
   function flushRegister()
   {
      var _loc2_ = 0;
      while(_loc2_ < this.register_array.length)
      {
         this.translator_object.removeTranslatableTextField(this.register_array[_loc2_].ref);
         _loc2_ = _loc2_ + 1;
      }
      this.register_array.splice(0);
   }
   function destructor()
   {
      this.flushRegister();
      delete this.defaultfont;
   }
}
