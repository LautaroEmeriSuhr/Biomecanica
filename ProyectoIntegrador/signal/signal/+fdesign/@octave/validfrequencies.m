function f = validfrequencies(this)
%VALIDFREQUENCIES  Return the valid values for the 'CenterFreq' property.

%   Copyright 2006 The MathWorks, Inc.

f = getvalidcenterfrequencies(this.CurrentSpecs);
if this.NormalizedFrequency,
    f = f/24000;
end

% [EOF]
