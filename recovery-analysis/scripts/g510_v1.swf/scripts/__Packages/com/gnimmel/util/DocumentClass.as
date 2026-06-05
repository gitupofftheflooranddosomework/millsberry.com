class com.gnimmel.util.DocumentClass
{
   function DocumentClass()
   {
   }
   static function init(document, docClass)
   {
      document.__proto__ = Function(docClass).prototype;
      Function(docClass).apply(document,null);
   }
}
