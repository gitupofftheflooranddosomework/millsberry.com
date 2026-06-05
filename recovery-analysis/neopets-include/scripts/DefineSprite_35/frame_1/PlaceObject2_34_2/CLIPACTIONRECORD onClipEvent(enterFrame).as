onClipEvent(enterFrame){
   if(this.changed)
   {
      var tf = _parent._parent.textbox2.text1;
      var p = int((this._y - 4) / 0.42);
      tf.scroll = Math.round((tf.maxscroll + 1) / 100 * p);
   }
}
