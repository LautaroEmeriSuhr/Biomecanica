function y = datawrap(x,nfft) 
%MATLAB Code Generation Library Function

% Copyright 2009-2010 The MathWorks, Inc.
%#codegen

eml_lib_assert(nargin>1,  'signal:datawrap:notEnoughInputs', 'Not enough input arguments.');

eml_lib_assert(isa(x,'double') && isvector(x), ...
               'signal:datawrap:InvalidInput', ...
               'Input signal must be a double-precision vector.');
eml_lib_assert(eml_is_const(nfft),'signal:datawrap:nfftNotConst','NFFT must be constant.');
eml_lib_assert(isa(nfft,'numeric') && isscalar(nfft) && isreal(nfft) && nfft >= 1 && nfft == floor(nfft),...
               'signal:datawrap:invalidNFFT',...
               'NFFT must be a positive numeric scalar.');
eml_lib_assert(nfft <= intmax(eml_index_class), ...
               'signal:datawrap:nfftExceedsIntmax', ...
               ['NFFT exceeds intmax(' eml_index_class ').']);


% Reshape into multiple columns (data segments) of length nfft.
% If insufficient data points are available, zeros are appended.
% This is equivalent to b = buffer(x,nfft).
%
% Then sum across the columns (data segments) if necessary.
nx = size(x, 2);
n = length(x);
if n==nfft
    % Trivial case.  Don't need to do anything.
    y = x;
elseif n<nfft
    % Zero-pad vector, keep same orientation.  
    % Don't need to sum.
    % Don't need to reshape at the end.
    if nx==1
        % Column vector
        y = [x; zeros(nfft-n,1)];
    else
        % Row vector
        y = [x zeros(1,nfft-n)];
    end
else
    % n>nfft
    % Zero-pad to a multiple of nfft
    % Reshape to nfft-by-...
    % Sum across the columns (data segments).
    m = nfft * ceil(n/nfft); % first multiple of nfft bigger than n;
    b = reshape([x(:); zeros(m-n,1)],nfft,m/nfft);
    if nx==1
        % Column vector
        sz = [nfft 1];
    else
        % Row vector
        sz = [1 nfft];
    end
    if isreal(x)
        y = coder.nullcopy(zeros(sz,class(x)));
    else
        y = coder.nullcopy(complex(zeros(sz,class(x))));
    end
    y(:) = sum(b,2);
end
    

