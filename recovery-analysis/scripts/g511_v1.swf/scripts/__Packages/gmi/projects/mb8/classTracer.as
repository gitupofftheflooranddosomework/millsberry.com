class gmi.projects.mb8.classTracer
{
   var bActive;
   var cPrefix;
   function classTracer(bAct, cPre)
   {
      this.bActive = bAct;
      this.cPrefix = cPre;
   }
   function trace(s, bForce)
   {
      if(bForce == undefined)
      {
         bForce = false;
      }
      if(this.bActive || bForce)
      {
         trace(this.cPrefix + s);
      }
   }
}
