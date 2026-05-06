function [sst,f,t] = fsst(x,varargin)
%FSST Fourier synchrosqueezed transform
%   SST = FSST(X) returns the Fourier synchrosqueezed transform of X. Each
%   column of SST contains the synchrosqueezed spectrum of a windowed
%   segment of X. The number of columns of SST is equal to the number of
%   samples of the input X, which is padded with zeros on each side. Each
%   spectrum is one-sided for real X and two-sided and centered for complex
%   X. By default, a Kaiser window of length 256 and a beta of 10 is used.
%   If X has fewer than 256 samples, then the Kaiser window has the same
%   length as X.
% 
%   [SST,W,S] = FSST(X) returns a vector of normalized frequencies, W,
%   corresponding to the rows of SST, and a vector of sample numbers, S,
%   corresponding to the columns of SST. Each element of S is the sample
%   number of the midpoint of a windowed segment of X.
%
%   [SST,F,T] = FSST(X,Fs) specifies the sampling frequency, Fs, in hertz,
%   as a positive scalar. The output contains sample times, T, expressed in
%   seconds and frequencies, F, expressed in hertz.
%
%   [SST,F,T] = FSST(X,Ts) specifies the sampling interval, Ts, as a 
%   <a href="matlab:help duration">duration</a>. Ts is the time between samples of X. T has the same units 
%   as the duration. The units of F are in cycles/unit time of the
%   duration.
%
%   [...] = FSST(X,...,WINDOW) when WINDOW is a vector, divides X into
%   segments of the same length as WINDOW and then multiplies each segment
%   by WINDOW.  If WINDOW is an integer, a Kaiser window with length WINDOW
%   and a beta of 10 is used. If WINDOW is not specified, the default
%   Kaiser window is used.
%
%   FSST(...) with no output arguments plots the synchrosqueezed transform
%   of the input vector x on the current figure.
%
%   FSST(...,FREQLOCATION) controls where MATLAB displays the frequency
%   axis on the plot. This string can be either 'xaxis' or 'yaxis'.
%   Setting FREQLOCATION to 'yaxis' displays frequency on the y-axis and
%   time on the x-axis.  The default is 'xaxis', which displays frequency
%   on the x-axis. FREQLOCATION is ignored when output arguments are
%   specified.
%
%   % Example 1: 
%   %   Compute and plot the Fourier synchrosqueezed transform (SST) of a
%   % signal that consists of two chirps. 
%   fs = 3000;
%   t = 0:1/fs:1-1/fs;   
%   x1 = 2*chirp(t,500,t(end),1000);
%   x2 = chirp(t,400,t(end),800); 
%   fsst(x1+x2,fs,'yaxis')
%   title('Magnitude of Fourier Synchrosqueezed Transform of Two Chirps')
%
%   % Compute and plot the short-time Fourier transform.
%   [stft,f,t] = spectrogram(x1+x2,kaiser(256,10),255,256,fs);
%   figure
%   h = imagesc(t,f,abs(stft));
%   xlabel('Time (s)') 
%   ylabel('Frequency (Hz)')
%   title('Magnitude of Short-time Fourier Transform of Two Chirps')
%   h.Parent.YDir = 'normal';
%
%   % Example 2
%   %   Compute the Fourier synchrosqueezed transform of a speech signal.
%   load mtlb
%   fsst(mtlb,Fs,hann(256),'yaxis')
%
%   See also ifsst, tfridge, spectrogram, duration.

% Copyright 2015-2016 MathWorks, Inc.

narginchk(1,4);
nargoutchk(0,3);

% Parse inputs. Fs is populated as used throughout the bulk of the code
% even if Ts is specified. fNorm specifies normalized frequencies.
[Fs,Ts,win,fNorm,freqloc] = parseInputs(x,varargin{:});

validateInputs(x,Fs,Ts,win);

% Parameters based on window size - noverlap is fixed so the transform is
% invertible.
nwin = length(win);
nfft = nwin;
noverlap = nwin-1;

% Convert to column vectors
x = signal.internal.toColIfVect(x);
win = win(:);

% Compute the output time vector (one time per sample point of the input)
if fNorm
  tout = (1:length(x));
else
  tout = (0:length(x)-1)/Fs;
end

% cast to enforce precision rules (we already checked that the inputs are
% numeric.
% cast to enforce precision rules
if (isa(x,'single') || isa(win,'single'))
  x = single(x);
  win = single(win);
  Fs = single(Fs);
  tout = single(tout);
else
  Fs = double(Fs);
end
  
% Pad the signal vector x
if mod(nwin,2)
  xp = [zeros((nwin-1)/2,1) ; x ; zeros((nwin-1)/2,1)];
else
  xp = [zeros((nwin)/2,1) ; x ; zeros((nwin-2)/2,1)];
end

nxp = length(xp);

% Place xp into columns for the STFT
xin = signal.internal.reassignSpec.getSTFTColumns(xp,nxp,nwin,noverlap,Fs);

% Compute the STFT
[sstout,fout] = computeDFT(bsxfun(@times,win,xin),nfft,Fs); 
stftc = computeDFT(bsxfun(@times,signal.internal.reassignSpec.dtwin(win,Fs),xin),nfft,Fs);

clear xin;

% Compute the reassignment vector
fcorr = -imag(stftc./ sstout);
fcorr(~isfinite(fcorr)) = 0;
fcorr = bsxfun(@plus,fout,fcorr);
tcorr = bsxfun(@plus,tout,zeros(size(fcorr)));

clear stftc;

% Mulitply STFT by a linear phase shift to produce the modified STFT
m = floor(nwin/2);
inds = 0:nfft-1;
ez = exp(-1i*2*pi*m*inds/nfft)';
sstout = bsxfun(@times,sstout,ez); 

% Reassign the modified STFT
options.range = 'twosided';
options.nfft = nfft;
sstout = signal.internal.reassignSpec.reassignSpectrum(sstout, fout, tout, fcorr, tcorr, options);

% Reduce to one-sided spectra if the input is real, otherwise return a
% two-sided (centered) spectra.
if isreal(x)
  fout = psdfreqvec('npts',nfft,'Fs',Fs,'Range','half');
  sstout = sstout(1:length(fout),:);
else
  % Centered spectra
  sstout = signal.internal.reassignSpec.centerest(sstout);
  fout = signal.internal.reassignSpec.centerfreq(fout);
end

% Scale fout and tout if the input is a duration object
if ~isempty(Ts)
  [~,~,timeScale] = getDurationandUnits(Ts);
  tout = tout*timeScale;
  fout = fout/timeScale;
end

if nargout == 0
  plotsst(tout,fout,sstout,Ts,fNorm,freqloc);
else
  sst = sstout;
  f = fout;
  t = tout(:)';
end
%--------------------------------------------------------------------------
function [Fs,Ts,win,fNorm,freqloc] = parseInputs(x,varargin)
% Set defaults
Fs = [];
Ts = [];
win = kaiser(min(256,length(x)),10); %#ok<*NASGU>
fNorm = false;
freqloc = '';

% Parse optional inputs
if nargin > 1 
  if isduration(varargin{1})
    if isempty(varargin{1})
      % Throw error is empty duration object is supplied
      error(message('signal:fsst:EmptyDuration'));
    else
      Ts = varargin{1};
      Fs = 1/seconds(Ts);
    end
  elseif ischar(varargin{1})
    freqloc = validatestring(varargin{1},{'xaxis','yaxis'});  
  else
    if ~isempty(varargin{1})
      Fs = varargin{1};
    end
  end
end

if isempty(Fs) && isempty(Ts)
  fNorm = true;
  Fs = 2*pi;
end

if nargin > 2 
  if ischar(varargin{2})
    freqloc = validatestring(varargin{2},{'xaxis','yaxis'});  
  elseif ~isempty(varargin{2})
    win = varargin{2};
    if isscalar(win)
      validateattributes(win,{'numeric'},{'positive'},'fsst','WINDOW');
      win = kaiser(double(win),10);
    end
  end
end

if nargin > 3
  freqloc = validatestring(varargin{3},{'xaxis','yaxis'}); 
end
%--------------------------------------------------------------------------
function validateInputs(x,Fs,Ts,win)

validateattributes(x,{'single','double'},...
  {'nonsparse','finite','nonnan','vector'},'fsst','X');
validateattributes(Fs,{'numeric'},...
    {'real','positive','finite','nonnan','scalar'},'fsst','Fs');
validateattributes(win,{'single','double'},...
  {'real','finite','nonnegative','nonnan','vector'},'fsst','WINDOW');  
  
if ~isempty(Ts)
  dt = getDurationandUnits(Ts);
  validateattributes(dt,{'numeric'},...
    {'real','positive','finite','nonnan','scalar'},'fsst','Ts');
end

% Check X has at least 2 samples
if length(x) < 2
  error(message('signal:fsst:MustBeMinLengthX'));
end

% Check WINDOW has at least 2 samples
if length(win) < 2
  error(message('signal:fsst:MustBeMinLengthWin'));
end

% Check window length is not more than the length of the input signal.
if length(win) > length(x)
  error(message('signal:fsst:WinLength'));
end
%--------------------------------------------------------------------------
function [dt,units,timeScale] = getDurationandUnits(Ts)
% This function returns the sampling interval and a format string
% The Units string is only for plotting.
tsformat = Ts.Format;
% Use first character of format string to determine correct
% duration object method.
tsformat = tsformat(1);
% Using the same time units as engunits. Units in engunits are
% not localized.
% time_units = {'secs','mins','hrs','days','years'};
switch tsformat
    case 's'
        dt = seconds(Ts);
        units = 'sec';
        timeScale = 1;
    case 'm'
        dt = minutes(Ts);
        units = 'min';
        timeScale = 1/seconds(minutes(1));
    case 'h'
        dt = hours(Ts);
        units = 'hr';
        timeScale = 1/seconds(hours(1));
    case 'd'
        dt = days(Ts);
        units = 'day';
        timeScale = 1/seconds(days(1));
    case 'y'
        dt = years(Ts);
        units = 'year';
        timeScale = 1/seconds(years(1));
end
%--------------------------------------------------------------------------
function plotsst(t,f,sst,Ts,fNorm,freqloc)
  % Plot the FSST in the current figure
  if fNorm
    xlbl = getString(message('signal:fsst:SampNum'));
    ylbl = [getString(message('signal:sigtools:getfrequnitstrs:NormalizedFrequency')) '  (\times\pi rad/sample)'];
    f = f/pi;
  elseif isempty(Ts) 
    % No duration object specified
    % Scale range and add corresponding label (e.g. MHz)
    [f,~,uf] = engunits(f,'unicode');
    [t,~,ut] = engunits(t,'unicode','time');
    xlbl = [getString(message('signal:spectrogram:Time')) ' (' ut ')'];
    ylbl = getfreqlbl([uf 'Hz']);
  else
    [~,timeUnit] = getDurationandUnits(Ts);
    xlbl = [getString(message('signal:spectrogram:Time')) ' (',timeUnit,'s)'];
    ylbl = [getString(message('signal:sigtools:getfrequnitstrs:Frequency')) ' (cycles/',timeUnit,')'];
  end
  
  
  if strcmp(freqloc,'yaxis')
      h = imagesc(t,f,abs(sst));
      set(h.Parent, 'Ydir', 'normal')
      xlabel(xlbl); 
      ylabel(ylbl);
  else
      h = imagesc(f,t,abs(sst)');
      set(h.Parent, 'Ydir', 'normal')
      xlabel(ylbl); 
      ylabel(xlbl);
  end
  
  title(getString(message('signal:fsst:titleFSST')));