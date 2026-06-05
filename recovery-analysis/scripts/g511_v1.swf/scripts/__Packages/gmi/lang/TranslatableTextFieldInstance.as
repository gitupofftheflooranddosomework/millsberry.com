class gmi.lang.TranslatableTextFieldInstance extends TextField
{
   var htmlText_str;
   var instance_str;
   var target;
   var embedFonts_boolean = false;
   var font_str = undefined;
   function TranslatableTextFieldInstance(tTextFieldInstanceOrString, tTarget)
   {
      super();
      this.setInstanceString(tTextFieldInstanceOrString);
      this.setTarget(tTarget);
      this.init();
      this.setEmbedFonts(this.getInstance().embedFonts);
      this.setFont(this.getInstance().getTextFormat().font);
   }
   function setTarget(tValue)
   {
      this.target = tValue;
   }
   function getTarget()
   {
      return this.target;
   }
   function setInstanceString(tValue)
   {
      tValue = String(tValue);
      var _loc3_;
      if(tValue.charAt(0) == "_")
      {
         _loc3_ = tValue.indexOf(".");
         tValue = tValue.substring(_loc3_ + 1);
      }
      this.instance_str = tValue;
   }
   function getInstanceString()
   {
      return this.instance_str;
   }
   function getInstance()
   {
      return eval(String(String(this.getTarget()) + "." + this.getInstanceString()));
   }
   function setEmbedFonts(tValue)
   {
      this.embedFonts_boolean = tValue;
      this.refresh();
   }
   function getEmbedFonts()
   {
      return this.embedFonts_boolean;
   }
   function setFont(tValue)
   {
      this.font_str = tValue;
      this.refresh();
   }
   function getFont()
   {
      return this.font_str;
   }
   function init()
   {
      this.getInstance().multiline = true;
      this.getInstance().selectable = false;
      this.getInstance().editable = false;
      this.getInstance().wordWrap = true;
      this.getInstance().border = false;
      this.getInstance().html = true;
   }
   function setHtmlText(tHtmlText_str)
   {
      this.htmlText_str = tHtmlText_str;
      this.refresh();
   }
   function getHtmlText()
   {
      return this.getInstance().htmlText;
   }
   function refresh()
   {
      this.getInstance().embedFonts = this.getEmbedFonts();
      this.getInstance().htmlText = this.htmlText_str;
      myformat = new TextFormat();
      myformat.font = this.getFont();
      this.getInstance().setTextFormat(myformat);
   }
}
