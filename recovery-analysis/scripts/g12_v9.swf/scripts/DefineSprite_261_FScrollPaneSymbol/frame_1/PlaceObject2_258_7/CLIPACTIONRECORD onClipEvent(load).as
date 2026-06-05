onClipEvent(load){
   if(this._parent.loadReady)
   {
      this._parent.contentLoaded();
      delete this._parent.loadReady;
   }
   else if(this._name != "loadContent")
   {
      this._parent.loadReady = true;
   }
}
