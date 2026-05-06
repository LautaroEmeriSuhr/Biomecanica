function [Px,w,Px0,wc] = periodogram(x,varargin)
%PERIODOGRAM  Power Spectral Density (PSD) estimate via periodogram method.
%   Pxx = PERIODOGRAM(X) returns the PSD estimate, Pxx, of a signal, X.
%   When X is a vector, it is converted to a column vector and treated as a
%   single channel.  When X is a matrix, the PSD is computed independently
%   for each column and stored in the corresponding column of Pxx.
%  
%   By default, the signal X is windowed with a rectangular window of the
%   same length as X. The PSD estimate is computed using an FFT of length
%   given by the larger of 256 and the next power of 2 greater than the
%   length of X.
%
%   Note that the default window (rectangular) has a 13.3 dB sidelobe
%   attenuation. This may mask spectral content below this value (relative
%   to the peak spectral content). Choosing different windows will enable
%   you to make tradeoffs between resolution (e.g., using a rectangular
%   window) and sidelobe attenuation (e.g., using a Hann window). See
%   windowDesigner for more details.
%
%   Pxx is the distribution of power per unit frequency. For real signals,
%   PERIODOGRAM returns the one-sided PSD by default; for complex signals,
%   it returns the two-sided PSD.  Note that a one-sided PSD contains the
%   total power of the input signal.
%
%   Pxx = PERIODOGRAM(X,WINDOW) specifies a window to be applied to X. If X
%   is a vector, WINDOW must be a vector of the same length as X.  If X is
%   a matrix, WINDOW must be a vector whose length is the same as the
%   number of rows of X.  If WINDOW is a window other than a rectangular,
%   the resulting estimate is a modified periodogram. If WINDOW is
%   specified as empty, the default window is used.
%
%   Pxx = PERIODOGRAM(X,WINDOW,...,SPECTRUMTYPE) uses the window scaling
%   algorithm specified by SPECTRUMTYPE when computing the power spectrum:
%     'psd'   - returns the power spectral density
%     'power' - scales each estimate of the PSD by the equivalent noise
%               bandwidth (in Hz) of the window.  Use this option to
%               obtain an estimate of the power at each frequency.
%   The default value for SPECTRUMTYPE is 'psd'
%
%   [Pxx,W] = PERIODOGRAM(X,WINDOW,NFFT) specifies the number of FFT points
%   used to calculate the PSD estimate.  For real X, Pxx has length
%   (NFFT/2+1) if NFFT is even, and (NFFT+1)/2 if NFFT is odd.  For complex
%   X, Pxx always has length NFFT.  If NFFT is specified as empty, the
%   default NFFT is used.
%
%   Note that if NFFT is greater than the length of WINDOW, the data is
%   zero-padded. If NFFT is less than the length of WINDOW, the segment is
%   "wrapped" (using DATAWRAP) to make the length equal to NFFT to produce
%   the correct FFT.
%
%   W is the vector of normalized frequencies at which the PSD is
%   estimated.  W has units of radians/sample.  For real signals, W spans
%   the interval [0,pi] when NFFT is even and [0,pi) when NFFT is odd.  For
%   complex signals, W always spans the interval [0,2*pi).
%
%   [Pxx,W] = PERIODOGRAM(X,WINDOW,W) computes the two-sided PSD at the
%   normalized angular frequencies contained in the vector W. W must have
%   at least two elements.
%
%   [Pxx,F] = PERIODOGRAM(X,WINDOW,NFFT,Fs) returns a PSD computed as
%   a function of physical frequency.  Fs is the sampling frequency
%   specified in hertz.  If Fs is empty, it defaults to 1 Hz.
%
%   F is the vector of frequencies (in hertz) at which the PSD is
%   estimated.  For real signals, F spans the interval [0,Fs/2] when NFFT
%   is even and [0,Fs/2) when NFFT is odd.  For complex signals, F always
%   spans the interval [0,Fs).
%
%   [Pxx,F] = PERIODOGRAM(X,WINDOW,F,Fs) computes the two-sided PSD at the 
%   frequencies contained in vector F. F must contain at least two elements
%   and be expressed in units of hertz.
%
%   [...] = PERIODOGRAM(X,WINDOW,NFFT,...,FREQRANGE) returns the PSD
%   over the specified range of frequencies based upon the value of
%   FREQRANGE:
%
%      'onesided' - returns the one-sided PSD of a real input signal X.
%         If NFFT is even, Pxx has length NFFT/2+1 and is computed over the
%         interval [0,pi].  If NFFT is odd, Pxx has length (NFFT+1)/2 and
%         is computed over the interval [0,pi). When Fs is specified, the
%         intervals become [0,Fs/2) and [0,Fs/2] for even and odd NFFT,
%         respectively.
%
%      'twosided' - returns the two-sided PSD for either real or complex
%         input X.  Pxx has length NFFT and is computed over the interval
%         [0,2*pi). When Fs is specified, the interval becomes [0,Fs).
%
%      'centered' - returns the centered two-sided PSD for either real or
%         complex X.  Pxx has length NFFT and is computed over the interval
%         (-pi, pi] for even length NFFT and (-pi, pi) for odd length NFFT.
%         When Fs is specified, the intervals become (-Fs/2, Fs/2] and
%         (-Fs/2, Fs/2) for even and odd NFFT, respectively.
%
%      FREQRANGE may be placed in any position in the input argument list
%      after WINDOW.  The default value of FREQRANGE is 'onesided' when X
%      is real and 'twosided' when X is complex.
%
%   [Pxx,F,Pxxc] = PERIODOGRAM(...,'ConfidenceLevel',P) , where P is a
%   scalar between 0 and 1, returns the P*100% confidence interval for Pxx.
%   The default value for P is .95.  Confidence intervals are computed
%   using a chi-squared approach.  Pxxc has twice as many columns as Pxx.
%   Odd-numbered columns contain the lower bounds of the confidence
%   intervals; even-numbered columns contain the upper bounds.  Thus,
%   Pxxc(M,2*N-1) is the lower bound and Pxxc(M,2*N) is the upper bound
%   corresponding to the estimate Pxx(M,N).
%   
%   [RPxx,F] = PERIODOGRAM(X,WINDOW,...,'reassigned') reassigns each PSD
%   estimate to the nearest frequency in F corresponding to the estimate's
%   center of gravity.  The reassigned estimates are summed together and
%   returned in RPxx.  If WINDOW is unspecified or an empty matrix, then a
%   Kaiser window will be used as the default window.
%
%   [RPxx,F,Pxx,Fc] = PERIODOGRAM(...,'reassigned') additionally returns
%   the original PSD estimates, Pxx, and their corresponding center 
%   frequencies, Fc. Note that the 'ConfidenceLevel' option cannot be used
%   in conjunction with reassignment.
%
%   PERIODOGRAM(...) with no output arguments by default plots the PSD
%   estimate (in decibels per unit frequency) in the current figure window.
%
%   % Example 1:
%   %    Compute the two-sided periodogram of a 200 Hz sinusoid embedded
%   %    in noise.
%   Fs = 1000;   t = 0:1/Fs:.3;
%   x = cos(2*pi*t*200)+randn(size(t));
%   periodogram(x,[],'twosided',512,Fs)
% 
%   % Example 2:
%   %   Compute the one-sided reassigned periodogram of a 200 Hz sinusoid 
%   %   embedded in noise.
%   Fs = 1000;   t = 0:1/Fs:.3;
%   x = cos(2*pi*t*200)+0.001*randn(size(t));
%   periodogram(x,[],512,Fs,'power','reassigned')
%
%   See also PWELCH, PBURG, PCOV, PYULEAR, PMTM, PMUSIC, PMCOV, PEIG.

%   Copyright 1988-2014 The MathWorks, Inc.

narginchk(1,10);

% look for psd, power, and ms window compensation flags
[esttype, varargin] = psdesttype({'psd','power','ms'},'psd',varargin);

if isvector(x)
    N = length(x); % Record the length of the data
else
    N = size(x,1);
end

% extract window argument
if ~isempty(varargin) && ~ischar(varargin{1})
    win = varargin{1};
    varargin = varargin(2:end);
else
    win = [];
end

% scan for options
[options,msg,msgobj] = periodogram_options(isreal(x),N,varargin{:});
if ~isempty(msg)
  error(msgobj)
end

if ~options.reassign    
    nargoutchk(0,3); 
end

% Generate a default window if needed
%   default window is rectangular of same size as input.
%   if 'reassigned' is specified, then a Kaiser window is used instead
winName = 'User Defined';
winParam = '';
if isempty(win)
    if options.reassign
        win = kaiser(N,38);
    else
        win = rectwin(N);
        winName = 'Rectangular';
        winParam = N;
    end
end

% Cast to enforce precision rules
if any([signal.internal.sigcheckfloattype(x,'single','periodogram','X')...
    signal.internal.sigcheckfloattype(win,'single','periodogram','WINDOW')]) 
  x = single(x);
  win = single(win);
end

Fs    = options.Fs;
nfft  = options.nfft;

% Compute the PS using periodogram over the whole Nyquist range.
[Sxx,w,RSxx,wc] = computeperiodogram(x,win,nfft,esttype,Fs,options);

% If frequency vector was specified, return and plot two-sided PSD
if length(nfft) > 1
    if (length(options.nfft)>1 && strcmpi(options.range,'onesided'))
        warning(message('signal:periodogram:InconsistentRangeOption'));
        options.range = 'twosided';
    end
end

% compute reassigned spectrum if needed.
if options.reassign
    RPxx = computepsd(RSxx,w,options.range,nfft,Fs,esttype);
    % Compute the one-sided corrected frequency vector for each component
    % of input signal
    wc = makeOnesidedWc(options.range,wc,nfft);
    % de-alias
    wc = dealiasWc(options,wc);
else
    RPxx = [];
    wc = [];
end

% Compute the 1-sided or 2-sided PSD [Power/freq] or mean-square [Power].
% Also, compute the corresponding freq vector & freq units.
[Pxx,w,units] = computepsd(Sxx,w,options.range,nfft,Fs,esttype);


% compute confidence intervals if needed.
if ~strcmp(options.conflevel,'omitted')
    Pxxc = confInterval(options.conflevel, Pxx, x, w, options.Fs);
elseif nargout>2 && ~options.reassign
    Pxxc = confInterval(0.95, Pxx, x, w, options.Fs);
else
    Pxxc = [];
end

if nargout==0 % Plot when no output arguments are specified
    plotPeriodogram(Pxx,w,Pxxc,RPxx,options,esttype,units,winName,winParam)
else
    if options.centerdc
        if options.reassign
            RPxx = psdcenterdc(RPxx, w, [], options);
            wc = centerWc(options,wc);
        end
        [Pxx, w, Pxxc] = psdcenterdc(Pxx, w, Pxxc, options);
    end
   
    % assign outputs in correct order
    if options.reassign
        % first and third output are reassigned and unnormalized power
        Px = RPxx;
        Px0 = Pxx;
    else
        % first and third output are normalized power and confidence
        % intervals
        Px = Pxx;
        Px0 = Pxxc;
    end

    % If the input is a vector and a row frequency vector was specified,
    % return output as a row vector for backwards compatibility.
    if size(options.nfft,2)>1 && isvector(x)
        Px = Px.';
        w = w.';
        if options.reassign
            Px0 = Px0.';
            wc = wc.';
        end
    end

    % Cast to enforce precision rules
    % Only case if output is requested, otherwise plot using double
    % precision frequency vector.
    if isa(Px,'single')
        w = single(w);
        if options.reassign
            wc = single(wc);
        end
    end
end

%------------------------------------------------------------------------------
function plotPeriodogram(Pxx,w,Pxxc,RPxx,options,esttype,units,winName,winParam) 

if options.reassign
    Px = RPxx;
else
    Px = Pxx;
end

w = {w};
if strcmpi(units,'Hz')
    w = [w, {'Fs',options.Fs}];
end

if strcmp(esttype,'psd')
    hdspdata = dspdata.psd(Px,w{:},'SpectrumType',options.range);
else
    hdspdata = dspdata.msspectrum(Px,w{:},'SpectrumType',options.range);
end

% plot the confidence levels if conflevel is specified.
if ~isempty(Pxxc)
    hdspdata.ConfLevel = options.conflevel;
    hdspdata.ConfInterval =  Pxxc;
end

% Create a spectrum object to store in the PSD object's metadata.
hspec = spectrum.periodogram({winName,winParam});
hdspdata.Metadata.setsourcespectrum(hspec);

if options.centerdc
    centerdc(hdspdata);
end
hLine = plot(hdspdata);

%Change the plot style to show the reassigned power
if options.reassign
     plotReassignedSpectrum(hLine,hdspdata);
end

% title the plot appropriately
if strcmp(esttype,'power')
    if options.reassign
        title(getString(message('signal:periodogram:ReassignedPeriodogramPowerSpectrumEstimate')));
    else
        title(getString(message('signal:periodogram:PeriodogramPowerSpectrumEstimate')));
    end
end

%------------------------------------------------------------------------------
function [options,msg,msgobj] = periodogram_options(isreal_x,N,varargin)
%PERIODOGRAM_OPTIONS   Parse the optional inputs to the PERIODOGRAM function.
%   PERIODOGRAM_OPTIONS returns a structure, OPTIONS, with following fields:
%
%   options.nfft         - number of freq. points at which the psd is estimated
%   options.Fs           - sampling freq. if any
%   options.range        - 'onesided' or 'twosided' psd
%   options.centerdc     - true if 'centered' specified

% Generate defaults
options.nfft = max(256, 2^nextpow2(N));
options.Fs = []; % Work in rad/sample

% extract and remove any 'reassigned' option from the argument list
[reassign,varargin] = getReassignmentOption(varargin{:});

options.reassign = reassign;

% Determine if frequency vector specified
freqVecSpec = false;
if (~isempty(varargin) && length(varargin{1}) > 1)
    freqVecSpec = true;
end

if isreal_x && ~freqVecSpec,
    options.range = 'onesided';
else
    options.range = 'twosided';
end

if any(strcmp(varargin, 'whole'))
    warning(message('signal:periodogram:invalidRange', 'whole', 'twosided'));
elseif any(strcmp(varargin, 'half'))
    warning(message('signal:periodogram:invalidRange', 'half', 'onesided'));
end

[options,msg,msgobj] = psdoptions(isreal_x,options,varargin{:});

% Cast to enforce precision rules
options.Fs = double(options.Fs);
options.nfft = double(options.nfft);

% ensure frequency vector is linearly spaced when performing reassignment
if reassign && ~isscalar(options.nfft)
  f = options.nfft(:);
  
  % see if we can get a uniform spacing of the freq vector
  [~, ~, ~, maxerr] = getUniformApprox(f);
  
  % see if the ratio of the maximum absolute deviation relative to the
  % largest absolute in the frequency vector is less than a few eps
  isuniform = maxerr < 3*eps(class(f));
  
  if ~isuniform
    error(message('signal:periodogram:ReassignFreqMustBeUniform'));
  end
end

%--------------------------------------------------------------------------
function [reassign,varargin] = getReassignmentOption(varargin)
% search for 'reassigned' flag and return true if present.
% error if 
reassign = false;
matchLoc = find(strncmpi('reassign',varargin,8));
if ~isempty(matchLoc)
    reassign = true;
    if(any(strcmpi('confidencelevel',varargin)))
        error(message('signal:psdoptions:ConflictingOptions', ...
                     varargin{matchLoc}, 'ConfidenceLevel'));
            
    end
% remove the reassignment option from varargin 
varargin(matchLoc) = [];
end

%--------------------------------------------------------------------------
function Pxxc = confInterval(CL, Pxx, x, w, fs)
%   Reference: D.G. Manolakis, V.K. Ingle and S.M. Kagon,
%   Statistical and Adaptive Signal Processing,
%   McGraw-Hill, 2000, Chapter 5

% Compute confidence intervals using double precision arithmetic
Pxx = double(Pxx);
x = double(x);

k = 1;
c = chi2conf(CL,k);
PxxcLower = Pxx*c(1);
PxxcUpper = Pxx*c(2);
Pxxc = reshape([PxxcLower; PxxcUpper],size(Pxx,1),2*size(Pxx,2));

% DC and Nyquist bins have only one degree of freedom for real signals
if isreal(x)
    realConf = chi2conf(CL,k/2);
    Pxxc(w == 0,1:2:end) = Pxx(w == 0,:) * realConf(1);
    Pxxc(w == 0,2:2:end) = Pxx(w == 0,:) * realConf(2);
    if isempty(fs)
        Pxxc(w == pi,1:2:end) = Pxx(w == pi,:) * realConf(1);
        Pxxc(w == pi,2:2:end) = Pxx(w == pi,:) * realConf(2);
    else
        Pxxc(w == fs/2,1:2:end) = Pxx(w == fs/2,:) * realConf(1);
        Pxxc(w == fs/2,2:2:end) = Pxx(w == fs/2,:) * realConf(2);
    end
end

%--------------------------------------------------------------------------
function plotReassignedSpectrum(hLine,hdspdata)

% fetch axes from line handle
if ~isempty(hLine)
   hAxes = ancestor(hLine(1),'axes');
else
   hAxes = gca;
end

% previous plot has x and y labels we wish to preserve
set(hAxes, 'NextPlot', 'replacechildren');

% obtain the lower limit from the previous plot
yLim = get(hAxes,'YLim');
lowLimit = yLim(1);

% extract frequency vector from original plot
FreqVector = hLine(1).XData(:);

% extract the data from the plot
logPower = 10*log10(hdspdata.Data);
stem(FreqVector,logPower,'BaseValue',lowLimit,'Marker','.');

% bound plot by y limit; give 10 extra dB.
yTick = get(hAxes,'YTick');
set(hAxes,'YLim',[yLim(1) yTick(end)+10]);

% Ensure axes limits are properly cached for zoom/unzoom
resetplotview(hAxes,'SaveCurrentView');  

% turn on box and grid
set(hAxes,'Box','on','XGrid','on','YGrid','on');
title(getString(message('signal:periodogram:ReassignedPeriodogramPSDEstimate')));

%--------------------------------------------------------------------------
function w = makeOnesidedWc(range,w,nfft)
if strcmp(range,'onesided')
   if rem(nfft,2),
      select = 1:(nfft+1)/2;  % ODD     
   else
      select = 1:nfft/2+1;    % EVEN     
   end
   w = w(select,:);
end   
    
%--------------------------------------------------------------------------
function Wc = centerWc(options,Wc)
     
nFreq = size(Wc,1);
if options.centerdc
  iseven = options.nfft/2 == round(options.nfft/2);
  if strcmp(options.range,'onesided')
    if iseven
      Wc = [-Wc(nFreq-1:-1:2,:) ; Wc(1:nFreq,:)];
    else
      Wc = [-Wc(nFreq:-1:2,:) ; Wc(1:nFreq,:)];
    end
  else % two-sided
    if iseven
      Wc = Wc([nFreq/2+2:nFreq 1:nFreq/2+1],:);
    else
      Wc = Wc([(nFreq+1)/2+1:nFreq 1:(nFreq+1)/2],:);
    end
  end
end

%--------------------------------------------------------------------------
function Wc = dealiasWc(options,Wc)
Fs = options.Fs;
if isempty(Fs)
  % normalize to 2*pi when default specified.
  Fs = 2*pi;
end

if options.centerdc || any(options.nfft < 0)
   % map to [-Fs/2,Fs/2) when using negative frequencies
   Wc = mod(Wc+Fs/2,Fs)-Fs/2;
else
   % map to [0,Fs) when using positive frequencies
   Wc = mod(Wc,Fs);
end
% [EOF] periodogram.m
