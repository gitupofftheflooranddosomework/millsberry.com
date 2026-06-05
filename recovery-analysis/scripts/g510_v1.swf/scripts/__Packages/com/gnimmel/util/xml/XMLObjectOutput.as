class com.gnimmel.util.xml.XMLObjectOutput
{
   var nameProp;
   function XMLObjectOutput(objNameProp)
   {
      if(objNameProp == true)
      {
         this.nameProp = true;
      }
      else
      {
         this.nameProp = false;
      }
   }
   function XMLToObject(xmlObj)
   {
      var _loc2_ = new Object();
      var _loc4_;
      if(xmlObj instanceof XML || xmlObj instanceof XMLNode)
      {
         _loc2_.__error = false;
         _loc4_ = !(xmlObj instanceof XML) ? xmlObj : xmlObj.firstChild;
         this.buildObj(_loc4_,_loc2_);
         return _loc2_;
      }
      _loc2_.__error = true;
      _loc2_.__errorMsg = "Wrong type passed into XMLToObject method";
      return _loc2_;
   }
   function traceObject(objToTrace, objName)
   {
      objName = String(objName != undefined ? objName + " " : "Object: ");
      trace(objName + " " + objToTrace);
      this.trObj(objToTrace," |-- ");
   }
   function buildObj(currNode, currObj)
   {
      var _loc8_;
      var _loc3_;
      var _loc9_;
      var _loc2_;
      var _loc6_;
      var _loc4_;
      if(currNode.nodeType == 1)
      {
         _loc8_ = currNode.childNodes.length;
         _loc3_ = currNode.firstChild;
         _loc9_ = currObj[currNode.nodeName];
         if(_loc9_ == undefined)
         {
            currObj[currNode.nodeName] = new Object();
            _loc2_ = currObj[currNode.nodeName];
         }
         else if(_loc9_ instanceof Array)
         {
            _loc9_.push(new Object());
            _loc2_ = currObj[currNode.nodeName][_loc9_.length - 1];
         }
         else
         {
            currObj[currNode.nodeName] = new Array(_loc9_);
            currObj[currNode.nodeName].push(new Object());
            _loc2_ = currObj[currNode.nodeName][currObj[currNode.nodeName].length - 1];
         }
         _loc6_ = currNode.attributes;
         for(var _loc10_ in _loc6_)
         {
            if(_loc2_.attributes == undefined)
            {
               _loc2_.attributes = new Object();
            }
            _loc2_.attributes[_loc10_] = _loc6_[_loc10_];
         }
         if(this.nameProp)
         {
            _loc2_.nodeName = currNode.nodeName;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc8_)
         {
            if(_loc3_.nodeType == 1)
            {
               _loc2_[_loc3_.nodeName] = this.buildObj(_loc3_,_loc2_);
               _loc3_ = _loc3_.nextSibling;
            }
            else
            {
               _loc2_.value = _loc3_.nodeValue;
            }
            _loc4_ = _loc4_ + 1;
         }
         return currObj[currNode.nodeName];
      }
      currObj.value = currNode.nodeValue;
   }
   function trObj(obj, spacer)
   {
      var _loc5_;
      var _loc0_;
      var _loc4_;
      if(obj instanceof Array)
      {
         _loc5_ = 0;
         while(_loc5_ < obj.length)
         {
            if((_loc0_ = true) !== obj[_loc5_] instanceof Object)
            {
               trace(spacer + "[" + _loc5_ + "]" + ": " + obj[_loc5_]);
            }
            else
            {
               _loc4_ = "      " + spacer;
               trace(spacer + "[" + _loc5_ + "]" + " [object]");
               this.trObj(obj[_loc5_],_loc4_);
            }
            _loc5_ = _loc5_ + 1;
         }
      }
      else
      {
         for(_loc5_ in obj)
         {
            switch(true)
            {
               case obj[_loc5_] instanceof Array:
                  _loc4_ = "      " + spacer;
                  trace(spacer + _loc5_ + " [array]");
                  this.trObj(obj[_loc5_],_loc4_);
                  break;
               case obj[_loc5_] instanceof Object:
                  _loc4_ = "      " + spacer;
                  trace(spacer + _loc5_ + " [object]");
                  this.trObj(obj[_loc5_],_loc4_);
                  break;
               default:
                  trace(spacer + _loc5_ + ": " + obj[_loc5_]);
            }
         }
      }
   }
}
