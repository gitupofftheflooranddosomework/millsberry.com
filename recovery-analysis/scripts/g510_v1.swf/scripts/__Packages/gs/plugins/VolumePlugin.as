class gs.plugins.VolumePlugin extends gs.plugins.TweenPlugin
{
   var _sound;
   var _tweens;
   var addTween;
   var overwriteProps;
   var propName;
   var updateTweens;
   var volume;
   static var VERSION = 1;
   static var API = 1;
   function VolumePlugin()
   {
      super();
      this.propName = "volume";
      this.overwriteProps = ["volume"];
   }
   function onInitTween($target, $value, $tween)
   {
      if(isNaN($value) || typeof $target != "movieclip" && !($target instanceof Sound))
      {
         return false;
      }
      this._sound = typeof $target != "movieclip" ? Sound($target) : new Sound($target);
      this.addTween(this,"volume",this._sound.getVolume(),$value,"volume");
      return Boolean(this._tweens.length != 0);
   }
   function set changeFactor($n)
   {
      this.updateTweens($n);
      this._sound.setVolume(this.volume);
   }
}
