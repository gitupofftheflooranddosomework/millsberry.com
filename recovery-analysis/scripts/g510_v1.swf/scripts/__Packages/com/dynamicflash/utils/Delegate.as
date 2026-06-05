class com.dynamicflash.utils.Delegate
{
   function Delegate()
   {
   }
   static function create(target, handler)
   {
      var _loc4_ = arguments.slice(2);
      var _loc3_ = function()
      {
         var _loc2_ = arguments.callee;
         var _loc3_ = arguments.concat(_loc2_.extraArgs,[_loc2_]);
         return _loc2_.handler.apply(_loc2_.target,_loc3_);
      };
      _loc3_.extraArgs = _loc4_;
      _loc3_.handler = handler;
      _loc3_.target = target;
      return _loc3_;
   }
}
