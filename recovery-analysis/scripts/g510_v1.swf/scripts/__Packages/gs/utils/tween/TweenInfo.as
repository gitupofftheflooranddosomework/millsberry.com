class gs.utils.tween.TweenInfo
{
   var change;
   var isPlugin;
   var name;
   var property;
   var start;
   var target;
   function TweenInfo($target, $property, $start, $change, $name, $isPlugin)
   {
      this.target = $target;
      this.property = $property;
      this.start = $start;
      this.change = $change;
      this.name = $name;
      this.isPlugin = $isPlugin;
   }
}
