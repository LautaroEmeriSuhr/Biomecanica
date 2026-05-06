function [A_out, E, K] = levinson(R_in, N_in)
%MATLAB Code Generation Library Function
    
% Limitations: 
% R must not vary its size or complexity at a given call site.
% N must be constant.

% Copyright 2009-2014 The MathWorks, Inc.
%#codegen    

% This function requires DSP System Toolbox
coder.extrinsic('license');
x = license('test','signal_blocks');
x = coder.internal.const(x);
coder.internal.errorIf(~x,'signal:isspblksinstalled:noDSP1','levinson');   

x = exist('dsp.LevinsonSolver','class');
x = coder.internal.const(x);
coder.internal.errorIf(~x,'signal:isspblksinstalled:noDSP1','levinson');   

    eml_lib_assert(nargin>=1, 'signal:levinson:notEnoughInputs', 'Not enough input arguments.');

    % Validate R
    eml_lib_assert(~isempty(R_in), 'signal:levinson:emptyInput', ...
                   'Input R must not be empty.');
    eml_lib_assert(isa(R_in,'double'), 'signal:levinson:inputNotDouble', ...
                   'Input R must be a double-precision array.');

    if isvector(R_in)
        Lr = length(R_in);
    else
        Lr = size(R_in, 1);
    end

    if Lr==1
        % If R is a scalar, then no computation takes place.
        % Set trivial outputs and exit.
        A_out = 1;
        E = R_in;
        K = zeros(0,1);
        return;
    end

    if nargin<2
        N_in = Lr - 1;
    end

    % Validate N
    eml_lib_assert(eml_is_const(N_in),...
                   'signal:levinson:nNotConst',...
                   'The order of recursion N must be constant.');
    eml_lib_assert(isa(N_in,'numeric') && isscalar(N_in) && isreal(N_in) && N_in >= 0,...
                   'signal:levinson:invalidN',...
                   'The order of recursion N must be a nonnegative numeric scalar.');
    eml_lib_assert(N_in <= intmax(eml_index_class), ...
                   'signal:levinson:NExceedsIntmax', ...
                   ['The order of recursion N exceeds intmax(' eml_index_class ').']);

    N = floor(N_in);  % This is to match MATLAB behavior accepting non-integer N.

    if N == 0
        % Trivial case.  No computation.  Set output and return.
        if isvector(R_in)
            R = R_in(1);
        else
            R = R_in;
        end
        E = R(1,:).';
        A_out = ones(size(E));
        K = zeros(0,length(E));
        return
    end

    if N < Lr-1
        if isvector(R_in)
            R = R_in(1:(N+1));
        else
            R = R_in(1:(N+1),:);
        end
    else
        if ndims(R_in)>2
            R = R_in(:,:); % Reshape to 2D for the System object
        else
            R = R_in;
        end
    end

    % The System object only operates down columns, so convert row input to
    % column. 
    if isvector(R) && size(R,1)==1
        R_by_columns = R(:);
    else
        R_by_columns = R;
    end

    s = dsp.LevinsonSolver('AOutputPort',true,...                
                               'KOutputPort',true,...               
                               'PredictionErrorOutputPort',true,... 
                               'ZerothLagZeroAction','Ignore');

    % Note that the order of the outputs of the System object differs from
    % the order of the outputs of the function.
    [A,K,E] = step(s,R_by_columns);

    A_out = A.'; % To match output orientation of Signal Toolbox function

end

