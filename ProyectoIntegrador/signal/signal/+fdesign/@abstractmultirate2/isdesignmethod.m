function b = isdesignmethod(this, varargin)
%ISDESIGNMETHOD   True if the object is designmethod.

%   Copyright 2005 The MathWorks, Inc.

b = isdesignmethod(this.CurrentFDesign, varargin{:});

% [EOF]
