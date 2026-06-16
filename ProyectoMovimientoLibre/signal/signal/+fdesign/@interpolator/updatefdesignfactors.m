function updatefdesignfactors(this)
%UPDATEFDESIGNFACTORS   Update the current FDesign rate change factors.

%   Copyright 2005-2008 The MathWorks, Inc.

interpolationfactor = this.InterpolationFactor;

if isprop(this.CurrentFDesign, 'InterpolationFactor')
    this.CurrentFDesign.InterpolationFactor = interpolationfactor;
end

% [EOF]
