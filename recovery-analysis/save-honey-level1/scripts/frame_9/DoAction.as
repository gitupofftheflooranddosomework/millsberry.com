panel_score_mc._visible = false;
if(_root.honeyloader.GAMESCORE.show() <= 0)
{
   MC_Panel_Lost.btn_submit._visible = false;
}
new mx.transitions.Tween(MC_Panel_Lost,"_y",mx.transitions.easing.Regular.easeInOut,Stage.height,MC_Panel_Lost._y,1,true);
