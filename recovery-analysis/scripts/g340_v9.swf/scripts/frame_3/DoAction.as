_global.character = function(name, linkage, offense, defense, speed, biography)
{
   this.name = name;
   this.linkage = linkage;
   this.offense = offense;
   this.defense = defense;
   this.speed = speed;
   this.bio = biography;
};
_global.gCharOne = new character("Captain Gundam","captain",9,10,6,_root.charBiography.Captain);
_global.gCharTwo = new character("Zero The Winged Knight","zero",6,6,10,_root.charBiography.Zero);
_global.gCharThree = new character("Bakunetsumaru The Blazing Samurai","samurai",10,6,7,_root.charBiography.Bakunetsumaru);
_root.selectedChar = gCharOne;
_root.characterSelected = 0;
