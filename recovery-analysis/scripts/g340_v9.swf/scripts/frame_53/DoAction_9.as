function makeWorld(startAtMid)
{
   if(_root.world)
   {
      Key.removeListener(_root.world);
   }
   gList.enemies = new Array();
   gList.katras = new Array();
   gList.actorList = [];
   var w = _root.createEmptyMovieClip("world",gDepths.world);
   gList.clearAll.push(w);
   gList.actorList.push(w);
   w.onKeyDown = function()
   {
      if(Key.getCode() == 80)
      {
         _root.setPause();
      }
   };
   w.init = function()
   {
      trace("Hey");
      var _loc9_ = 2;
      var _loc3_ = 0;
      var _loc4_ = 0;
      var _loc10_ = this.attachMovie("gameBBG","bbg_" + _loc4_,gDepths.bbg);
      var _loc8_ = this.attachMovie("gameBG","bg_" + _loc4_,gDepths.bg);
      _loc8_.mcExtends(ScrollingBGClass,_loc3_,0,_root.eLevel.show());
      gDepths.bg++;
      var _loc7_ = this.attachMovie("gameFG","fg_" + _loc4_,gDepths.fg);
      _loc7_.mcExtends(ScrollingBGClass,_loc3_,0,10);
      gDepths.fg++;
      _loc3_ += 600;
      var _loc5_ = this.attachMovie("gameBG","bg_" + _loc4_,gDepths.bg);
      _loc5_.mcExtends(ScrollingBGClass,_loc3_,0,_root.eLevel.show());
      _loc5_._x = _loc3_;
      var _loc6_ = this.attachMovie("gameFG","fg_" + _loc4_,gDepths.fg);
      _loc6_.mcExtends(ScrollingBGClass,_loc3_,0,10);
      _loc6_._x = _loc3_;
   };
   w.init();
   Key.removeListener(w);
   Key.addListener(w);
   w.paused = 0;
   var map = eval("map" + _root.eLevel.show());
   w.map = map;
   w.tileWidth = map.tileWidth;
   w.tileHeight = map.tileHeight;
   w.grid = map.grid;
   w.maxRows = w.grid.length;
   w.maxCols = w.grid[0].length;
   trace("# cols: " + w.maxCols);
   w.startTime = 0;
   w.maxTime = 54;
   if(startAtMid)
   {
      w.currentCol = w.maxCols / 2;
   }
   else
   {
      w.currentCol = -1;
   }
   w.currentMode = 0;
   w.thisRock = undefined;
   w.timer = function()
   {
      if(++this.startTime == this.maxTime)
      {
         trace("Hello");
         var modDepth = gDepths.enemyBoss + gDepths.enemyBossNum % 100;
         if(this.thisRock == undefined)
         {
            this.thisRock = this.attachMovie("fallRock","fallRock",modDepth);
            this.thisRock._x = random(550);
            this.thisRock.mcExtends(gFallRock,99);
         }
         if(this.thisRock._y > 400)
         {
            this.thisRock.removeMovieClip();
            this.thisRock = undefined;
         }
         this.startTime = 0;
         this.currentCol++;
         trace("COL: " + this.currentCol);
         if(this.currentCol >= this.maxCols and gList.enemies.length == 0)
         {
            this.currentMode = 1;
            if(_root.world.player.dead == 0)
            {
               if(_root.eLevel.show() == _root.eMaxLevels.show())
               {
                  var pType = "gameCleared";
               }
               else
               {
                  var pType = "endRound";
               }
               _root.makePrompt(pType);
            }
            this.onEnterFrame = undefined;
         }
         var y = 0;
         while(y < this.maxRows)
         {
            var gridLoc = this.grid[y][this.currentCol][0].layer0;
            var linkage = gridLoc.look.mc;
            if(linkage != undefined)
            {
               var mcLook = gridLoc.look.mc;
               var quantity = gridLoc.quantity;
               var gBehavior = gridLoc.behavior;
               var pSpeed = gBehavior.speedOffset;
               var pFire = gBehavior.fireOffset;
               var pFireRand = gBehavior.randomFire;
               var pHit = gBehavior.hitsOffset;
               var pType = gBehavior.subClass;
               var typeObj = gBehavior.cType;
               var pat = gBehavior.pattern;
               var loopCount = gBehavior.looping;
               if(quantity > 1)
               {
                  var group = this["enemyGroup_" + gDepths.enemyGroupNum] = new Array();
                  gDepths.enemyGroupNum++;
               }
               var q = 0;
               while(q < quantity)
               {
                  if(typeObj == "enemy")
                  {
                     var modDepth = gDepths.enemy + gDepths.enemyNum % 100;
                     var mcEnemy = this.attachMovie("enemy","enemy" + gDepths.enemyNum,modDepth);
                     var en = this["enemy" + gDepths.enemyNum];
                     group.push(en);
                     var qNum = q + 1;
                     var en_x = this.bounds.xMax + qNum * this.tileWidth + en.sizer._width / 2;
                     var en_y = y * this.tileWidth + this.bounds.yMin + en.sizer._height / 2;
                     var en_type = eval(pType);
                     en.mcExtends(eval(pType),this,mcLook,pSpeed,pFire,pFireRand,pHit,en_x,en_y,group,pat,loopCount);
                     if(en_y > 350)
                     {
                        mcEnemy.remove();
                     }
                     gDepths.enemyNum++;
                  }
                  else if(typeObj == "Katra")
                  {
                     var modDepth = gDepths.katras + gDepths.katraNum % 50;
                     this.attachMovie(mcLook,"katra" + gDepths.katraNum,modDepth);
                     var k = this["katra" + gDepths.katraNum];
                     var k_x = this.bounds.xMax + qNum * this.tileWidth;
                     var k_y = y * this.tileWidth + this.bounds.yMin;
                     var kInfo = gridLoc.info;
                     kInfo_name = kInfo.tName;
                     kInfo_desc = kInfo.tVal;
                     k.mcExtends(gKatra,this.scrollSpeed,pType,k_x,k_y,kInfo_name,kInfo_desc);
                     gDepths.katraNum++;
                  }
                  q++;
               }
            }
            y++;
         }
      }
   };
   w.onEnterFrame = w.timer;
   _root.makeScoreboard();
   var b = w.bounds = _root.bg.getBounds(_root);
   trace("!!!" + w.bounds.yMax);
   b.yMax = 330;
   w.bounds.yMax = 330;
   b.yMin = w.sb._height;
   b.centerX = b.xMax / 2;
   b.centerY = b.yMax / 2;
   b.lastCol = b.xMax - w.tileWidth;
   b.lastRow = b.yMax - b.yMin;
   w.scrollSpeed = _root.eLevel.show();
   var numStrips = 5;
   var max = 6;
   w.endGame = function()
   {
      this.thisRock.removeMovieClip();
      this.thisRock = undefined;
      trace("WORLD.ENDGAME()");
      Key.removeListener(this);
   };
}
