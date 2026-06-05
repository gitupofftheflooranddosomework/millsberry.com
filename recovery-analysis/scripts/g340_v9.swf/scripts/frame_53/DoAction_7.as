_global.gFallRock = function(x)
{
   this.init(x);
};
var rock = gFallRock.prototype;
rock.init = function(x)
{
   trace("Move");
   this.dieing = false;
};
rock.main = function()
{
   this._y += 3;
   if(this.hitTest(_root.world.player.sizer) && !this.dieing)
   {
      _root.world.player.die();
      this.dieing = true;
   }
};
rock.onEnterFrame = rock.main;
