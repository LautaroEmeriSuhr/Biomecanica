function defaultmethod = getdefaultmethod(this)
%GETDEFAULTMETHOD   Get the defaultmethod.

%   Copyright 2005 The MathWorks, Inc.

switch this.Specification,
    case 'N',
        defaultmethod = 'lagrange';
    otherwise,
        error(message('signal:fdesign:fracdelay:getdefaultmethod:InternalError'));
end


% [EOF]
