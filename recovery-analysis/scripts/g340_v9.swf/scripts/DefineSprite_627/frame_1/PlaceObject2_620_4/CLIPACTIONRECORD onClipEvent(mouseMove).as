onClipEvent(mouseMove){
   if(dragging)
   {
      setContent(_parent._ymouse - mouseOffset);
   }
   lastMouse = currMouse;
   currMouse = _parent._ymouse;
   updateAfterEvent();
}
