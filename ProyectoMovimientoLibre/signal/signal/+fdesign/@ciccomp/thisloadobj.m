function thisloadobj(this, s)
%THISLOADOBJ Load this object.

%   Copyright 2005-2011 The MathWorks, Inc.

% Property added in R2011b
if ~isfield(s,'CICRateChangeFactor')
  s.CICRateChangeFactor = 1;
end

this.DifferentialDelay = s.DifferentialDelay;
this.NumberOfSections = s.NumberOfSections;
this.CICRateChangeFactor = s.CICRateChangeFactor;

% Inv sinc parameters are not tunable for CIC compensator filters
setinvsincparamstunableflag(this.CurrentSpecs,false);
    
% [EOF]
