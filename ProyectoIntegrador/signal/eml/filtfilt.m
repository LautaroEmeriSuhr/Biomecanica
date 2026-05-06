function y_out = filtfilt(b,a,x_in) %#codegen
%MATLAB Code Generation Library Function

% Limitations for Y = FILTFILT(B,A,X)
%   Inputs B, A must be const.  Output ZI will be const.
%   Input X must not vary its size or complexity at a given call site.
    
%   Copyright 1988-2010 The MathWorks, Inc.
    
    coder.extrinsic('sigprivate');
    
    eml_lib_assert(nargin==3,...
                   'signal:filtfilt:nargchk',...
                   'FILTFILT requires 3 inputs');
    
    eml_lib_assert(isa(b,'double') && isa(a,'double') && isa(x_in,'double'),...
                   'signal:filtfilt:inputNotDouble',...
                   'Inputs must be double-precision values.');

    eml_lib_assert(eml_is_const(b) && eml_is_const(a),...
                   'signal:filtfilt:coefficientsNotConst',...
                   'The numerator coefficients B and denominator coefficients A must be constant.');

    [m,n] = size(x_in);
    if m==1
        x = x_in(:);   % convert row to column
    else
        x = x_in;
    end
    len = size(x,1);   % length of input
    
    nb = length(b);
    na = length(a);
    nfilt = max(nb,na);
    nfilt = coder.internal.const(nfilt);
    
    if (isempty(b) || isempty(a) || isempty(x))
        y_out = [];
        return
    end

    if (n>1) && (m>1)
        y_out = x;
        for i=1:n  % Recurse over columns
            y_out(:,i) = filtfilt(b,a,x(:,i));
        end
        return
    end


    nfact = 3*(nfilt-1);  % length of edge transients

    eml_lib_assert(len>nfact, ...
                   'signal:filtfilt:InvalidDimensions',...
                   'Data must have length more than 3 times filter order.');

    
    zi = sigprivate('filtfilt_initial_conditions',b,a);
    zi = coder.internal.const(zi);
    % Extrapolate beginning and end of data sequence using a "reflection
    % method".  Slopes of original and extrapolated sequences match at
    % the end points.
    % This reduces end effects.
    y = [2*x(1)-x((nfact+1):-1:2);x;2*x(len)-x((len-1):-1:len-nfact)];

    % filter, reverse data, filter again, and reverse data again
    y = filter(b,a,y,zi*y(1));
    y = flipud(y);
    y = filter(b,a,y,zi*y(1));
    y = flipud(y);

    % remove extrapolated pieces of y
    if m == 1
        % convert back to row if necessary
        y_out = y(nfact+1:(len+nfact)).';
    else
        y_out = y(nfact+1:(len+nfact));
    end
end
