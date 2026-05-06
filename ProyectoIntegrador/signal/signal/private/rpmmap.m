function [varargout] = rpmmap(x,fs,rpm,maptype,varargin)
%RPMMAP Compute frequency or order maps vs. rpm values.

% Copyright 2015 MathWorks, Inc.

% parse input parameters
[resolution,win,winparam,amplitude,scale,overlapPercent] = ...
  parseOptions(maptype,x,fs,rpm,varargin{:});

% cast to enforce precision rules (we already checked that the inputs are
% numeric.
rpm = double(rpm);
fs = double(fs);
resolution = double(resolution);
overlapPercent = double(overlapPercent);

% Define time vector
time = (0:length(x)-1)/fs;

% Convert x and rpm to column vectors
x = x(:);
rpm = rpm(:);
time = time(:);

if strcmp(maptype,'order')
  % Convert signal to rotational or order domain.
  % xp is the resampled signal (constant samples/cycle) and fsp is the
  % samples/cycle rate. phaseUp, rpmUp and timeUp vectors are at an
  % upsampled rate of 15*fs.
  [xp, fsp, phaseUp, rpmUp, timeUp] = toConstantSamplesPerCycle(x,fs,rpm,time);
else
  xp = x;
  fsp = fs;
end

% Compute DFT window length
% Define the minumum and maximum allowed window lengths
minWindowLength = 4;
maxWindowLength = length(xp);

if isempty(resolution)
  % Use the default resolution value: (sampling frequency)/128 for
  % frequency maps and (sampling frequency)/256 for order maps.
  if strcmp(maptype,'order')
    resolution = fsp/256;
  else
    resolution = fsp/128;
  end
  % Make sure resolution is inside range of allowed values
  % If it is not, use the minimum or maximum allowed window length
  [resolution,winLengthBound] = ...
  validateResolutionValue(resolution,minWindowLength,maxWindowLength,fsp,win,winparam,false);
else
  % Validate input resolution value
  [resolution,winLengthBound] = ...
  validateResolutionValue(resolution,minWindowLength,maxWindowLength,fsp,win,winparam,true);
end

if isempty(winLengthBound)
  % We have a valid resolution so compute window length
  [~,winLength] = signal.internal.getWinDurationForAGivenRBW(...
    resolution,win,winparam,fsp,true);
else
  % We have an invalid resolution so use the upper or lower bound
  winLength = winLengthBound;
end

% Compute the number of overlapping samples 
nOverlap = min(ceil(overlapPercent/100*winLength),winLength-1);

% Create DFT window and normalize it
winfun = getWinFunction(win, winparam);
win = winfun(winLength);
win = win/sum(win);

% Compute the resolution of the window and the FFT length
winres = enbw(win)*fsp/winLength;
nfft = max(256,length(win));

% Generate the frequency/order map
if strcmp(maptype,'order')
  [map,ordSpec,phaseSpec] = spectrogram(xp,win,nOverlap,nfft,fsp,'onesided');
  phaseSpec = phaseSpec(:);
else
  [map,freqSpec,timeSpec] = spectrogram(xp,win,nOverlap,nfft,fsp,'onesided');
  timeSpec = timeSpec(:);
end

% Apply amplitude and scale of the map
map = mapAmplitudeScale(map,amplitude,scale,nfft);
    
if strcmp(maptype,'order')
  % Limit to max order value as we oversampled in the order domain for
  % better results. Recall that Omax = fs/(2*max(rpm/60))
  idx = find(ordSpec <= fs/(2*max(rpm/60)));
  if idx(end)+1 <= length(ordSpec)
    % Get one extra order point to ensure we have the max order value
    idx(end+1) = idx(end)+1;
  end
  ordSpec = ordSpec(idx);
  map = map(idx,:);
end

%---------------------------------------------------------------------
% Plot or assign outputs
%---------------------------------------------------------------------
% Create plot of ordermap if no output arguments are specified
% Otherwise, assign output variables to suppress command window output
if nargout == 0
  
  % Surf encodes data points at the edges and takes the color from the last
  % edge so we need to add an additional point so that surf does the right
  % thing. This is important especially when spectrogram has only one
  % estimate (e.g. window length = signal length). For the plot we set time
  % or phase values to be at: nwin/2-a/2, nwin/2+a/2, nwin/2+3a/2,
  % nwin/2+5a/2 ... where a is the number of new samples for each segment
  % (i.e. nwin-noverlap). For the case of zero overlap this corresponds to
  % 0, nwin, 2*nwin, ...
  a = winLength - nOverlap;
  if strcmpi(maptype,'order')
    phaseVectForPlot = [(winLength/2-a/2)/fsp;  phaseSpec + ((a/2)/fsp)];
    rpmVectForPlot   = interp1(phaseUp, rpmUp, phaseVectForPlot,'linear','extrap');
    timeVectForPlot  = interp1(phaseUp, timeUp, phaseVectForPlot,'linear','extrap');
    map              = [map map(:,end)];
    
    rpmmapplot(map, ordSpec, timeVectForPlot, rpmVectForPlot, ...
      winres,'order', scale, amplitude, rpm, time);
  else
    timeVectForPlot = [(winLength/2-a/2)/fsp; timeSpec + ((a/2)/fsp)];
    rpmVectForPlot  = interp1(time, rpm, timeVectForPlot,'linear','extrap');
    map             = [map map(:,end)];
    
    rpmmapplot(map, freqSpec, timeVectForPlot, rpmVectForPlot, ...
      winres,'frequency', scale, amplitude, rpm, time);
    
  end
  
else
  
  % Assign output variables
  varargout{1} = map;
  
  if strcmp(maptype,'order')
    % Order map outputs are [map, order, rpm, time, res]
    if nargout > 1
      varargout{2} = ordSpec;
      if nargout > 2
        % Interpolate RPM values based on upsampled phase and rpm values,
        % and on spectrogram phase output vector
        rpmSpecDerived = interp1(phaseUp,rpmUp,phaseSpec,'linear','extrap');
        varargout{3} = rpmSpecDerived;
        if nargout > 3
          % Interpolate time values based on upsampled phase and rpm values,
          % and on spectrogram phase output vector
          timeSpecDerived = interp1(phaseUp,timeUp,phaseSpec,'linear','extrap');
          varargout{4} = timeSpecDerived;
          if nargout > 4
            varargout{5} = winres;
          end
        end
      end
    end
  else
    if nargout > 1
      varargout{2} = freqSpec;
      if nargout > 2
        % Interpolate RPM values based on time and rpm values, and on
        % spectrogram time output vector
        rpmSpecDerived = interp1(time,rpm,timeSpec,'linear','extrap');
        varargout{3} = rpmSpecDerived;
        if nargout > 3
          varargout{4} = timeSpec;
          if nargout > 4
            varargout{5} = winres;
          end
        end
      end
    end
  end
end
end

%--------------------------------------------------------------------------
function [xp, fsp, phaseUp, rpmUp, timeUp] = toConstantSamplesPerCycle(x,fs,rpm,time)

% Compute the maximum order that can be present in X with no aliasing. Max
% frequency, fmax, is the signal's max frequency (max(rpm/60)) multiplied
% by max order. For Nyquist to hold fs > 2*fmax = 2*max(rpm/60)*Omax.
Omax = fs/(2*max(rpm/60));

% Define sampling rate (samples/cycle) in phase domain based on the maximum
% order. Make sampling rate 4 times the Nyquist rate in the order domain.
fsp = 4*(2*Omax);

% Define upsample factor. Upsampling will improve accuracy when converting
% from constant samples/second to constant samples/cycle. In the worst case
% scenario, when time signal is critically sampled in time at Fmax/2, we
% are increasing the Nyquist frequency by 15.
upFactor = 15;

% Upsample x and rpm
if isa(x,'single')
  xUp = resample(double(x),upFactor,1);
  xUp = single(xUp);
else
  xUp = resample(x,upFactor,1);
end
% Get upsampled time and rpm vectors
timeUp = (0:length(xUp)-1).'/(upFactor*fs);
rpmUp = interp1(time, rpm, timeUp, 'linear','extrap');

% Estimate the phase of each signal sample by integrating the instantaneous
% signal frequency which is rpmUp/60. Divide by sampling rate which is
% upFactor*fs;
phaseUp = cumtrapz(rpmUp/(60*upFactor*fs));

% Interpolate signal x at constant phase increments (i.e. constant
% samples/cycle). xp is uniformly sampled in the rotational domain --> same
% samples per rotation for any rpm
constPhase = (phaseUp(1):1/fsp:(phaseUp(end)))';
xp = interp1(phaseUp,xUp,constPhase,'linear','extrap');

end

%--------------------------------------------------------------------------
function [resolution, win, winparam, amplitude, scale, overlapPercent, funName] = parseOptions(maptype,x,fs,rpm,varargin)

% default values for n-v pairs
if strcmp(maptype,'order')
  win = 'flattopwin';
  funName = 'rpmordermap';
else
  win = 'hann';
  funName = 'rpmfreqmap';
end
winparam = [];
amplitude = 'rms';
scale = 'linear';
resolution = [];
overlapPercent = 50;

% Check valid values for x,fs,rpm
validateattributes(x,{'single','double'},...
  {'real','nonsparse','finite','nonnan','vector'},funName,'X');
validateattributes(fs,{'numeric'},...
  {'real','positive','nonsparse','finite','nonnan','scalar'},funName,'Fs');
validateattributes(rpm,{'numeric'},...
  {'real','positive', 'nonsparse','finite','nonnan','vector'},funName,'RPM');

% Check valid input dimensions
if length(x) < 18
  error(message('signal:rpmmap:MustBeMinLength'));
end

%check rpm is the same size and x
if length(x)~=length(rpm)
  error(message('signal:rpmmap:MustBeSameLength'));
end

%check if a resolution parameter is specified and check if valid value
if ~isempty(varargin) && isnumeric(varargin{1})
  resolution = varargin{1};
  validateattributes(resolution,{'numeric'},...
    {'real','positive','nonsparse','finite','nonnan','scalar'},funName,'resolution');
  varargin(1) = [];
end

% If all is valid, then parse name value pairs if we have any
if isempty(varargin)
  return;
end

%check that name-value inputs come in pairs and are all strings
if rem(numel(varargin),2)
  error(message('signal:rpmmap:NVMustBeEven'));
end

idx =1;
while idx < numel(varargin)
  
  name = validatestring(varargin{idx},{'Window','Amplitude','Scale','OverlapPercent'});
  value = varargin{idx+1};
  
  switch name
    
    case 'Window'
      winList = {'hann','hamming','flattopwin','kaiser','rectwin','chebwin'};
      if iscell(value)
        win = validatestring(value{1}, winList);
        winparam = [];
        if numel(value) == 2
          switch win
            case 'kaiser'
              winparam = value{2};
              validateattributes(winparam,{'numeric'},...
                {'real', 'positive', 'finite','nonnan','scalar'},...
                funName,'Kaiser beta parameter');
            case 'chebwin'
              winparam = value{2};
              validateattributes(winparam,{'numeric'},...
                {'real', 'positive', 'finite','nonnan','scalar','>=',45},...
                funName,'chebwin sidelobe attenuation parameter');
            otherwise
              error(message('signal:rpmmap:WindowCellArgumentInvalid',win));
          end
        end
      else
        win = validatestring(value,winList);
      end
    case 'Amplitude'
      amplitude = validatestring(value,{'rms','peak','power'});
    case 'Scale'
      scale = validatestring(value,{'linear','dB'});
    case 'OverlapPercent'
      overlapPercent = value;
      validateattributes(overlapPercent,{'numeric'},...
        {'scalar','nonnegative','<=',100},funName,'OP');
  end
  idx = idx + 2;
  
end
end

%--------------------------------------------------------------------------
function [resolution,winLength] = validateResolutionValue(resolution,minLength,maxLength,fs,win,winParam,warn)
%check that resolution falls between minimum and maximum allowable values
%either return a valid resolution or a window length

% Create window
winfun = getWinFunction(win, winParam);

% Compute resolution of the window
minResValue = enbw(winfun(maxLength))*fs/maxLength;
maxResValue = enbw(winfun(minLength))*fs/minLength;
sminres = sprintf('%0.5g',minResValue);
smaxres = sprintf('%0.5g',maxResValue);

if resolution <= minResValue
  winLength = maxLength;
  resolution = [];
  if(warn)
    warning(message('signal:rpmmap:ResolutionMustBeInRangeUnder',...
      sminres,smaxres));
  end
elseif resolution >= maxResValue
  winLength = minLength;
  resolution = [];
  if(warn)
    warning(message('signal:rpmmap:ResolutionMustBeInRangeOver',...
      sminres,smaxres));
  end
else
  winLength = [];
end
end

%--------------------------------------------------------------------------
function map = mapAmplitudeScale(map,amplitude,scale,nfft)

% Map amplitude
switch amplitude
  case 'peak'
    map = oneSidedSpectrum(abs(map),nfft);
    % Scale all components except dc
    map(2:end,:) = sqrt(2)*map(2:end,:);
  case 'rms'
    map = oneSidedSpectrum(abs(map),nfft);
  case 'power'
    map = oneSidedSpectrum(abs(map),nfft).^2;
end

% Map scale
switch scale
  case 'linear'
    %no change is needed
  case 'dB'
    if isequal(amplitude,'power')
      map = 10*log10(map);
    else
      map = 20*log10(map);
    end
end
end

%--------------------------------------------------------------------------
function mp = oneSidedSpectrum(map,nfft)
% Get the correctly scaled one sided spectrum - map has magnitude values
% not power values so scaling should be sqrt(2) instead of 2 (note that we
% already have half the spectrum but we need to scale it correctly).

if rem( nfft, 2 ) %fft is odd length
  % Don't double DC component
  mp = [ map( 1, : ); sqrt(2)*map( 2:end, : ) ];
else
  % Don't double DC component or unique Nyquist point
  mp = [ map( 1, : ); sqrt(2)*map( 2:end - 1, : ); map( end, : ) ];
end
end

%--------------------------------------------------------------------------
function winfun = getWinFunction(win,winParam)
if strcmp(win,'kaiser') || strcmp(win,'chebwin')
  winname = str2func(win);
  winfun = @(x) winname(x,winParam);
else
  winfun = str2func(win);
end
end


