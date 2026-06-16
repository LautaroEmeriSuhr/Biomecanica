function  [yout, h] = resample( x, p_in, q_in, varargin )
%MATLAB Code Generation Library Function
    
% Limitations: 
%  X must not vary its size or complexity at a given call site.
%  All inputs after X must be constant.

% Copyright 2009-2010 The MathWorks, Inc.
%#codegen    
    coder.extrinsic('rat');
    coder.extrinsic('sigprivate');
    eml_lib_assert(nargin>=3, 'signal:resample:notEnoughInputs', 'Not enough input arguments.');
    eml_lib_assert(nargin<=5, 'signal:resample:tooManyInputs',   'Too many input arguments.');
    % Validate X
    eml_lib_assert(isa(x,'double'),...
                   'signal:resample:inputNotDouble',...
                   'Input must be a double-precision matrix.');
    % Validate P
    eml_lib_assert(eml_is_const(p_in),...
                   'signal:resample:pNotConst',...
                   'The upsample factor P must be constant.');
    eml_lib_assert(isa(p_in,'double'), 'signal:resample:pNotDouble', ...
                   'The upsample factor P must be a double-precision matrix.');
    eml_lib_assert(coder.internal.isPosIntScalar(p_in),...
                   'signal:resample:invalidP',...
                   'The upsample factor P must be a positive whole number.');
    % Validate Q
    eml_lib_assert(eml_is_const(q_in),...
                   'signal:resample:qNotConst',...
                   'The downsample factor Q must be constant.');
    eml_lib_assert(isa(q_in,'double'), 'signal:resample:qNotDouble', ...
                   'The downsample factor Q must be a double-precision matrix.');
    eml_lib_assert(coder.internal.isPosIntScalar(q_in),...
                   'signal:resample:invalidQ',...
                   'The downsample factor Q must be a positive whole number.');
    [p,q] = rat(p_in/q_in, 1e-12); %--- reduce to lowest terms 
    p = coder.internal.const(p);
    q = coder.internal.const(q);
    if (p==1) && (q==1)
        yout = x; 
        h = 1;
        return
    end

    if nargin<4
        % RESAMPLE(X,P,Q)
        N = 10;
        bta = 5;
        [h,L] = design_filter(p,q,N,bta);
        h = coder.internal.const(h);
        L = coder.internal.const(L);
    else
        if length(varargin{1})>1
            % RESAMPLE(X,P,Q,H,...)
            h = varargin{1};
            L = length(h);
        else
            % RESAMPLE(X,P,Q,N,...)
            N = varargin{1};
            if nargin<5
                bta = 5;
            else
                % RESAMPLE(X,P,Q,N,BTA)
                bta = varargin{2};
            end
            [h,L] = design_filter(p,q,N,bta);
            h = coder.internal.const(h);
            L = coder.internal.const(L);
        end
    end

    Lx = size(x, coder.internal.constNonSingletonDim(x));

    % Validate H
    eml_lib_assert(eml_is_const(h),...
                   'signal:resample:hNotConst',...
                   'The filter H must be constant.');
    eml_lib_assert(isa(h,'double') && length(size(h))==2 && (size(h,1)==1 || size(h,2)==1),...
                   'signal:resample:invalidFilter',...
                   'The filter H must be a double-precision vector.');

    % Zero pad the front (nz) so that downsampling by q hits center tap of
    % filter, and the back (nz1) so output length is exactly ceil(Lx*p/q)
    % "delay" is the number of samples removed from beginning of output sequence
    % to compensate for delay of linear phase filter
    [nz,nz1,delay] = sigprivate('resample_zero_pad_lengths',p,q,Lx,L);
    nz = coder.internal.const(nz);
    nz1 = coder.internal.const(nz1);
    delay = coder.internal.const(delay);
    hh = [zeros(1,nz) h(:).' zeros(1,nz1)];

    % The original h is output, but the padded hh is passed to upfirdn
    y = upfirdn(x,hh,p,q);

    % Get rid of trailing and leading data so input and output signals line
    % up temporally:
    Ly = ceil(Lx*p/q);  % output length
    if isvector(x)
        yout = y(delay+1:delay+Ly);
    else
        yout = y(delay+1:delay+Ly,:);
    end

end

%--------------------------------------------------------------------------

function [h,L] = design_filter(p,q,N,bta)
    if( N==0 )
        L = p;
        h = ones(1,p);
    else
        % Validate N
        eml_lib_assert(eml_is_const(N),...
                       'signal:resample:nNotConst',...
                       'The number of terms N must be constant.');
        eml_lib_assert(coder.internal.isPosIntScalar(N),...
                       'signal:resample:invalidN',...
                       'The number of terms N must be a positive integer.');
        % Validate BTA
        eml_lib_assert(eml_is_const(bta),...
                       'signal:resample:betaNotConst',...
                       'The design parameter for the Kaiser window BETA must be constant.');
        eml_lib_assert(isa(bta,'double') && length(size(bta))==2 && (size(bta,1)==1 && size(bta,2)==1),...
                       'signal:resample:invalidBeta',...
                       'The design parameter for the Kaiser window BETA must be a double-precision scalar.');
        pqmax = max(p,q);
        pqmax = coder.internal.const(pqmax);
        fc = 1/2/pqmax;
        fc = coder.internal.const(fc);
        L = 2*N*pqmax + 1;
        L = coder.internal.const(L);
        h = firls( L-1, [0 2*fc 2*fc 1], [1 1 0 0]).*kaiser(L,bta)';
        h = p * h/sum(h);
        h = coder.internal.const(h);
    end
end

