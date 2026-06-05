CR.addContent(yourscore_txt,"yourscore_txt",_level0.IDS_yourscore_txt);
CR.addContent(btn_restartgame,"btn_restartgame",_level0.IDS_restartgame_txt);
CR.addContent(btn_sendscore,"btn_sendscore",_level0.IDS_sendscore_txt);
CR.flushRegister();
this.scoreval_txt = _root.GAMESCORE.show();
KC.destroy();
delete KC;
stop();
