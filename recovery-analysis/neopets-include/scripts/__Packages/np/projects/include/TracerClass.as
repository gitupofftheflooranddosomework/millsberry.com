class np.projects.include.TracerClass
{
   var cPrefix;
   var iActive;
   function TracerClass(iAct, cPre)
   {
      this.iActive = iAct;
      this.cPrefix = cPre;
   }
   function trace(s, bForce)
   {
      var _loc1_ = bForce;
      if(_loc1_ == undefined)
      {
         _loc1_ = false;
      }
      if(this.iActive || _loc1_)
      {
         trace(this.cPrefix + s);
      }
   }
}
