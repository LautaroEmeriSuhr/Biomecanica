function varargout = thisdesignmethods(this, varargin)
%THISDESIGNMETHODS   Return the valid design methods.

%   Copyright 2005 The MathWorks, Inc.

[varargout{1:nargout}] = ...
    currentfdesigndesignmethods(this.CurrentFDesign, ...
        varargin{:});
    


% [EOF]
