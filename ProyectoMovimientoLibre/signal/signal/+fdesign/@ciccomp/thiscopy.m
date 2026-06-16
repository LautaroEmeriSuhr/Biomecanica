function thiscopy(this, hOldObject)
%THISCOPY Copy properties specific to the fdesign.ciccomp class.

%   Copyright 2005-2011 The MathWorks, Inc.

this.DifferentialDelay = hOldObject.DifferentialDelay;
this.NumberOfSections = hOldObject.NumberOfSections;
this.CICRateChangeFactor = hOldObject.CICRateChangeFactor;

% [EOF]
