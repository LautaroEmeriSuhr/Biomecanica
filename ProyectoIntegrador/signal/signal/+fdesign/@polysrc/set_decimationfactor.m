function decimationfactor = set_decimationfactor(this, decimationfactor)
%SET_DECIMATIONFACTOR  PreSet function for the 'decimationfactor' property.

%   Copyright 2007 The MathWorks, Inc.

this.privDecimationFactor = decimationfactor;

if isprop(this.CurrentSpecs, 'privDecimationFactor')
    this.CurrentSpecs.privDecimationFactor = decimationfactor;
end

% [EOF]
