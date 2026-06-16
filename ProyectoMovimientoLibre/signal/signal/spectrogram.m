function [s,f,t,Pxx,fcorr,tcorr] = spectrogram(x,varargin)
%SPECTROGRAM Spectrogram using a Short-Time Fourier Transform (STFT).
%   S = SPECTROGRAM(X) returns the spectrogram of the signal specified by
%   vector X in the matrix S. By default, X is divided into eight segments
%   with 50% overlap, each segment is windowed with a Hamming window. The
%   number of frequency points used to calculate the discrete Fourier
%   transforms is equal to the maximum of 256 or the next power of two
%   greater than the length of each segment of X.
%
%   If X cannot be divided exactly into eight segments, X will be truncated
%   accordingly.
%
%   S = SPECTROGRAM(X,WINDOW) when WINDOW is a vector, divides X into
%   segments of length equal to the length of WINDOW, and then windows each
%   segment with the vector specified in WINDOW.  If WINDOW is an integer,
%   X is divided into segments of length equal to that integer value, and a
%   Hamming window of equal length is used.  If WINDOW is not specified, the
%   default is used.
%
%   S = SPECTROGRAM(X,WINDOW,NOVERLAP) NOVERLAP is the number of samples
%   each segment of X overlaps. NOVERLAP must be an integer smaller than
%   WINDOW if WINDOW is an integer.  NOVERLAP must be an integer smaller
%   than the length of WINDOW if WINDOW is a vector.  If NOVERLAP is not
%   specified, the default value is used to obtain a 50% overlap.
%
%   S = SPECTROGRAM(X,WINDOW,NOVERLAP,NFFT) specifies the number of
%   frequency points used to calculate the discrete Fourier transforms.
%   If NFFT is not specified, the default NFFT is used.
%
%   S = SPECTROGRAM(X,WINDOW,NOVERLAP,NFFT,Fs) Fs is the sampling frequency
%   specified in Hz. If Fs is specified as empty, it defaults to 1 Hz. If
%   it is not specified, normalized frequency is used.
%
%   Each column of S contains an estimate of the short-term, time-localized
%   frequency content of the signal X.  Time increases across the columns
%   of S, from left to right.  Frequency increases down the rows, starting
%   at 0.  If X is a length NX complex signal, S is a complex matrix with
%   NFFT rows and k = fix((NX-NOVERLAP)/(length(WINDOW)-NOVERLAP)) columns.
%   For real X, S has (NFFT/2+1) rows if NFFT is even, and (NFFT+1)/2 rows
%   if NFFT is odd.
%
%   [S,F,T] = SPECTROGRAM(...) returns a vector of frequencies F and a
%   vector of times T at which the spectrogram is computed. F has length
%   equal to the number of rows of S. T has length k (defined above) and
%   its value corresponds to the center of each segment.
%
%   [S,F,T] = SPECTROGRAM(X,WINDOW,NOVERLAP,F,Fs) computes the two-sided
%   spectrogram at the frequencies specified in vector F.  F must be
%   expressed in hertz and have at least two elements.
%
%   [S,F,T,P] = SPECTROGRAM(...) P is a matrix representing the Power
%   Spectral Density (PSD) of each segment. For real signals, SPECTROGRAM
%   returns the one-sided modified periodogram estimate of the PSD of each
%   segment; for complex signals and in the case when a vector of
%   frequencies is specified, it returns the two-sided PSD.
%
%   [S,F,T,P] = SPECTROGRAM(...,'MinThreshold',THRESH) sets the elements of
%   P to zero when the corresponding elements of 10*log10(P) are less than
%   THRESH. Specify THRESH in units of decibels. The default value of
%   THRESH is -Inf.
%
%   [S,F,T,P] = SPECTROGRAM(...,'reassigned') reassigns each PSD estimate
%   to the location of its center of gravity.  The reassignment is done
%   in-place and returned in P.
%
%   [S,F,T,P,Fc,Tc] = SPECTROGRAM(...) returns the locations in frequency
%   and time of the center of gravity of each estimate in the spectrogram.
%   The frequencies and times are returned in matrices, Fc, and Tc,
%   respectively.  Fc and Tc have the same dimensions as the spectrogram, S.
%
%   [...]  = SPECTROGRAM(...,SPECTRUMTYPE) uses the window scaling
%   algorithm specified by SPECTRUMTYPE when computing the power spectral
%   density matrix P.
%   SPECTRUMTYPE can be set to 'psd' or 'power':
%     'psd'   - returns the power spectral density
%     'power' - scales each estimate of the PSD by the equivalent noise
%               bandwidth of the window (in hertz).  Use this option to
%               obtain an estimate of the power at each frequency.
%   The default value for SPECTRUMTYPE is 'psd'.
%
%   [...] = SPECTROGRAM(...,FREQRANGE)  returns the PSD over the specified
%   range of frequencies based upon the value of FREQRANGE:
%
%      'onesided' - returns the one-sided matrix P of a real input signal X.
%         If NFFT is even, P has length NFFT/2+1 and is computed over the
%         interval [0,pi].  If NFFT is odd, P has length (NFFT+1)/2 and
%         is computed over the interval [0,pi). When Fs is specified, the
%         intervals become [0,Fs/2] and [0,Fs/2) for even and odd NFFT,
%         respectively.
%
%      'twosided' - returns the two-sided matrix P for either real or complex
%         input X.  P has length NFFT and is computed over the interval
%         [0,2*pi). When Fs is specified, the interval becomes [0,Fs).
%
%      'centered' - returns the centered two-sided matrix P for either real
%         or complex X.  P has length NFFT and is computed over the interval
%         (-pi, pi] for even length NFFT and (-pi, pi) for odd length NFFT.
%         When Fs is specified, the intervals become (-Fs/2, Fs/2] and
%         (-Fs/2, Fs/2) for even and odd NFFT, respectively.
%
%      FREQRANGE may be placed in any position in the input argument list
%      after NOVERLAP.  The default value of FREQRANGE is 'onesided' when X
%      is real and 'twosided' when X is complex.
%
%   SPECTROGRAM(...) with no output arguments plots the PSD estimate for
%   each segment on a surface in the current figure. 
%
%   SPECTROGRAM(...,FREQLOCATION) controls where MATLAB displays the
%   frequency axis on the plot. This string can be either 'xaxis' or
%   'yaxis'.  Setting this FREQLOCATION to 'yaxis' displays frequency on
%   the y-axis and time on the x-axis.  The default is 'xaxis' which
%   displays the frequency on the x-axis. If FREQLOCATION is specified when
%   output arguments are requested, it is ignored.
%
%   EXAMPLE 1: Spectrogram of quadratic chirp
%     t=0:0.001:2;                    % 2 secs @ 1kHz sample rate
%     y=chirp(t,100,1,200,'q');       % Start @ 100Hz, cross 200Hz at t=1sec
%     spectrogram(y,kaiser(128,18),120,128,1E3,'yaxis');
%     title('Quadratic Chirp: start at 100Hz and cross 200Hz at t=1sec');
%
%   EXAMPLE 2: Reassigned spectrogram of quadratic chirp
%     t=0:0.001:2;                    % 2 secs @ 1kHz sample rate
%     y=chirp(t,100,1,200,'q');       % Start @ 100Hz, cross 200Hz at t=1sec
%     spectrogram(y,kaiser(128,18),120,128,1E3,'reassigned','yaxis');
%     title('Quadratic Chirp: start at 100Hz and cross 200Hz at t=1sec');
%
%   EXAMPLE 3:  Plot instantaneous frequency of quadratic chirp
%     t=0:0.001:2;                    % 2 secs @ 1kHz sample rate
%     y=chirp(t,100,1,200,'q');       % Start @ 100Hz, cross 200Hz at t=1sec
%     % remove estimates less than -30 dB
%     [~,~,~,P,Fc,Tc] = spectrogram(y,kaiser(128,18),120,128,1E3,'minthreshold',-30);
%     plot(Tc(P>0),Fc(P>0),'. ')
%     title('Quadratic Chirp: start at 100Hz and cross 200Hz at t=1sec');
%     xlabel('Time (s)')
%     ylabel('Frequency (Hz)')
%
%   EXAMPLE 4: Waterfall display of the PSD of each segment of a VCO
%     Fs = 10e3;
%     t = 0:1/Fs:2;
%     x1 = vco(sawtooth(2*pi*t,0.5),[0.1 0.4]*Fs,Fs);
%     spectrogram(x1,kaiser(256,5),220,512,Fs);
%     view(-45,65)
%     colormap bone

%   See also PERIODOGRAM, PWELCH, SPECTRUM, GOERTZEL.

% [1] Oppenheim, A.V., and R.W. Schafer, Discrete-Time Signal Processing,
%     Prentice-Hall, Englewood Cliffs, NJ, 1989, pp. 713-718.
% [2] Mitra, S. K., Digital Signal Processing. A Computer-Based Approach.
%     2nd Ed. McGraw-Hill, N.Y., 2001.
% [3] Chassande-Mottin, E., Auger F., and Flandrin, P., Reassignment.
%     Chapter 9.3.1 in Time-Frequency Analysis: Concepts and Methods. F.
%     Hlawatsch and F. Auger Eds. John Wiley & Sons, 2008, pg. 258-259

%   Copyright 1988-2015 The MathWorks, Inc.

narginchk(1,11);
nargoutchk(0,6);

% handle options specific to SPECTROGRAM and remove from argument list.
[reassign,varargin] = getReassignmentOption(varargin{:});
[faxisloc, varargin] = getFreqAxisOption(varargin{:});
[threshold,varargin] = getMinThreshold(varargin{:});

% check for valid input signal
chkinput(x);

% look for psd and power flags
[esttype, varargin] = psdesttype({'psd','power'},'psd',varargin); 

% parse input arguments (using the PWELCH parser since it shares the same API).
[x,nx,~,~,~,win,~,~,noverlap,~,~,options] = welchparse(x,esttype,varargin{:});

% cast to enforce precision rules
noverlap = signal.internal.sigcasttofloat(noverlap,'double',...
  'spectrogram','NOVERLAP','allownumeric');

% process frequency-specific arguments
[Fs,nfft,isnormfreq,options] = processFrequencyOptions(options,reassign);

% Make x and win into columns
x = x(:);
win = win(:);
nwin = length(win);

% place x into columns and return the corresponding central time estimates
[xin,t] = getSTFTColumns(x,nx,nwin,noverlap,Fs);

% Compute the raw STFT
% Apply the window to the array of offset signal segments.
[y,f] = computeDFT(bsxfun(@times,win,xin),nfft,Fs);

if reassign || nargout>4
  % Apply frequency correction from time derivative window
  yc = computeDFT(bsxfun(@times,dtwin(win,Fs),xin),nfft,Fs);
  fcorr = -imag(yc ./ y);
  fcorr(~isfinite(fcorr)) = 0;
  fcorr = bsxfun(@plus,f,fcorr);
else
  fcorr = [];
end

if reassign || nargout>5
  % Apply time correction from frequency derivative window
  yc = computeDFT(bsxfun(@times,dfwin(win,Fs),xin),nfft,Fs);
  tcorr = real(yc ./ y);
  tcorr(~isfinite(tcorr)) = 0;
  tcorr = bsxfun(@plus,t,tcorr);
else
  tcorr = [];
end

% truncate output and adjust any time-frequency corrections based on
% FREQRANGE spectrum format ('centered', 'onesided', 'twosided')
[y,f,fcorr,tcorr] = formatSpectrogram(y,f,fcorr,tcorr,Fs,nfft,options);

% compute PSD only when required
if nargout==0 || nargout>3
  [Pxx,f] = compute_PSD(win,y,nfft,f,t,options,Fs,esttype,threshold,reassign,fcorr,tcorr);
else
  Pxx = [];
end

% shift specified outputs when 'centered'.
if options.centerdc && length(options.nfft)==1
  [y,f,Pxx,fcorr,tcorr] = centerOutputs(nargout,y,f,Pxx,fcorr,tcorr);
end

% cast to enforce precision rules
if (isa(xin,'single') || isa(win,'single'))
  [y,f,t,Pxx,fcorr,tcorr] = castToSingle(nargout,y,f,t,Pxx,fcorr,tcorr);
end

if nargout==0
  % plot when no output arguments are specified
  % leave S unassigned to suppress output printing
  displayspectrogram(t,f,Pxx,isnormfreq,faxisloc,esttype,threshold);
else
  s=y;
end


%--------------------------------------------------------------------------
function chkinput(x)
% Check for valid input signal

if isempty(x) || issparse(x) || ~isfloat(x),
  error(message('signal:spectrogram:MustBeFloat', 'X'));
end

if min(size(x))~=1,
  error(message('signal:spectrogram:MustBeVector', 'X'));
end


%--------------------------------------------------------------------------
function displayspectrogram(t,f,Pxx,isFsnormalized,faxisloc,esttype, threshold)
% Cell array of the standard frequency units strings

if isFsnormalized,
  f = f/pi; % Normalize the freq axis
  frequnitstrs = getfrequnitstrs;
  freqlbl = frequnitstrs{1};
  timelbl = getString(message('signal:spectrogram:Samples'));
else
  % Use engineering units
  [f,~,uf] = engunits(f,'unicode');
  freqlbl = getfreqlbl([uf 'Hz']);
  [t,~,ut] = engunits(t,'unicode','time');
  timelbl = [getString(message('signal:spectrogram:Time')) ' (' ut ')'];
end

h = newplot;
if strcmpi(faxisloc,'yaxis'),
  xlbl = timelbl;
  ylbl = freqlbl;
else
  xlbl = freqlbl;
  ylbl = timelbl;
end

hRotate = uigettool(ancestor(h,'Figure'),'Exploration.Rotate');
if strcmp(hRotate.State,'off')
  if strcmp(faxisloc,'yaxis')
    hndl = imagesc(t, f, 10*log10(abs(Pxx)+eps));
  else
    hndl = imagesc(f, t, 10*log10(abs(Pxx)'+eps));
  end
  hndl.Parent.YDir = 'normal';

  setupListeners(hndl);
else
  if strcmp(faxisloc,'yaxis')
    hndl = surf(t, f, 10*log10(abs(Pxx)+eps),'EdgeColor','none');
  else
    hndl = surf(f, t, 10*log10(abs(Pxx)'+eps),'EdgeColor','none');
  end
  axis xy
  axis tight
  view(0,90);
end  

if threshold>0
  Pmax = max(Pxx(:));
  if threshold < Pmax
    set(ancestor(hndl,'axes'),'CLim',10*log10([threshold Pmax]))
  end
end

if strcmpi(esttype,'power')
  cblabel = getString(message('signal:dspdata:dspdata:PowerdB'));
else
  if isFsnormalized
    cblabel = getString(message('signal:dspdata:dspdata:PowerfrequencydBradsample'));
  else
    cblabel = getString(message('signal:dspdata:dspdata:PowerfrequencydBHz'));
  end
end
%sigutils.internal.colorbari('titlelong',cblabel);
h = colorbar;
h.Label.String = cblabel;

ylabel(ylbl);
xlabel(xlbl);

% -------------------------------------------------------------------------
function [xin,t] = getSTFTColumns(x,nx,nwin,noverlap,Fs)
% Determine the number of columns of the STFT output (i.e., the S output)
ncol = fix((nx-noverlap)/(nwin-noverlap));

colindex = 1 + (0:(ncol-1))*(nwin-noverlap);
rowindex = (1:nwin)';
% 'xin' should be of the same datatype as 'x'
xin = zeros(nwin,ncol,class(x)); %#ok<*ZEROLIKE>

% Put x into columns of xin with the proper offset
xin(:) = x(rowindex(:,ones(1,ncol))+colindex(ones(nwin,1),:)-1);

% colindex already takes into account the noverlap factor; Return a T
% vector whose elements are centered in the segment.
t = ((colindex-1)+((nwin)/2)')/Fs;

% -------------------------------------------------------------------------
function [Pxx,f,fcorr,tcorr] = compute_PSD(win,y,nfft,f,t,options,Fs,esttype,threshold,reassign,fcorr,tcorr)

% Evaluate the window normalization constant.
if strcmpi(esttype,'power')
  if reassign
    % compensate for the power of the window including a
    % 1/N scaling factor omitted by FFT/DFT computation.
    if isscalar(nfft)
      U = nfft*(win'*win);
    else
      U = numel(win)*(win'*win);
    end
  else
    % The window is convolved with every power spectrum peak, therefore
    % compensate for the DC value squared to obtain correct peak heights.
    % The 1/N factor has been omitted since it will cancel below.
    U = sum(win)^2;
  end
else
  % compensates for the power of the window.
  % The 1/N factor has been omitted since it will cancel below.
  U = win'*win;
end

Sxx = y.*conj(y)/U; % Auto spectrum.

% reassign in-place when requested.
if reassign
  Sxx = reassignSpectrum(Sxx, f, t, fcorr, tcorr, options);
end

% Compute the one-sided or two-sided PSD [Power/freq]. Also compute
% the corresponding half or whole power spectrum [Power].
[Pxx,f] = computepsd(Sxx, f, options.range, nfft, Fs, esttype);

% remove low-power estimates if requested
if threshold>0
  Pxx(Pxx<threshold) = 0;
end

% -------------------------------------------------------------------------
function f = centerfreq(f)
n = numel(f);
if n/2==round(n/2)
  %even (nyquist is at end of spectrum)
  f = f - f(n/2);
else
  % odd
  f = f - f((n+1)/2);
end

% -------------------------------------------------------------------------
function y = centerest(y)
n = size(y,1);
if n/2==round(n/2)
  %even (nyquist is at end of spectrum)
  y = circshift(y,n/2-1);
else
  % odd
  y = fftshift(y,1);
end

% -------------------------------------------------------------------------
function [y,f,Pxx,fcorr,tcorr] = centerOutputs(nOut,y,f,Pxx,fcorr,tcorr)
% center y,fcorr,tcorr only if specified in the output list
% center f,Pxx if specified in the output list or when plotting
% nOut contains the number of output arguments of SPECTROGRAM
if nOut>0
  y = centerest(y);
end

if nOut==0 || nOut>1
  f = centerfreq(f);
end

if nOut==0 || nOut>3
  Pxx = centerest(Pxx);
end

if nOut>4
  fcorr = centerest(fcorr);
end

if nOut>5
  tcorr = centerest(tcorr);
end

% -------------------------------------------------------------------------
function [y,f,t,Pxx,fcorr,tcorr] = castToSingle(nOut,y,f,t,Pxx,fcorr,tcorr)
% convert outputs to single precision when specified in output list
% nOut contains the number of output arguments of SPECTROGRAM

if nOut>0
  y = single(y);
end

if nOut>1
  f = single(f);
end

if nOut>2
  t = single(t);
end

if nOut>3
  Pxx = single(Pxx);
end

if nOut>4
  fcorr = single(fcorr);
end

if nOut>5
  tcorr = single(tcorr);
end

% -------------------------------------------------------------------------
function Wdt = dtwin(w,Fs)
% differentiate window in time domain via cubic spline interpolation

% compute the piecewise polynomial representation of the window
% and fetch the coefficients
n = numel(w);
pp = spline(1:n,w);
[breaks,coefs,npieces,order,dim] = unmkpp(pp);

% take the derivative of each polynomial and evaluate it over the same
% samples as the original window
ppd = mkpp(breaks,repmat(order-1:-1:1,dim*npieces,1).*coefs(:,1:order-1),dim);
Wdt = ppval(ppd,(1:n)').*(Fs/(2*pi));

% -------------------------------------------------------------------------
function Wdf = dfwin(w,Fs)
% multiply by time ramp to implement differentiation in frequency domain
n = numel(w);
Wdf = w .* ((1-n)/2:(n-1)/2)'/Fs;

% -------------------------------------------------------------------------
function [threshold,varargin] = getMinThreshold(varargin)
threshold = 0;

i = 1;
while i<numel(varargin)
  if ischar(varargin{i}) && strcmpi(varargin{i},'MinThreshold') ...
      && isnumeric(varargin{i+1}) && isscalar(varargin{i+1})
    threshold = 10^(varargin{i+1}/10);
    varargin([i i+1]) = [];
  else
    i = i+1;
  end
end

% -------------------------------------------------------------------------
function [faxisloc,varargin] = getFreqAxisOption(varargin)
faxisloc = 'xaxis';
i = 1;
while i <= numel(varargin)
  if ischar(varargin{i}) && any(strcmpi(varargin{i},{'xaxis','yaxis'}))
    faxisloc = varargin{i};
    varargin(i)=[];
  else
    i = i+1;
  end
end

% -------------------------------------------------------------------------
function [reassign,varargin] = getReassignmentOption(varargin)
reassign = false;

i = 1;
while i <= numel(varargin)
  if ischar(varargin{i}) && strncmpi(varargin{i},'reassigned',8)
    reassign = true;
    varargin(i)=[];
  else
    i = i+1;
  end
end

%--------------------------------------------------------------------------
function [Fs,nfft,isnormfreq,options] = processFrequencyOptions(options,reassign)
% Determine whether an empty was specified for Fs (i.e., Fs=1Hz) or
% returned by welchparse which means normalized Fs is used.

% Cast to enforce Precision rules
Fs = double(options.Fs);
nfft = double(options.nfft);

% when Fs is specified as [], welchparse() returns 1 Hz.
% welchparse() returns [] only when Fs is omitted
isnormfreq = isempty(Fs);
if isnormfreq
  Fs = 2*pi;
end

if length(nfft) > 1
  % Frequency vector was specified, return and plot two-sided PSD
  if strcmpi(options.range,'onesided')
    warning(message('signal:welch:InconsistentRangeOption'));
  end
  options.range = 'twosided';
end

% prevent unneeded temporary conversion to one-sided spectrum
if options.centerdc
  options.range = 'twosided';
end

% ensure frequency vector is linearly spaced when performing reassignment
if reassign && ~isscalar(options.nfft)
  f = options.nfft(:);
  
  % see if we can get a uniform spacing of the freq vector
  [~, ~, ~, maxerr] = getUniformApprox(f);
  
  % see if the ratio of the maximum absolute deviation relative to the
  % largest absolute in the frequency vector is less than a few eps
  isuniform = maxerr < 3*eps(class(f));
  
  if ~isuniform
    error(message('signal:spectrogram:ReassignFreqMustBeUniform'));
  end
end

% -------------------------------------------------------------------------
function [y,f,fcorr,tcorr]  = formatSpectrogram(y,f,fcorr,tcorr,Fs,nfft,options)
% truncate output and adjust any time-frequency corrections based on
% FREQRANGE spectrum format ('centered', 'onesided', 'twosided')

% if nfft is a scalar, it is the length of the fft, otherwise it contains
% the output frequency vector
freqvecspecified = length(nfft)>1;

% truncate output when using one-sided spectrum
if ~freqvecspecified && strcmpi(options.range,'onesided')
  f = psdfreqvec('npts',nfft,'Fs',Fs,'Range','half');
  y = y(1:length(f),:);
  if ~isempty(fcorr)
    fcorr = fcorr(1:length(f),:);
  end
  if ~isempty(tcorr)
    tcorr = tcorr(1:length(f),:);
  end
end

if ~isempty(fcorr)
  if options.centerdc || freqvecspecified && any(nfft < 0)
    % map to [-Fs/2,Fs/2) when using negative frequencies
    fcorr = mod(fcorr+Fs/2,Fs)-Fs/2;
  else
    % map to [0,Fs) when using positive frequencies
    fcorr = mod(fcorr,Fs);
  end
end

% -------------------------------------------------------------------------
function RSxx = reassignSpectrum(Sxx, f, t, fcorr, tcorr, options)

nf = numel(f);
nt = numel(t);

fmin = f(1);
fmax = f(end);

tmin = t(1);
tmax = t(end);

% compute the destination row for each spectral estimate
% allow cyclic frequency reassignment only if we have a full spectrum
if isscalar(options.nfft) && strcmp(options.range,'twosided')
  rowIdx = 1+mod(round((fcorr(:)-fmin)*(nf-1)/(fmax-fmin)),nf);
else
  rowIdx = 1+round((fcorr(:)-fmin)*(nf-1)/(fmax-fmin));
end

% compute the destination column for each spectral estimate
colIdx = 1+round((tcorr(:)-tmin)*(nt-1)/(tmax-tmin));

% reassign the estimates that fit inside the time-frequency matrix
Sxx = Sxx(:);
idx = find(rowIdx>=1 & rowIdx<=nf & colIdx>=1 & colIdx<=nt);
RSxx = accumarray([rowIdx(idx) colIdx(idx)], Sxx(idx), [nf nt]);

% -------------------------------------------------------------------------
function setupListeners(hndl)
hAxes = ancestor(hndl,'Axes');
hRotate = uigettool(ancestor(hndl,'Figure'),'Exploration.Rotate');

eYScale = addlistener(hAxes,'YScale','PreSet',@(src,evt) image2surf(hndl));
eView = addlistener(hAxes,'View','PostSet',@(src,evt) image2surf(hndl));
eRotate = addlistener(hRotate,'State','PostSet',@(src,evt) image2surf(hndl));

set(hndl,'UserData',{eYScale,eView,eRotate});

% -------------------------------------------------------------------------
function image2surf(h)
if ishghandle(h)
  ud = h.UserData;
  if ~isempty(ud)
    delete(ud{1});
    delete(ud{2});
    delete(ud{3});
  end
  
  C = h.CData;
  if size(C,1)<2 || size(C,2)<2
    % don't draw a surface for 1-cell high/wide images
    return
  end
  
  X = h.XData;
  Y = h.YData;
  hAxes = h.Parent;
  v = hAxes.View;
  CLim = hAxes.CLim;
  xLabel = hAxes.XLabel.String;
  yLabel = hAxes.YLabel.String;

  hcb = findobj(ancestor(hAxes,'figure'),'type','colorbar');
  for i=1:numel(hcb)
    if isequal(handle(hAxes),handle(hcb(i).Axes))
      cblabel = hcb(i).Label.String;
    end
  end
      
  delete(h);
  
  surf(hAxes,X,Y,C,'EdgeColor','none','LineStyle','none','LineWidth',5);
  set(hAxes, ...
    'XLim', X([1 end]), ...
    'YLim', Y([1 end]), ...
    'ZLim', [min(C(:)) max(C(:))], ...
    'CLim', CLim, ...
    'View', v);
  xlabel(hAxes,xLabel);
  ylabel(hAxes,yLabel);
  
  hcb = colorbar('peer',hAxes);
  hcb.Label.String = cblabel;  
end