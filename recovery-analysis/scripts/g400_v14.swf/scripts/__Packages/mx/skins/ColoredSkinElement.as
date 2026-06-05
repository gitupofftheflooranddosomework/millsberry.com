class mx.skins.ColoredSkinElement
{
   var _color;
   var getStyle;
   var onEnterFrame;
   static var mixins = new mx.skins.ColoredSkinElement();
   function ColoredSkinElement()
   {
   }
   function setColor(c)
   {
      var _loc2_;
      if(c != undefined)
      {
         _loc2_ = new Color(this);
         _loc2_.setRGB(c);
      }
   }
   function draw(Void)
   {
      this.setColor(this.getStyle(this._color));
      this.onEnterFrame = undefined;
   }
   function invalidateStyle(Void)
   {
      this.onEnterFrame = this.draw;
   }
   static function setColorStyle(p, colorStyle)
   {
      if(p._color == undefined)
      {
         p._color = colorStyle;
      }
      p.setColor = mx.skins.ColoredSkinElement.mixins.setColor;
      p.invalidateStyle = mx.skins.ColoredSkinElement.mixins.invalidateStyle;
      p.draw = mx.skins.ColoredSkinElement.mixins.draw;
      p.setColor(p.getStyle(colorStyle));
   }
}
