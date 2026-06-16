function decimationfactor = set_decimationfactor(this, decimationfactor)
%SET_DECIMATIONFACTOR  PreSet function for the 'decimationfactor' property.

%   Copyright 2005 The MathWorks, Inc.

this.privDecimationFactor = decimationfactor;

updatecurrentfdesign(this);

% [EOF]
