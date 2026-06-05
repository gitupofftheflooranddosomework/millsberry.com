Object.registerClass("FocusManager",mx.managers.FocusManager);
if(_root.focusManager == undefined)
{
   _root.createClassObject(mx.managers.FocusManager,"focusManager",mx.managers.DepthManager.highestDepth--);
}
