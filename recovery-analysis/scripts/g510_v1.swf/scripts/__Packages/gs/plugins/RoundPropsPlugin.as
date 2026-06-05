class gs.plugins.RoundPropsPlugin extends gs.plugins.TweenPlugin
{
   var addTween;
   var overwriteProps;
   var propName;
   var round;
   static var VERSION = 1;
   static var API = 1;
   function RoundPropsPlugin()
   {
      super();
      this.propName = "roundProps";
      this.overwriteProps = [];
      this.round = true;
   }
   function add($object, $propName, $start, $change)
   {
      this.addTween($object,$propName,$start,$start + $change,$propName);
      this.overwriteProps[this.overwriteProps.length] = $propName;
   }
}
