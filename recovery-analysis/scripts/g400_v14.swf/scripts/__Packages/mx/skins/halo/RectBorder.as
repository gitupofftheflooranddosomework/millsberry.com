class mx.skins.halo.RectBorder extends mx.skins.RectBorder
{
   var __borderMetrics;
   var _color;
   var beginFill;
   var clear;
   var drawRect;
   var drawRoundRect;
   var endFill;
   var getStyle;
   var offset;
   static var symbolName = "RectBorder";
   static var symbolOwner = mx.skins.halo.RectBorder;
   static var version = "2.0.2.126";
   var borderCapColorName = "borderCapColor";
   var shadowCapColorName = "shadowCapColor";
   var colorList = {highlightColor:0,borderColor:0,buttonColor:0,shadowColor:0,borderCapColor:0,shadowCapColor:0};
   var borderWidths = {none:0,solid:1,inset:2,outset:2,alert:3,dropDown:2,menuBorder:2,comboNonEdit:2};
   static var classConstructed = mx.skins.halo.RectBorder.classConstruct();
   static var UIObjectExtensionsDependency = mx.core.ext.UIObjectExtensions;
   function RectBorder()
   {
      super();
   }
   function init(Void)
   {
      this.borderWidths["default"] = 3;
      super.init();
   }
   function getBorderMetrics(Void)
   {
      var _loc3_;
      if(this.offset == undefined)
      {
         _loc3_ = this.getStyle(this.borderStyleName);
         this.offset = this.borderWidths[_loc3_];
      }
      if(this.getStyle(this.borderStyleName) == "default" || this.getStyle(this.borderStyleName) == "alert")
      {
         this.__borderMetrics = {left:3,top:1,right:3,bottom:3};
         return this.__borderMetrics;
      }
      return super.getBorderMetrics();
   }
   function drawBorder(Void)
   {
      var _loc6_ = _global.styles[this.className];
      if(_loc6_ == undefined)
      {
         _loc6_ = _global.styles.RectBorder;
      }
      var _loc5_ = this.getStyle(this.borderStyleName);
      var _loc7_ = this.getStyle(this.borderColorName);
      if(_loc7_ == undefined)
      {
         _loc7_ = _loc6_[this.borderColorName];
      }
      var _loc8_ = this.getStyle(this.backgroundColorName);
      if(_loc8_ == undefined)
      {
         _loc8_ = _loc6_[this.backgroundColorName];
      }
      var _loc16_ = this.getStyle("backgroundImage");
      var _loc14_;
      var _loc13_;
      var _loc12_;
      var _loc11_;
      var _loc10_;
      if(_loc5_ != "none")
      {
         _loc14_ = this.getStyle(this.shadowColorName);
         if(_loc14_ == undefined)
         {
            _loc14_ = _loc6_[this.shadowColorName];
         }
         _loc13_ = this.getStyle(this.highlightColorName);
         if(_loc13_ == undefined)
         {
            _loc13_ = _loc6_[this.highlightColorName];
         }
         _loc12_ = this.getStyle(this.buttonColorName);
         if(_loc12_ == undefined)
         {
            _loc12_ = _loc6_[this.buttonColorName];
         }
         _loc11_ = this.getStyle(this.borderCapColorName);
         if(_loc11_ == undefined)
         {
            _loc11_ = _loc6_[this.borderCapColorName];
         }
         _loc10_ = this.getStyle(this.shadowCapColorName);
         if(_loc10_ == undefined)
         {
            _loc10_ = _loc6_[this.shadowCapColorName];
         }
      }
      this.offset = this.borderWidths[_loc5_];
      var _loc9_ = this.offset;
      var _loc3_ = this.width;
      var _loc4_ = this.height;
      this.clear();
      this._color = undefined;
      var _loc15_;
      if(_loc5_ != "none")
      {
         if(_loc5_ == "inset")
         {
            this._color = this.colorList;
            this.draw3dBorder(_loc11_,_loc12_,_loc7_,_loc13_,_loc14_,_loc10_);
         }
         else if(_loc5_ == "outset")
         {
            this._color = this.colorList;
            this.draw3dBorder(_loc11_,_loc7_,_loc12_,_loc14_,_loc13_,_loc10_);
         }
         else if(_loc5_ == "alert")
         {
            _loc15_ = this.getStyle("themeColor");
            this.drawRoundRect(0,5,_loc3_,_loc4_ - 5,5,6184542,10);
            this.drawRoundRect(1,4,_loc3_ - 2,_loc4_ - 5,4,[6184542,6184542],10,0,"radial");
            this.drawRoundRect(2,0,_loc3_ - 4,_loc4_ - 2,3,[0,14342874],100,0,"radial");
            this.drawRoundRect(2,0,_loc3_ - 4,_loc4_ - 2,3,_loc15_,50);
            this.drawRoundRect(3,1,_loc3_ - 6,_loc4_ - 4,2,16777215,100);
         }
         else if(_loc5_ == "default")
         {
            this.drawRoundRect(0,5,_loc3_,_loc4_ - 5,{tl:5,tr:5,br:0,bl:0},6184542,10);
            this.drawRoundRect(1,4,_loc3_ - 2,_loc4_ - 5,{tl:4,tr:4,br:0,bl:0},[6184542,6184542],10,0,"radial");
            this.drawRoundRect(2,0,_loc3_ - 4,_loc4_ - 2,{tl:3,tr:3,br:0,bl:0},[12897484,11844796],100,0,"radial");
            this.drawRoundRect(3,1,_loc3_ - 6,_loc4_ - 4,{tl:2,tr:2,br:0,bl:0},16777215,100);
         }
         else if(_loc5_ == "dropDown")
         {
            this.drawRoundRect(0,0,_loc3_ + 1,_loc4_,{tl:4,tr:0,br:0,bl:4},[13290186,7895160],100,-10,"linear");
            this.drawRoundRect(1,1,_loc3_ - 1,_loc4_ - 2,{tl:3,tr:0,br:0,bl:3},16777215,100);
         }
         else if(_loc5_ == "menuBorder")
         {
            _loc15_ = this.getStyle("themeColor");
            this.drawRoundRect(4,4,_loc3_ - 2,_loc4_ - 3,0,[6184542,6184542],10,0,"radial");
            this.drawRoundRect(4,4,_loc3_ - 1,_loc4_ - 2,0,6184542,10);
            this.drawRoundRect(0,0,_loc3_ + 1,_loc4_,0,[0,14342874],100,250,"linear");
            this.drawRoundRect(0,0,_loc3_ + 1,_loc4_,0,_loc15_,50);
            this.drawRoundRect(2,2,_loc3_ - 3,_loc4_ - 4,0,16777215,100);
         }
         else if(_loc5_ != "comboNonEdit")
         {
            this.beginFill(_loc7_);
            this.drawRect(0,0,_loc3_,_loc4_);
            this.drawRect(1,1,_loc3_ - 1,_loc4_ - 1);
            this.endFill();
            this._color = this.borderColorName;
         }
      }
      if(_loc8_ != undefined)
      {
         this.beginFill(_loc8_);
         this.drawRect(_loc9_,_loc9_,this.width - _loc9_,this.height - _loc9_);
         this.endFill();
      }
   }
   function draw3dBorder(c1, c2, c3, c4, c5, c6)
   {
      var _loc3_ = this.width;
      var _loc2_ = this.height;
      this.beginFill(c1);
      this.drawRect(0,0,_loc3_,_loc2_);
      this.drawRect(1,0,_loc3_ - 1,_loc2_);
      this.endFill();
      this.beginFill(c2);
      this.drawRect(1,0,_loc3_ - 1,1);
      this.endFill();
      this.beginFill(c3);
      this.drawRect(1,_loc2_ - 1,_loc3_ - 1,_loc2_);
      this.endFill();
      this.beginFill(c4);
      this.drawRect(1,1,_loc3_ - 1,2);
      this.endFill();
      this.beginFill(c5);
      this.drawRect(1,_loc2_ - 2,_loc3_ - 1,_loc2_ - 1);
      this.endFill();
      this.beginFill(c6);
      this.drawRect(1,2,_loc3_ - 1,_loc2_ - 2);
      this.drawRect(2,2,_loc3_ - 2,_loc2_ - 2);
      this.endFill();
   }
   static function classConstruct()
   {
      mx.core.ext.UIObjectExtensions.Extensions();
      _global.styles.rectBorderClass = mx.skins.halo.RectBorder;
      _global.skinRegistry.RectBorder = true;
      return true;
   }
}
