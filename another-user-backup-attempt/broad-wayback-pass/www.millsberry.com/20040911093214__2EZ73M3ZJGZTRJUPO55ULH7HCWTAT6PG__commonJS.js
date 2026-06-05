/*
  openWin() pops up a destination window of whatever dimensions with or without the window controls.
*/
var view_win  = null;
var extraArgs = '';
function openWin(page, winWidth, winHeight, showTools)
{
  var props;
  if (showTools == true)
    props = 'width='+winWidth+',height='+winHeight+','+'scrolling=yes,scroll=yes,scrollbars=yes,resizable=yes,toolbar=yes';
  else
    props = 'width='+winWidth+',height='+winHeight+','+'scrolling=no,scroll=no,scrollbars=no,resizable=no,toolbar=no';
  if (page.indexOf('?') == -1)
    extraArgs = '?width='+winWidth+'&height='+winHeight;
  else
    extraArgs = '&width='+winWidth+'&height='+winHeight;
  if (view_win)
    view_win.close();
  view_win = window.open(page+extraArgs, 'newwin_id', props);
  view_win.focus();
}