function [G, W] = grpdelay(this, N, varargin)
%GRPDELAY   Calculate the group delay.

%   Author(s): J. Schickler
%   Copyright 1988-2004 The MathWorks, Inc.

if nargin < 2
    N = 8192;
end

[G, W] = grpdelay(this.Numerator, this.Denominator, N, varargin{:});

% [EOF]
