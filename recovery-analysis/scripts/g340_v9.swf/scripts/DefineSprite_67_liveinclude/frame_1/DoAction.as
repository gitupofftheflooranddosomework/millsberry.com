this.loadBios = function()
{
   this.url = "http://images.neopets.com/games/utilities/flash_bios/bios.swf";
   System.security.allowDomain("neopets.com");
   this.bios.loadMovie(this.url);
};
