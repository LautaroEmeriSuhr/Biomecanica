function updatefdesignfactors(this)
%UPDATEFDESIGNFACTORS   Update the CurrentFDesign rate change factors.

%   Copyright 2005-2008 The MathWorks, Inc.

interpfactor = this.InterpolationFactor;
decimfactor  = this.DecimationFactor;

if isprop(this.CurrentFDesign, 'DecimationFactor')
    this.CurrentFDesign.DecimationFactor = decimfactor;
end
if isprop(this.CurrentFDesign, 'InterpolationFactor')
    this.CurrentFDesign.InterpolationFactor = interpfactor;
end

% [EOF]
