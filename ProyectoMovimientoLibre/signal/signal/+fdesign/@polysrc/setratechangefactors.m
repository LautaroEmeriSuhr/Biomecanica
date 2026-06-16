function setratechangefactors(this, ratechangefactors)
%SETRATECHANGEFACTORS   Set the ratechangefactors.

%   Copyright 2005 The MathWorks, Inc.

this.InterpolationFactor = ratechangefactors(1);
this.DecimationFactor = ratechangefactors(2);

% [EOF]
