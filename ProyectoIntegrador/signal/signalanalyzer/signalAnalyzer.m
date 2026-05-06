function signalAnalyzer(varargin)
%SIGNALANALYZER Visualize and compare multiple signals
%   SIGNALANALYZER opens the Signal Analyzer App.
%
%   SIGNALANALYZER(SIG) opens the Signal Analyzer App and imports and plots
%   the signal SIG. If the app is already open, then it plots SIG in the
%   currently active display. SIG can be a vector or a matrix with
%   independent signals in each column.
%
%   NOTE: Signals are imported in samples and displayed versus sample index
%   by default. If time information is provided (see below), then the app
%   plots the signal against time. If a signal has been previously
%   imported, then its time information cannot be changed programmatically.
%
%   SIGNALANALYZER(SIG1,SIG2,...,SIGN) imports N signal vectors or matrices
%   and plots them in the currently active display.
%
%   SIGNALANALYZER(...,'SampleRate',Fs) specifies a sample rate, Fs, as a
%   positive scalar expressed in Hz. The app uses the sample rate to plot
%   the signals against time, assuming a start time of zero seconds.
%
%   SIGNALANALYZER(...,'SampleTime',Ts) specifies a sample time, Ts, as a
%   positive scalar expressed in seconds. The app uses the sample time to
%   plot the signals against time, assuming a start time of zero seconds.
%
%   SIGNALANALYZER(...,'StartTime',ST) specifies a signal start time, ST,
%   as a nonnegative scalar expressed in seconds. If you do not specify a
%   sample rate or sample time, then the app assumes a sample rate of 1 Hz.
%
%   % EXAMPLE:
%   %   Load a data set containing a helicopter cabin vibration
%   %   signal, vib, sampled at a rate fs. Import 
%   %   the signal from the workspace to Signal Analyzer by passing it as 
%   %   the first argument to a function call. Import a detrended version 
%   %   of the signal as the second argument. Assign the sample rate to 
%   %   both signals. Signal Analyzer chooses a variable name (e.g. 'sig1') 
%   %   for the second input since it is not associated with a workspace 
%   %   variable.
%   load('helidata.mat');
%   signalAnalyzer(vib,detrend(vib),'SampleRate',fs)

%   Copyright 2015-2016 The MathWorks, Inc.

nargoutchk(0,0);

% Find the number of input signals. All inputs up to the first string are
% considered input signals.
N = find(cellfun(@(x) ischar(x),varargin),1)-1;
if N == 0
  error(message('SDI:sigAnalyzer:SigAsString'));
elseif isempty(N)
  N = nargin; 
end

validateSignals(varargin{1:N})
[Fs,Ts,St,mode] = parsePairs(varargin{N+1:end});

% Extract signal names. Empty names will be given default names in
% updateRepository. Cast signals to double and store them in sigVals.
% updateRespository will access sigVals using evalin.
sigNames = cell(N,1);
sigVals = cell(N,1);
for i = 1:N
  sigNames{i} = inputname(i); 
  sigVals{i} = double(varargin{i});
end

signalAnalyzerImpl(Fs,Ts,St,mode,sigNames,sigVals);

end

%--------------------------------------------------------------------------
function validateSignals(varargin)
  % Validate attributes for input signals
  for i = 1:length(varargin)
    validateattributes(varargin{i},{'numeric','embedded.fi', 'logical'}, ...
        {'2d','real','finite','nonempty', 'nonsparse'},'','SIG');
    if isscalar(varargin{i})
      error(message('SDI:sigAnalyzer:NoScalarSignal'));
    end
  end
end

%--------------------------------------------------------------------------
function [Fs,Ts,St,mode] = parsePairs(varargin)
  % Check that length of the input is even
  
  % Parse name-value pairs
  p = inputParser;
  p.addParameter('SampleRate',[]);
  p.addParameter('SampleTime',[]);
  p.addParameter('StartTime',[]);
  parse(p,varargin{:});
  vals = p.Results;
  Fs = vals.SampleRate;
  Ts = vals.SampleTime;
  St = vals.StartTime;
  
  if ~isempty(Fs)&&~isempty(Ts)
      error(message('SDI:sigAnalyzer:BothRateAndTime'));
  end
  
  if ~isempty(Fs)
    validateattributes(Fs,{'numeric'},{'real','scalar','positive','finite'},'','Fs');
    mode = 'fs';
    if isempty(St)
      St = 0;
    else
      validateattributes(St,{'numeric'},{'real','scalar','finite','nonnegative'},'','ST');
    end
  elseif ~isempty(Ts)
    validateattributes(Ts,{'numeric'},{'real','scalar','positive','finite'},'','Ts');
    mode = 'ts';
    if isempty(St)
      St = 0;
    else
      validateattributes(St,{'numeric'},{'real','scalar','finite','nonnegative'},'','ST');
    end
  elseif ~isempty(St)
    validateattributes(St,{'numeric'},{'real','scalar','finite','nonnegative'},'','ST');
    mode = 'fs';
    Fs = 1;
  else
    mode = 'samples';
  end
  
  % Cast to double
  Fs = double(Fs);
  Ts = double(Ts);
  St = double(St);
  
end