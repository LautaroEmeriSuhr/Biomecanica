function b = isequivalent(this, htest)
%ISEQUIVALENT   True if the object is equivalent.

%   Copyright 2005 The MathWorks, Inc.

if isa(htest, class(this)) && ...
        strcmpi(this.Response, htest.Response) && ...
        isequal(this.getratechangefactors, htest.getratechangefactors),
    b = isequivalent(this.CurrentFDesign, htest.CurrentFDesign);
else
    b = false;
end

% [EOF]
