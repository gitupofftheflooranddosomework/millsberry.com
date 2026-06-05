if(Math.abs(speed) > 0.5)
{
   setContent(this._y + Math.floor(speed));
   speed *= _parent.decelRate;
   gotoAndPlay(2);
}
