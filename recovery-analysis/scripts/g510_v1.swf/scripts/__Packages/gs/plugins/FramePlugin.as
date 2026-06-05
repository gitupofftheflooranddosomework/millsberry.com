class gs.plugins.FramePlugin extends gs.plugins.TweenPlugin
{
   var _target;
   var addTween;
   var frame;
   var overwriteProps;
   var propName;
   var round;
   var updateTweens;
   static var VERSION = 1;
   static var API = 1;
   function FramePlugin()
   {
      super();
      this.propName = "frame";
      this.overwriteProps = ["frame"];
      this.round = true;
   }
   function onInitTween($target, $value, $tween)
   {
      if(typeof $target != "movieclip" || isNaN($value))
      {
         return false;
      }
      this._target = MovieClip($target);
      this.addTween(this,"frame",this._target._currentframe,$value,"frame");
      return true;
   }
   function set changeFactor($n)
   {
      this.updateTweens($n);
      this._target.gotoAndStop(this.frame);
   }
}
