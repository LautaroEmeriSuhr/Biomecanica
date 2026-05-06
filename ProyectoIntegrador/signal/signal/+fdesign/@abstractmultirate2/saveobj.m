function s = saveobj(this)
%SAVEOBJ   Save this object.

%   Copyright 2005 The MathWorks, Inc.

s.class      = class(this);
s.AllFDesign = this.AllFDesign;
s.Response   = this.Response;
s.ratechangefactors = getratechangefactors(this);

% [EOF]
