class mx.skins.CustomBorder extends mx.skins.Border
{
   var __height;
   var __width;
   var l_mc;
   var m_mc;
   var minHeight;
   var minWidth;
   var r_mc;
   var setSkin;
   static var symbolName = "CustomBorder";
   static var symbolOwner = mx.skins.CustomBorder;
   static var version = "2.0.2.126";
   var className = "CustomBorder";
   static var tagL = 0;
   static var tagM = 1;
   static var tagR = 2;
   var idNames = new Array("l_mc","m_mc","r_mc");
   var leftSkin = "F3PieceLeft";
   var middleSkin = "F3PieceMiddle";
   var rightSkin = "F3PieceRight";
   var horizontal = true;
   function CustomBorder()
   {
      super();
   }
   function get width()
   {
      return this.__width;
   }
   function get height()
   {
      return this.__height;
   }
   function init(Void)
   {
      super.init();
   }
   function createChildren(Void)
   {
   }
   function draw(Void)
   {
      var _loc2_;
      if(this.l_mc == undefined)
      {
         _loc2_ = this.setSkin(mx.skins.CustomBorder.tagL,this.leftSkin);
         if(this.horizontal)
         {
            this.minHeight = this.l_mc._height;
            this.minWidth = this.l_mc._width;
         }
         else
         {
            this.minHeight = this.l_mc._height;
            this.minWidth = this.l_mc._width;
         }
      }
      if(this.m_mc == undefined)
      {
         this.setSkin(mx.skins.CustomBorder.tagM,this.middleSkin);
         if(this.horizontal)
         {
            this.minHeight = this.m_mc._height;
            this.minWidth += this.m_mc._width;
         }
         else
         {
            this.minHeight += this.m_mc._height;
            this.minWidth = this.m_mc._width;
         }
      }
      if(this.r_mc == undefined)
      {
         this.setSkin(mx.skins.CustomBorder.tagR,this.rightSkin);
         if(this.horizontal)
         {
            this.minHeight = this.r_mc._height;
            this.minWidth += this.r_mc._width;
         }
         else
         {
            this.minHeight += this.r_mc._height;
            this.minWidth = this.r_mc._width;
         }
      }
      this.size();
   }
   function size(Void)
   {
      this.l_mc.move(0,0);
      if(this.horizontal)
      {
         this.r_mc.move(this.width - this.r_mc.width,0);
         this.m_mc.move(this.l_mc.width,0);
         this.m_mc.setSize(this.r_mc.x - this.m_mc.x,this.m_mc.height);
      }
      else
      {
         this.r_mc.move(0,this.height - this.r_mc.height,0);
         this.m_mc.move(0,this.l_mc.height);
         this.m_mc.setSize(this.m_mc.width,this.r_mc.y - this.m_mc.y);
      }
   }
}
