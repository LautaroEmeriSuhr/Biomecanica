function P = get_values(h,dummy)
%GETVARIABLENAMES GetFunction for the VariableNames property.

%   Author(s): P. Costa
%   Copyright 1988-2003 The MathWorks, Inc.

lvh = getcomponent(h, '-class', 'siggui.labelsandvalues');
P = get(lvh,'Values');

% [EOF]
