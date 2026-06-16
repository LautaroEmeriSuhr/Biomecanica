function defaulttw(this,band)
%DEFAULTTW   

%   Copyright 2005 The MathWorks, Inc.

if band>5,
    this.TransitionWidth = .5/band;
end


% [EOF]
