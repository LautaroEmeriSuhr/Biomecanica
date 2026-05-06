function [props, descs] = abstractgetbuttonprops(h)
%ABSTRACT_GETBUTTONPROPS

%   Author(s): J. Schickler
%   Copyright 1988-2002 The MathWorks, Inc.

p = find(h.classhandle.properties, '-not', 'Description', '');

if isempty(p),
    props = {};
    descs = {};
else
    props = get(p, 'Name');
    descs = get(p, 'Description');
end

% [EOF]
