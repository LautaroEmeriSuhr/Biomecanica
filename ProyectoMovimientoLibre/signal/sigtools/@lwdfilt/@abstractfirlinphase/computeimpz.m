function [I, T] = impz(this, varargin)
%IMPZ   Calculate the impulse response.

%   Author(s): J. Schickler
%   Copyright 1988-2004 The MathWorks, Inc.

[I, T] = impz(this.Numerator, 1, varargin{:});

% [EOF]
