function setspecs(this, M, varargin)
%SETSPECS   Set the specs.

%   Copyright 2005 The MathWorks, Inc.

if nargin > 1
    this.DifferentialDelay = M;
end

abstract_setspecs(this, varargin{:});

% [EOF]
