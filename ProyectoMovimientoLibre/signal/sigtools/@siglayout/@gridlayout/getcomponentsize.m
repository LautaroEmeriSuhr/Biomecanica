function [m, n] = getcomponentsize(this, indx, jndx)
%GETCOMPONENTSIZE   Get the componentsize.

%   Author(s): J. Schickler
%   Copyright 1988-2004 The MathWorks, Inc.

g = get(this, 'Grid');

h = g(indx, jndx);

if isnan(h)
    m = 0;
    n = 0;
else
    m = max(find(g(:, jndx) == h)) - indx + 1;
    n = max(find(g(indx,:) == h))  - jndx + 1;
end

if nargout < 2
    m = [m n];
end

% [EOF]
