function hm = measure(this, Hd, varargin)
%MEASURE   Measure this object.

%   Copyright 2005-2010 The MathWorks, Inc.

% Measure is only available to DSP System Toolbox license holders
supercheckoutfdtbxlicense(this)

narginchk(2,inf);

if isempty(getfdesign(Hd))
    Hd = copy(Hd);
    setfdesign(Hd,this);
end

hm = feval(getmeasureconstructor(this), Hd, this, varargin{:});

% [EOF]
