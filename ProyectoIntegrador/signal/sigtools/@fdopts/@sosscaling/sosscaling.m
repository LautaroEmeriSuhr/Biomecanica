function this = sosscaling(varargin)
%SOSSCALING   Construct a SOSSCALING object.

%   Author(s): R. Losada
%   Copyright 2003 The MathWorks, Inc.

this = fdopts.sosscaling;

% Set scale value mode to 'none' by default
this.ScaleValueConstraint = 'unit';

if length(varargin) > 0,
    set(this,varargin{:});
end

% [EOF]
