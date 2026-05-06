function y_out = upfirdn(x_in,varargin)
%MATLAB Code Generation Library Function

% Limitations for Y = UPFIRDN(X, H, P, Q)
%   X must not vary its size or complexity at a given call site.
%   H must be a vector.
%   H, P, and Q must be const.

% Copyright 2009-2014 The MathWorks, Inc.
%#codegen    

% This function requires DSP System Toolbox
coder.extrinsic('license');
x = license('test','signal_blocks');
x = coder.internal.const(x);
coder.internal.errorIf(~x,'signal:isspblksinstalled:noDSP1','upfirdn');   

x = exist('dsp.FIRRateConverter','class');
x = coder.internal.const(x);
coder.internal.errorIf(~x,'signal:isspblksinstalled:noDSP1','upfirdn');   

    eml_lib_assert(nargin>0, 'signal:upfirdn:notEnoughInputs', 'Not enough input arguments.');
    eml_lib_assert(nargin<5, 'signal:upfirdn:tooManyInputs', 'Too many input arguments.');

    if nargin>=2, 
        h = varargin{1}; 
    else
        h = fir1(70,.25);
    end
    if nargin>=3
        p = varargin{2};
    else
        p = 1;
    end
    if nargin>=4
        q = varargin{3};
    else
        q = 1;
    end

    % Validate X
    eml_lib_assert(~isempty(x_in), 'signal:upfirdn:emptyInput', 'Input must not be empty.');
    eml_lib_assert(isa(x_in,'double'), 'signal:upfirdn:inputNotDouble', 'Input must be a double-precision matrix.');
    eml_lib_assert(ndims(x_in)==2, 'signal:upfirdn:nDimensionalInput', 'Input must be a vector or 2-dimensional matrix.');

    % Validate P
    eml_lib_assert(eml_is_const(p),...
                   'signal:upfirdn:pNotConst',...
                   'The upsample factor P must be constant.');
    eml_lib_assert(coder.internal.isPosIntScalar(p),...
                   'signal:upfirdn:invalidP',...
                   'The upsample factor P must be a positive whole number.');

    % Validate Q
    eml_lib_assert(eml_is_const(q),...
                   'signal:upfirdn:qNotConst',...
                   'The downsample factor Q must be constant.');
    eml_lib_assert(coder.internal.isPosIntScalar(q),...
                   'signal:upfirdn:invalidQ',...
                   'The downsample factor Q must be a positive whole number.');
    % Validate H
    eml_lib_assert(eml_is_const(h),...
                   'signal:upfirdn:hNotConst',...
                   'The filter H must be constant.');

    % If H is a matrix, then either X must be a vector or a matrix with the same number of columns as H.
    eml_lib_assert(~isempty(h) && isa(h,'double') && ndims(h)==2 && ...
                   (isvector(h) || ~isvector(h)&&isvector(x_in) || ~isvector(x_in) && size(h,2)==size(x_in,2)),...
                   'signal:upfirdn:invalidFilter',...
                   ['The filter H must be a double-precision vector, ',...
                    'or a matrix with vector input X, ',...
                    'or a matrix with the same number of columns as matrix input X.']);

    % Determine lengths and whether we need to orient the input into a column
    [m,n] = size(x_in);
    if m==1 && n>1
        row_vector = true;
        Lx = n;
        ncols = 1;
        x = x_in(:);  % FIRRateConverter wants a column vector
    else
        row_vector = false;
        Lx = m;
        ncols = n;
        x = x_in;
    end
    if isvector(h)
        Lh = length(h);
    else
        Lh = size(h,1);
    end

    % Append zeroes to x to match MATLAB behavior 
    % The S-component must have the length of the input a multiple of q.
    % The length of y may not match MATLAB because of the restriction of
    % the input of FIRRateConverter to be a multiple of q.
    %
    % Make the input size so that the output size is at least as big as the
    % toolbox version, then truncate the output if necessary.
    %
    % The length of the output Ly = length(y) is determined by the following
    % formula in function toolbox/signal/sigsrc/upfirdnmex.c:
    %    Lxup  = ((double)p*(double)(Lx-1) + Lh);
    %    Ly = (mwSize)((fmod(Lxup,(double)q)) ? Lxup/q + 1 : Lxup/q);
    Lxup = p*(Lx-1) + Lh;
    if mod(Lxup,q)==0
        Ly = Lxup/q;
    else
        Ly = floor(Lxup/q) + 1;
    end
    % The input x to FIRRateConverter is zero-padded so that its length is a
    % multiple of q, and the output length is greater-than-or-equal-to Ly as
    % computed above.  These conditions lead to the following formulas for
    % computing the number of zeros Lz to pad with.
    nz = max(ceil(Ly*q/p)-Lx, 0);
    modq = mod(Lx+nz,q);
    if modq==0
        % Lx+nz is a multiple of q
        Lz = nz;  
    else
        % Lx+nz is not a multiple of q, so add the difference that would
        % bring it up to a multiple of q.
        Lz = nz + q - modq;
    end

    if ~isvector(h) 
        % If H is a matrix, then recurse into this function as a loop on each column of H.
        if isreal(x_in) && isreal(h)
            y_out = coder.nullcopy(zeros(Ly,size(h,2)));
        else
            y_out = coder.nullcopy(complex(zeros(Ly,size(h,2))));
        end
        if isvector(x_in)
            % If X is a vector, then loop over each column of H, repeating X as a column
            for j=coder.unroll(1:size(h,2))
                % Need to unroll the loop, because each h(:,j) must be const.
                y_out(:,j) = upfirdn(x_in(:),h(:,j),p,q);
            end
        else
            % If X is also a matrix, then loop over each column of H and X
            for j=coder.unroll(1:size(h,2))
                % Need to unroll the loop, because each h(:,j) must be const.
                y_out(:,j) = upfirdn(x_in(:,j),h(:,j),p,q);
            end
        end
        return
    end        

    z = zeros(Lz,ncols);
    % Construct the S-Component
    s = dsp.FIRRateConverter('Numerator',h,...
                               'InterpolationFactor',p,...
                               'DecimationFactor',q);
    y = step(s,[x; z]);
    reset(s); % Clear states to match MATLAB behavior
    
    % Truncate the output to match the output of the builtin function
    if length(y)<=Ly
        if row_vector
            y_out = y.';        % Revert to row if x_in was a row vector
        else
            y_out = y;
        end
    else
        if row_vector
            y_out = y(1:Ly).';  % Revert to row if x_in was a row vector
        else
            y_out = y(1:Ly,:);
        end
    end
end
