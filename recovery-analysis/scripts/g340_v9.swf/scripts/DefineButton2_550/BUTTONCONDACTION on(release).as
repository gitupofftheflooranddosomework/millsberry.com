on(release){
   _root.buttonClick.start();
   if(_global.instruction_page_flag)
   {
      _global.instruction_page_flag = false;
      _root.gotoAndPlay("resetallframe");
   }
   else
   {
      _root.closeInstruct();
   }
}
