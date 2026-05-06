function visible_listener(hDlg, eventStruct)
%VISIBLE_LISTENER Listener to the Visible property

%   Author(s): J. Schickler
%   Copyright 1988-2002 The MathWorks, Inc.

visState = get(hDlg,'Visible');
hFig     = get(hDlg,'FigureHandle');

if strcmpi(visState, 'off'),
    
    % If the dialog is becoming invisible, destroy the warnings
    deletewarnings(hDlg);
end

set(hFig,'Visible',visState);

% [EOF]
