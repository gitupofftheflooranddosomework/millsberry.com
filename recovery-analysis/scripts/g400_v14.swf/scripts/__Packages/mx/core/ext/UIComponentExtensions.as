class mx.core.ext.UIComponentExtensions
{
   var drawFocus;
   var getFocusManager;
   var tabEnabled;
   static var bExtended = false;
   static var UIComponentExtended = mx.core.ext.UIComponentExtensions.Extensions();
   static var UIComponentDependency = mx.core.UIComponent;
   static var FocusManagerDependency = mx.managers.FocusManager;
   static var OverlappedWindowsDependency = mx.managers.OverlappedWindows;
   function UIComponentExtensions()
   {
   }
   static function Extensions()
   {
      if(mx.core.ext.UIComponentExtensions.bExtended == true)
      {
         return true;
      }
      mx.core.ext.UIComponentExtensions.bExtended = true;
      TextField.prototype.setFocus = function()
      {
         Selection.setFocus(this);
      };
      TextField.prototype.onSetFocus = function(oldFocus)
      {
         if(this.tabEnabled != false)
         {
            if(this.getFocusManager().bDrawFocus)
            {
               this.drawFocus(true);
            }
         }
      };
      TextField.prototype.onKillFocus = function(oldFocus)
      {
         if(this.tabEnabled != false)
         {
            this.drawFocus(false);
         }
      };
      TextField.prototype.drawFocus = mx.core.UIComponent.prototype.drawFocus;
      TextField.prototype.getFocusManager = mx.core.UIComponent.prototype.getFocusManager;
      mx.managers.OverlappedWindows.enableOverlappedWindows();
      mx.styles.CSSSetStyle.enableRunTimeCSS();
      mx.managers.FocusManager.enableFocusManagement();
   }
}
