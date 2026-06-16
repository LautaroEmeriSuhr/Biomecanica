function band = set_band(this, band)
%SET_BAND   PreSet function for the 'band' property.

%   Copyright 2005 The MathWorks, Inc.

if band <= 1,
    error(message('signal:fdesign:abstracttypewband:set_band:invalidBand'));
end

this.privBand = band;

% Make sure that the current specifications are up to date based on the new
% value of the band property.
updatecurrentspecs(this);

% If the band property exists on the new specifications, set it.
if isprop(this.CurrentSpecs, 'Band')
    this.CurrentSpecs.Band = band;
end

% [EOF]
