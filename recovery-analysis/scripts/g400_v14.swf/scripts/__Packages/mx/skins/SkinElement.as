class mx.skins.SkinElement extends MovieClip
{
   function SkinElement()
   {
      super();
   }
   static function registerElement(name, className)
   {
      Object.registerClass(name,className != undefined ? className : mx.skins.SkinElement);
      _global.skinRegistry[name] = true;
   }
   function __set__visible(visible)
   {
      this._visible = visible;
   }
   function move(x, y)
   {
      this._x = x;
      this._y = y;
   }
   function setSize(w, h)
   {
      this._width = w;
      this._height = h;
   }
}
