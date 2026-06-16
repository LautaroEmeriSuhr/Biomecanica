function [hMenu, hButtons] = render_uimgraudiotoolbar
%RENDER_UIMGRBASICAUDIOMENUTOOLBAR Create UIMGR-based objects of basic 
%   audio toolbar buttons and menu items.
%   [HMENU, HBUTTONS] = RENDER_UIMGRBASICAUDIOTOOLBAR uses the
%   Signal Processing Toolbox UIMGR package to plugin a new toolbar and 
%   a menu with play, pause, and stop buttons and menu items that will 
%   operate on an audioplayer object.
%   

%   Copyright 1984-2012 The MathWorks, Inc.

% Play callbacks
fcns = menus_cbs;
      
% Play toolbar uimgr objects
icons = load('uiscope_icons');
tooltips = {'Play',...
            'Pause',...
            'Stop'};

tags = {'play',...
        'pause',...
        'stop'};

bPlay = uimgr.spctoggletool('Play');
bPlay.IconAppData = 'play_off';
bPlay.setWidgetPropertyDefault(...
    'ClickedCallback',fcns.play_cb,...
    'Tag', tags{1},...
    'Tooltips',  tooltips{1});

bPause = uimgr.spctoggletool('Pause');
bPause.IconAppData = 'pause_default';
bPause.Enable = 'off';
bPause.setWidgetPropertyDefault(...
    'ClickedCallback',fcns.pause_cb,...
    'Tag', tags{2},...
    'Tooltips',  tooltips{2});

bStop = uimgr.spctoggletool('Stop');
bStop.IconAppData = 'stop_default';
bStop.Enable = 'off';
bStop.setWidgetPropertyDefault(...
    'ClickedCallback',fcns.stop_cb,...
    'Tag', tags{3},...
    'Tooltips',  tooltips{3});

hButtons = uimgr.uibuttongroup('Playbuttons', 0.5, bPlay, bPause, bStop);
setappdata(hButtons, icons);
hButtons.SelectionConstraint = 'SelectZeroOrOne';

% Playback menus uimgr objects
mPlay = uimgr.spctogglemenu('Play', '&Play');
mPlay.setWidgetPropertyDefault('Callback', fcns.play_cb);
    
mPause = uimgr.spctogglemenu('Pause', 'P&ause');
mPause.setWidgetPropertyDefault('Callback', fcns.pause_cb);

mStop = uimgr.spctogglemenu('Stop', '&Stop');
mStop.setWidgetPropertyDefault('Callback', fcns.stop_cb);
    
mPause.Enable = 'off';
mStop.Enable = 'off';
hMenugroup = uimgr.uimenugroup('Playmenus', mPlay, mPause, mStop);
hMenugroup.SelectionConstraint = 'SelectZeroOrOne';
hMenu = uimgr.uimenugroup('Playback', 0.5, '&Playback');
hMenu.add(hMenugroup);
sync2way(hMenugroup,hButtons);

end % render_uimgraudiotoolbar
% [EOF]
