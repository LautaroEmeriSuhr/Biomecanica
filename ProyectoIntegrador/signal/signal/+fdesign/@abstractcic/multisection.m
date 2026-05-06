function varargout = multisection(this, varargin)
%DESIGN   Design the CIC filter.

%   Copyright 2005 The MathWorks, Inc.

[varargout{1:nargout}] = privdesigngateway(this, 'multisection',...
    this.DifferentialDelay, varargin{:});

% [EOF]
