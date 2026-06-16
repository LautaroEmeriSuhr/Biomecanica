function k = scalingfactor(x,v,Tp)
%SCALINGFACTOR - returns the two scaling factors necessary for vector window preprocessor
% K=SCALINGFACTOR(X,V,TP) accepts the position and velocity of the initial vector
%   X(1) and V(1) and computes the necessary scaling factors to create a smoothed
%   transition to the target vector X(2) and V(2).

%   Author(s): A. Dowd
%   Copyright 1988-2002 The MathWorks, Inc.
if length(x) < 2,
    error(message('signal:scalingfactor:SignalErrX', 'X', '''x(0)''', '''x(1)'''));
elseif length(v) <2,
    error(message('signal:scalingfactor:SignalErrV', 'V', '''v(0)''', '''v(1)'''));
end
if ~isnumeric(x),
    error(message('signal:scalingfactor:MustBeNumericX', 'X'));
elseif ~isnumeric(v),
    error(message('signal:scalingfactor:MustBeNumericV', 'V'));
elseif ~isnumeric(Tp),
     error(message('signal:scalingfactor:MustBeNumericTP', 'TP')); 
end
k(1) = v(2) - v(1);
k(2) = x(2) - x(1) - ((v(2) + v(1))*Tp)/2;

% [EOF] scalingfactor.m
