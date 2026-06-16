function measureconstructor = getmeasureconstructor(this)
%GETMEASURECONSTRUCTOR   Get the measureconstructor.

%   Copyright 2005 The MathWorks, Inc.

if strcmpi(this.Type,'Lowpass'),
    measureconstructor = 'fdesign.lowpassmeas';
elseif strcmpi(this.Type,'Highpass'),
    measureconstructor = 'fdesign.highpassmeas';
end

% [EOF]
