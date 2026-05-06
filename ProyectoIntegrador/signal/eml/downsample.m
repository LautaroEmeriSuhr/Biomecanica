function y = downsample(x,N,phase) %#codegen
%MATLAB Code Generation Library Function

%   Copyright 1988-2010 The MathWorks, Inc.

eml_lib_assert(...
    nargin>1,  ...
    'signal:downsample:notEnoughInputs', ...
    'Not enough input arguments.');

if nargin<3
    phase = 0;
end
eml_prefer_const(N,phase);

% Validate x
eml_lib_assert(...
    isnumeric(x),...
    'signal:downsample:MustBeNumeric',...
    'X must be numeric.');

% Validate downsample factor N
eml_lib_assert(...
    isnumeric(N) && ...
    isscalar(N) && ...
    (fix(N) == N) && ...
    (N > 0), ...
    'signal:downsample:BadDownsample',...
    'Downsample factor must be a positive integer.');

% Validate phase
eml_lib_assert(...
    isnumeric(phase) && ...
    isscalar(phase) && ...
    (fix(phase) == phase) && ...
    (phase >= 0) && ...
    (phase <= N-1), ...
    'signal:downsample:BadPhase',...
    'Offset must be an integer from 0 to N-1.');

NInt = cast(N,eml_index_class);
phaseInt = cast(phase,eml_index_class);
dim = eml_nonsingleton_dim(x);
vlenx = cast(size(x,dim),eml_index_class);
npages = eml_matrix_npages(x,dim);
if eml_ambiguous_types
    % During size propagation, the eml_index_xxx functions will be doing double
    % precision arithmetic.  After size propagation (or when not in Simulink),
    % they'll return integers, so FLOOR is actually a no-op then.
    vleny = 1+floor((vlenx-phaseInt-1)/NInt);
else
    vleny = eml_index_plus(1,eml_index_rdivide(eml_index_minus(eml_index_minus(vlenx,phaseInt),1),NInt));
end
y = coder.nullcopy(allocate_output_array(x,dim,vleny,npages));
% Carry out the down sampling.
xstart = ones(eml_index_class);
ystart = ones(eml_index_class);
for i = 1:npages
    % Input vector is
    %     x(xstart:xstart+vlenx-1)
    % Output vector is
    %     x((xstart+phase):N:xstart+vlenx-1)
    % which is stored in
    %     y(ystart:ystart+vleny-1)
    %
    % Basically, this is
    %     y = x(phase:N:end,:)
    % along dimension dim.
    ix = eml_index_plus(xstart,phaseInt);
    iy = ystart;
    for k = 1:vleny
        y(iy) = x(ix);
        ix = eml_index_plus(ix,NInt);
        iy = eml_index_plus(iy,1);
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
assert(len <= size(x,dim));
sz = size(x);
sz(dim) = len;
y = eml_expand(eml_scalar_eg(x),sz);
