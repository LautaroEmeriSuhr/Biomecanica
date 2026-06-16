function [htoolbar, haudiobtns] = render_basicaudiotoolbar(h)
%RENDER_BASICAUDIOTOOLBAR Create a basic audio toolbar.
%   [HTOOLBAR, HBUTTONS] = RENDER_BASICAUDIOTOOLBAR(HFIG) creates a new
%   toolbar with play, pause, and stop buttons that will operate on an
%   audioplayer object.  A new toolbar will be added to the figure HFIG.
%   Handles to the new toolbar and array of pushbuttons are returned.
%
%   RENDER_BASICAUDIOTOOLBAR(HTOOLBAR) adds the audio buttons in sequence
%   to toolbar HTOOLBAR.  

%   Author(s): B. Wherry
%   Copyright 1984-2012 The MathWorks, Inc.

narginchk(1,1);

hType = get(h, 'Type');
% if h is the handle to a figure, add a new toolbar to it
if strcmp(hType, 'figure'),
    htoolbar = uitoolbar(h);
    set(htoolbar, 'Tag', 'BasicAudioToolbar');
% if h is the handle to a toolbar, add our toolbar buttons to it
elseif strcmp(hType, 'uitoolbar'),
    htoolbar = h;
% if h is something else, error
else
    error(message('signal:render_basicaudiotoolbar:GUIErr'));
end

% Load audio icons
icons = load('uiscope_icons');

% stick all the icons into app data for swapping in/out, etc.
setappdata(htoolbar, 'audioButtonIcons', icons);

pushbtns = {icons.play_off,...
            icons.pause_default,...
            icons.stop_default};

tooltips = {'Play',...
            'Pause',...
            'Stop'};

tags = {'play',...
        'pause',...
        'stop'};

sep = {'On','Off','Off'};

fcns = menus_cbs;

btncbs = {fcns.play_cb,...
          fcns.pause_cb,...
          fcns.stop_cb};

% Render the PushButtons
for i = 1:length(pushbtns),
   haudiobtns(i) = uipushtool('CData',pushbtns{i},...
        'Parent', htoolbar,...
        'ClickedCallback',btncbs{i},...
        'Tag',            tags{i},...
        'Separator',      sep{i},...
        'TooltipString',  tooltips{i});
end
