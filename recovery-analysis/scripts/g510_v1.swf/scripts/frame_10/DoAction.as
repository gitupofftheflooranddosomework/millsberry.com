stop();
com.racing.MB8Controller.init();
var loader = new com.gnimmel.LoadManager();
this.createEmptyMovieClip("main",57);
var path = this != _level0 ? _level100.include._MB8_GAME_DATA.FG_GAME_BASE + "flashgames/racing/main.swf" : "racing/main.swf";
loader.AddAsset("swf",path,main);
loader.StartLoadSequence();
