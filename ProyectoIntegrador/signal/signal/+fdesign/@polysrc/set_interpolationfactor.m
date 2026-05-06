function interpolationfactor = set_interpolationfactor(this, interpolationfactor)
%SET_INTERPOLATIONFACTOR   PreSet function for the 'interpolationfactor' property.

%   Copyright 2007 The MathWorks, Inc.

this.privInterpolationFactor = interpolationfactor;

if isprop(this.CurrentSpecs, 'privInterpolationFactor')
    this.CurrentSpecs.privInterpolationFactor = interpolationfactor;
end

% [EOF]
