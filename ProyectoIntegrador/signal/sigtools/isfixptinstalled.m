function [b, errstr, errid] = isfixptinstalled
%ISFIXPTINSTALLED   Returns true if fixedpoint is installed.

%   Author(s): J. Schickler
%   Copyright 1988-2012 The MathWorks, Inc.

%This is for the compiler - LICENSE and VER do not work for compiled
%applications so we need to check for the presence of the fixedpoint
%designer directory in the CTF root (compiled archived root)
if isdeployed
    dir_present = exist(fullfile(ctfroot,'toolbox','fixedpoint'));
    if (dir_present==7)
        b = true; errstr = ''; errid = '';
    else
        b = false;
        errstr = sprintf('%s\n%s', 'Fixed-Point Designer is not available.', ...
            'Make sure that it is installed and that a license is available.');
        errid  = 'noFixPt';
    end
else

    b = license('test', 'Fixed_Point_Toolbox') && ~isempty(ver('fixedpoint'));
    if b
        errstr = '';
        errid  = '';
    else
        errstr = sprintf('%s\n%s', 'Fixed-Point Designer is not available.', ...
            'Make sure that it is installed and that a license is available.');
        errid  = 'noFixPt';
    end
end

% [EOF]
