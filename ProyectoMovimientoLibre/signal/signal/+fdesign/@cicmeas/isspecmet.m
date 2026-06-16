function b = isspecmet(this, hspecs)
%ISSPECMET   True if the object is specmet.

%   Copyright 2005 The MathWorks, Inc.

if nargin < 2
    hspecs = this.Specification;
end

if this.Astop >= hspecs.Astop
    b = true;
else
    b = false;
end

% [EOF]
