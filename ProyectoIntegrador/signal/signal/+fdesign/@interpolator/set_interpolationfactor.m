function interpolationfactor = set_interpolationfactor(this, interpolationfactor)
%SET_INTERPOLATIONFACTOR   PreSet function for the 'interpolationfactor' property.

%   Copyright 2005 The MathWorks, Inc.

this.privInterpolationFactor = interpolationfactor;

updatecurrentfdesign(this);

% [EOF]
