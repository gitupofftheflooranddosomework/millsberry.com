class gs.plugins.AutoAlphaPlugin extends gs.plugins.TweenPlugin
{
   var _alphaChange;
   var _alphaStart;
   var _target;
   var _tween;
   var _tweenAlpha;
   var _tweenVisible;
   var _visible;
   var onComplete;
   var overwriteProps;
   var propName;
   static var VERSION = 1;
   static var API = 1;
   function AutoAlphaPlugin()
   {
      super();
      this.propName = "autoAlpha";
      this.overwriteProps = ["_alpha","_visible"];
      this.onComplete = this.onCompleteTween;
   }
   function onInitTween($target, $value, $tween)
   {
      this._target = $target;
      this._tween = $tween;
      this._visible = Boolean($value != 0);
      this._tweenVisible = true;
      this._alphaStart = this._target._alpha;
      this._alphaChange = typeof $value != "number" ? Number($value) : $value - this._alphaStart;
      this._tweenAlpha = Boolean(this._alphaChange != 0);
      return true;
   }
   function killProps($lookup)
   {
      super.killProps($lookup);
      this._tweenVisible = Boolean($lookup._visible == undefined);
      this._tweenAlpha = Boolean($lookup._alpha == undefined);
   }
   function onCompleteTween()
   {
      if(this._tweenVisible && this._tween.vars.runBackwards != true && this._tween.ease == this._tween.vars.ease)
      {
         this._target._visible = this._visible;
      }
   }
   function set changeFactor($n)
   {
      if(this._tweenAlpha)
      {
         this._target._alpha = this._alphaStart + this._alphaChange * $n;
      }
      if(this._target._visible != true && this._tweenVisible)
      {
         this._target._visible = true;
      }
   }
}
