function y = upsample(x,N,phase) %#codegen
%MATLAB Code Generation Library Function

% Limitations:
%   N must be bounded in order for the size of Y to be bounded.  Hence, you
%   may:
%   1. Define N as a constant in the calling function
%   2. Declare N constant in the compilation using emlcoder.egc
%   3. Assert that N is bounded in the calling function (e.g. assert(N<10) )

%   Copyright 1988-2010 The MathWorks, Inc.

eml_lib_assert(...
    nargin>1,  ...
    'signal:upsample:notEnoughInputs', ...
    'Not enough input arguments.');

if nargin<3
    phase = 0;
end
% 0<=phase<N, and N must be bounded
eml_prefer_const(N, phase);

% Validate x
eml_lib_assert(...
    isnumeric(x),...
    'signal:upsample:MustBeNumeric',...
    'X must be numeric.');

% Validate upsample factor N
eml_lib_assert(...
    isnumeric(N) && ...
    isscalar(N) && ...
    (fix(N) == N) && ...
    (N > 0), ...
    'signal:upsample:BadUpsample',...
    'Upsample factor must be a positive integer.');

% Validate phase
if nargin<3
    phase = 0;
end
eml_lib_assert(...
    isnumeric(phase) && ...
    isscalar(phase) && ...
    (fix(phase) == phase) && ...
    (phase >= 0) && ...
    (phase <= N-1), ...
    'signal:upsample:BadPhase',...
    'Offset must be an integer from 0 to N-1.');

NInt = cast(N,eml_index_class);
phaseInt = cast(phase,eml_index_class);
dim = eml_nonsingleton_dim(x);
vlenx = cast(size(x,dim),eml_index_class);
npages = eml_matrix_npages(x,dim);
vleny = eml_index_times(NInt,vlenx);

% No coder.nullcopy for y because it needs the intermediate values need to be
% filled with zeros.
y = allocate_output_array(x,dim,vleny,npages);
% Carry out the up sampling.
xstart = ones(eml_index_class);
ystart = ones(eml_index_class);
for i = 1:npages
    % Input vector is
    %     x(xstart:xstart+vlenx-1)
    % Output vector is
    %     y((ystart+phase):N:ystart+vleny-1)
    %
    % Basically, this is
    %     y(phase:N:end, :) = x;
    % along dimension dim.
    ix = xstart;
    iy = eml_index_plus(ystart,phaseInt);
    for k = 1:vlenx
        y(iy) = x(ix);
        ix = eml_index_plus(ix,1);
        iy = eml_index_plus(iy,NInt);
    end
    xstart = eml_index_plus(xstart,vlenx);
    ystart = eml_index_plus(ystart,vleny);
end

function y = allocate_output_array(x,dim,len,npages)
% Allocate output array, assuming DIM is the leading non-singleton
% dimension, LEN is the length of the output array in that dimension, and
% NPAGES is the size of the DIM+1 dimension.  NPAGES is ignored if dim ==
% eml_ndims(x) (because NPAGES should be 1 in that case).
eml_prefer_const(dim,len,npages);
sz = size(x);
sz(dim) = len;
y = eml_expand(eml_scalar_eg(x),sz);
