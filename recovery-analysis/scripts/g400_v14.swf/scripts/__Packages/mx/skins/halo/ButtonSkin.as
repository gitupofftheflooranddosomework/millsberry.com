class mx.skins.halo.ButtonSkin extends mx.skins.RectBorder
{
   var _parent;
   var clear;
   var drawRoundRect;
   var getStyle;
   var x;
   var y;
   static var symbolName = "ButtonSkin";
   static var symbolOwner = mx.skins.halo.ButtonSkin;
   var className = "ButtonSkin";
   var backgroundColorName = "buttonColor";
   static var classConstructed = mx.skins.halo.ButtonSkin.classConstruct();
   static var UIObjectExtensionsDependency = mx.core.ext.UIObjectExtensions;
   function ButtonSkin()
   {
      super();
   }
   function init()
   {
      super.init();
   }
   function size()
   {
      this.drawHaloRect(this.width,this.height);
   }
   function drawHaloRect(w, h)
   {
      var _loc6_ = this.getStyle("borderStyle");
      var _loc4_ = this.getStyle("themeColor");
      var _loc5_ = this._parent.emphasized;
      this.clear();
      switch(_loc6_)
      {
         case "falseup":
            if(_loc5_)
            {
               this.drawRoundRect(this.x,this.y,w,h,5,9542041,100);
               this.drawRoundRect(this.x,this.y,w,h,5,_loc4_,75);
               this.drawRoundRect(this.x + 1,this.y + 1,w - 2,h - 2,4,[3355443,16777215],85,0,"radial");
               this.drawRoundRect(this.x + 2,this.y + 2,w - 4,h - 4,3,[0,14342874],100,0,"radial");
               this.drawRoundRect(this.x + 2,this.y + 2,w - 4,h - 4,3,_loc4_,75);
               this.drawRoundRect(this.x + 3,this.y + 3,w - 6,h - 6,2,16777215,100);
               this.drawRoundRect(this.x + 3,this.y + 4,w - 6,h - 7,2,16316664,100);
            }
            else
            {
               this.drawRoundRect(0,0,w,h,5,9542041,100);
               this.drawRoundRect(1,1,w - 2,h - 2,4,[13291985,16250871],100,0,"radial");
               this.drawRoundRect(2,2,w - 4,h - 4,3,[9542041,13818586],100,0,"radial");
               this.drawRoundRect(3,3,w - 6,h - 6,2,16777215,100);
               this.drawRoundRect(3,4,w - 6,h - 7,2,16316664,100);
            }
            break;
         case "falsedown":
            this.drawRoundRect(this.x,this.y,w,h,5,9542041,100);
            this.drawRoundRect(this.x + 1,this.y + 1,w - 2,h - 2,4,[3355443,16579836],100,0,"radial");
            this.drawRoundRect(this.x + 1,this.y + 1,w - 2,h - 2,4,_loc4_,50);
            this.drawRoundRect(this.x + 2,this.y + 2,w - 4,h - 4,3,[0,14342874],100,0,"radial");
            this.drawRoundRect(this.x,this.y,w,h,5,_loc4_,40);
            this.drawRoundRect(this.x + 3,this.y + 3,w - 6,h - 6,2,16777215,100);
            this.drawRoundRect(this.x + 3,this.y + 4,w - 6,h - 7,2,_loc4_,20);
            break;
         case "falserollover":
            this.drawRoundRect(this.x,this.y,w,h,5,9542041,100);
            this.drawRoundRect(this.x,this.y,w,h,5,_loc4_,50);
            this.drawRoundRect(this.x + 1,this.y + 1,w - 2,h - 2,4,[3355443,16777215],100,0,"radial");
            this.drawRoundRect(this.x + 2,this.y + 2,w - 4,h - 4,3,[0,14342874],100,0,"radial");
            this.drawRoundRect(this.x + 2,this.y + 2,w - 4,h - 4,3,_loc4_,50);
            this.drawRoundRect(this.x + 3,this.y + 3,w - 6,h - 6,2,16777215,100);
            this.drawRoundRect(this.x + 3,this.y + 4,w - 6,h - 7,2,16316664,100);
            break;
         case "falsedisabled":
            this.drawRoundRect(0,0,w,h,5,13159628,100);
            this.drawRoundRect(1,1,w - 2,h - 2,4,15921906,100);
            this.drawRoundRect(2,2,w - 4,h - 4,3,13949401,100);
            this.drawRoundRect(3,3,w - 6,h - 6,2,15921906,100);
            break;
         case "trueup":
            this.drawRoundRect(this.x,this.y,w,h,5,10066329,100);
            this.drawRoundRect(this.x + 1,this.y + 1,w - 2,h - 2,4,[3355443,16579836],100,0,"radial");
            this.drawRoundRect(this.x + 1,this.y + 1,w - 2,h - 2,4,_loc4_,50);
            this.drawRoundRect(this.x + 2,this.y + 2,w - 4,h - 4,3,[0,14342874],100,0,"radial");
            this.drawRoundRect(this.x,this.y,w,h,5,_loc4_,40);
            this.drawRoundRect(this.x + 3,this.y + 3,w - 6,h - 6,2,16777215,100);
            this.drawRoundRect(this.x + 3,this.y + 4,w - 6,h - 7,2,16250871,100);
            break;
         case "truedown":
            this.drawRoundRect(this.x,this.y,w,h,5,10066329,100);
            this.drawRoundRect(this.x + 1,this.y + 1,w - 2,h - 2,4,[3355443,16579836],100,0,"radial");
            this.drawRoundRect(this.x + 1,this.y + 1,w - 2,h - 2,4,_loc4_,50);
            this.drawRoundRect(this.x + 2,this.y + 2,w - 4,h - 4,3,[0,14342874],100,0,"radial");
            this.drawRoundRect(this.x,this.y,w,h,5,_loc4_,40);
            this.drawRoundRect(this.x + 3,this.y + 3,w - 6,h - 6,2,16777215,100);
            this.drawRoundRect(this.x + 3,this.y + 4,w - 6,h - 7,2,_loc4_,20);
            break;
         case "truerollover":
            this.drawRoundRect(this.x,this.y,w,h,5,9542041,100);
            this.drawRoundRect(this.x,this.y,w,h,5,_loc4_,50);
            this.drawRoundRect(this.x + 1,this.y + 1,w - 2,h - 2,4,[3355443,16777215],100,0,"radial");
            this.drawRoundRect(this.x + 1,this.y + 1,w - 2,h - 2,4,_loc4_,40);
            this.drawRoundRect(this.x + 2,this.y + 2,w - 4,h - 4,3,[0,14342874],100,0,"radial");
            this.drawRoundRect(this.x + 2,this.y + 2,w - 4,h - 4,3,_loc4_,40);
            this.drawRoundRect(this.x + 3,this.y + 3,w - 6,h - 6,2,16777215,100);
            this.drawRoundRect(this.x + 3,this.y + 4,w - 6,h - 7,2,16316664,100);
            break;
         case "truedisabled":
            this.drawRoundRect(0,0,w,h,5,13159628,100);
            this.drawRoundRect(1,1,w - 2,h - 2,4,15921906,100);
            this.drawRoundRect(2,2,w - 4,h - 4,3,13949401,100);
            this.drawRoundRect(3,3,w - 6,h - 6,2,15921906,100);
         default:
            return;
      }
   }
   static function classConstruct()
   {
      mx.core.ext.UIObjectExtensions.Extensions();
      _global.skinRegistry.ButtonSkin = true;
      return true;
   }
}
