function setspecs(this,combtype,varargin)
%SETSPECS Set the specs

%   Copyright 2008 The MathWorks, Inc.

if nargin < 2
    return;
end

%set combtype in fdesign
if isequal('notch', lower(combtype))
    this.CombType = 'Notch';
elseif isequal('peak', lower(combtype))
    this.CombType = 'Peak';
else
    error(message('signal:fdesign:comb:setspecs:InvalidCombType'));
end

%Send the combtype as another argument in varargin so that it is set in
%fspecs
varargin{end+1} = combtype;
this_setspecs(this, varargin{:});

% [EOF]
