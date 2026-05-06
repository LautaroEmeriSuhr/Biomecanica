function d = designopts(this, varargin)
%DESIGNOPTS   

%   Copyright 2005 The MathWorks, Inc.

d = designopts(this.CurrentFDesign, varargin{:});

% Replace structure with multirate structure
switch d.FilterStructure,
    case 'dffir',
        d.FilterStructure = 'firsrc';
end


% [EOF]
