function updatefdesignfactors(this)
%UPDATEFDESIGNFACTORS   Update the CurrentFDesign ratechange factors.

%   Copyright 2005-2008 The MathWorks, Inc.

decimationfactor = this.DecimationFactor;

if isprop(this.CurrentFDesign, 'DecimationFactor')
    this.CurrentFDesign.DecimationFactor = decimationfactor;
end

% [EOF]
