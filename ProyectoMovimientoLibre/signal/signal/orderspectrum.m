function varargout = orderspectrum(varargin)
%ORDERSPECTRUM Average spectrum versus order for a vibration signal
%   SPEC = ORDERSPECTRUM(X,Fs,RPM) computes an average order magnitude
%   spectrum vector, SPEC, for the signal vector, X. X has a sample rate of
%   Fs in hertz and is measured at a set of rotational speeds in
%   revolutions per minute specified in the vector RPM. By default, values
%   of SPEC correspond to root-mean-square (RMS) amplitudes given in linear
%   scale. To compute the spectrum, the function windows a constant-phase
%   resampled version of X using a flattop window.
%
%   [SPEC,ORDER] = ORDERSPECTRUM(X,Fs,RPM) returns the vector of orders,
%   ORDER, corresponding to each average spectrum value in SPEC.
%
%   [...] = ORDERSPECTRUM(MAP,ORDER) computes an average order magnitude
%   spectrum, SPEC, based on an order map matrix, MAP, and order vector,
%   ORDER, which may be computed using the RPMORDERMAP function. MAP must
%   have linear scale, and root-mean-squared amplitude is assumed. The
%   length of ORDER must match the number of rows of MAP. SPEC has the same
%   amplitude and scaling as MAP.
%
%   [...] = ORDERSPECTRUM(MAP,ORDER,'Amplitude',AMP) computes an average
%   order magnitude spectrum based on an order map matrix, MAP, with
%   root-mean-squared amplitudes when AMP is set to 'rms', peak
%   amplitudes when AMP is set to 'peak', and power levels when AMP is set
%   to 'power'. If AMP is not specified, the default is 'rms'.
%
%   ORDERSPECTRUM(...) with no output arguments plots the averge order
%   spectrum on the current figure.
%
%   % EXAMPLE:
%   %   Compute and plot an order spectrum for simulated helicopter 
%   %   vibration data.
%   load('helidata.mat')
% 
%   % Remove the DC bias from the vibration signal.
%   vib = detrend(vib);
% 
%   % Compute and visualize the order spectrum with the default resolution.
%   orderspectrum(vib,fs,rpm)
%
%   % Compute an rpm-order map with a resolution of 0.005 orders.
%   [map,order] = rpmordermap(vib,fs,rpm,0.005);
%
%   % Plot the order spectrum with a resolution of 0.005 orders.
%   hold on
%   orderspectrum(map,order)
%   legend('Spectrum from signal','Spectrum from map')
%
%   See also RPMORDERMAP, ORDERTRACK, TACHORPM, ORDERWAVEFORM

%   References:
%     [1] Brandt, Anders. Noise and Vibration Analysis: Signal Analysis 
%         and Experimental Procedures. Chichester, UK: John Wiley & Sons,
%         2011.

% Copyright 2015-2016 MathWorks, Inc.

narginchk(2,4);
nargoutchk(0,2);

if nargin == 4 || nargin == 2
  map = varargin{1};
  order = varargin{2};
  varargin(1:2) = [];
  x = [];
  fs = [];
  rpm = [];
  inputType = 'map';
  p = inputParser; 
  p.addOptional('Amplitude','rms');
  p.parse(varargin{:});
  amp = validatestring(p.Results.Amplitude,{'rms','peak','power'});
else
  x = varargin{1};
  fs = varargin{2};
  rpm = varargin{3};
  map = [];
  order = [];
  amp = 'rms';
  inputType = 'signal';
end
  
validateInputs(x,fs,rpm,map,order,inputType);

% Cast to enforce precision rules (we already checked that the inputs are
% numeric.)
rpm = double(rpm);
fs = double(fs);
x = x(:);
order = order(:);
rpm = rpm(:);

% If the input type is 'signal', compute the map and order vector
if strcmp(inputType,'signal')
  [map,order] = rpmordermap(x,fs,rpm);
end

% Compute the order spectrum
switch lower(amp)
  case {'rms','peak'}
    % Square the map, average, then square root. This is equivalent to
    % converting to power, averaging, and converting back for both rms and
    % peak since scaling constants, e.g. sqrt(2), are not affected.
    spec = sqrt(mean(map.^2,2));
  case 'power'
    spec = mean(map,2);
end

if nargout == 0
  plot(order,spec);
  grid on;
  xlabel(getString(message('signal:rpmmapplot:onumber')))
  switch lower(amp)
    case 'rms'
      yLabString = getString(message('signal:rpmmapplot:orderrms'));
    case 'power'
      yLabString = getString(message('signal:rpmmapplot:orderpower'));
    case 'peak'
      yLabString = getString(message('signal:rpmmapplot:orderpeak'));
  end
  ylabel(yLabString);
  title(getString(message('signal:rpmmapplot:aorderspectrum')))
  grid on;
elseif nargout == 1
  varargout{1} = spec;
else
  varargout{1} = spec;
  varargout{2} = order;
end
%--------------------------------------------------------------------------
function validateInputs(x,fs,rpm,map,order,inputType)
if strcmp(inputType,'signal')
  validateattributes(x,{'single','double'},...
    {'real','nonsparse','finite','nonnan','vector'},'orderspectrum','X');
  validateattributes(fs,{'numeric'},...
    {'real','positive','nonsparse','finite','nonnan','scalar'},'orderspectrum','Fs');
  validateattributes(rpm,{'numeric'},...
    {'real','positive','nonsparse','finite','nonnan','vector'},'orderspectrum','RPM');
  
  % Check rpm is the same size and x
  if length(x)~=length(rpm)
    error(message('signal:rpmmap:MustBeSameLength'));
  end
else
  validateattributes(map,{'single','double'},...
    {'real','nonsparse','finite','nonnan','nonempty'},'orderspectrum','MAP');
  validateattributes(order,{'single','double'},...
    {'real','nonnegative','nonsparse','finite','nonnan','vector'},...
    'orderspectrum','ORDER');
  % Check map and order have consistent dimensions
  if ~(size(map,1)==length(order))
    error(message('signal:rpmmap:OrderMatchMap'));
  end
  % Check that order has at least two elements.
  if length(order)<2
    error(message('signal:rpmmap:OrderLength'));
  end
  
end
