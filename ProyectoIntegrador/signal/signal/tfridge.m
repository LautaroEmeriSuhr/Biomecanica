function varargout = tfridge(tfm,f,varargin)
%TFRIDGE Extract time-frequency ridges 
%   FRIDGE = TFRIDGE(TFM,F) extracts the maximum energy time-frequency
%   ridge, FRIDGE, from the time-frequency matrix, TFM, and the frequency
%   vector, F. The length of F should be equal to the number of rows of
%   TFM. FRIDGE contains the frequencies corresponding to the maximum
%   energy time-frequency ridge at each sample, and has a length equal to
%   the number of columns of TFM.
%
%   [FRIDGE,IRIDGE] = TFRIDGE(TFM,F) returns the row indices in TFM
%   corresponding to the maximum time-frequency ridge at each sample. 
%
%   [...] = TFRIDGE(TFM,F,PENALTY) penalizes changes in frequency by
%   scaling the squared distance between frequency bins by the nonnegative
%   scalar PENALTY. If unspecified, PENALTY defaults to 0.
%
%   [...] = TFRIDGE(...,'NumRidges',NR) extracts the NR highest energy
%   time-frequency ridges. NR is a positive integer. If NR is greater than
%   1, TFRIDGE iteratively determines the maximum energy time-frequency
%   ridge by removing the previously computed ridges +/- 4 frequency bins.
%   FRIDGE and IRIDGE are N-by-NR matrices, where N is the number of time
%   samples (columns) in SST. The first column of the matrices contains the
%   frequencies or indices for the maximum energy time-frequency ridge in
%   TFM. Subsequent columns contain the frequencies or indices for the
%   time-frequency ridges in decreasing energy order. You can specify the
%   name-value pair NumRidges anywhere in the input argument list after the
%   time-frequency matrix, TFM.
%
%   [...] = TFRIDGE(...,'NumRidges',NR,'NumFrequencyBins',NBINS) specifies
%   the number of adjacent frequency bins to remove from TFM when
%   extracting multiple ridges. NBINS is a positive integer less than or
%   equal to round(size(TFM,1)/4). Specifying NBINS is only valid when you
%   extract more than one ridge. After extracting the highest-energy ridge,
%   TFRIDGE removes it +/- NBINS from TFM before extracting the next ridge.
%   If the index of the time-frequency ridge +/- NBINS exceeds the number
%   of frequency bins at any time step, TFRIDGE truncates the removal
%   region at the first or last frequency bin. If unspecified, NBINS
%   defaults to 4.
%
%   % Example 
%   %   Extract the instantaneous frequency of the modes of a
%   %   multicomponent signal using Fourier synchrosqueezing and 
%   %   plot the result.
%   fs = 3000; 
%   t=0:1/fs:1-1/fs; 
%   x1 = 2*chirp(t,500,t(end),1000); 
%   x2 = chirp(t,400,t(end),800);
%   [sst,f] = fsst(x1+x2,fs,kaiser(512,10)); 
%   fridge = tfridge(sst,f,10,'NumRidges',2); 
%   plot(t,fridge) 
%   xlabel('Time (s)'), ylabel('Frequency (Hz)') 
%   title('Instantaneous Frequency') 
%   legend('Chirp 1','Chirp 2') 
%
%   See also IFSST, FSST.

%   Copyright 2015-2016 MathWorks, Inc.

narginchk(2,7);
nargoutchk(0,2);

f = f(:);

[tfm,penalty,f,nr,nbins] = parseInputs(tfm,f,varargin{:});

validateInputs(tfm,f,penalty,nr,nbins);

% Call ExtractRidges
iridge = signalwavelet.extractRidges(tfm,penalty,nr,nbins);

% Create output frequency vector
varargout{1} = f(iridge);

if nargout == 2
  varargout{2} = iridge;
end
  
%--------------------------------------------------------------------------
function [tfm,penalty,f,nr,nbins] = parseInputs(tfm,f,varargin)

penalty = 0;
nr = 1;
nbins = [];

% Parse n-v pairs. 
validNames = {'NumRidges','NumFrequencyBins'};
iNameValue = find(cellfun(@ ischar,varargin),length(validNames));
iNameValue = [iNameValue;iNameValue+1];
[nr,nbins] = parsePairs(varargin(iNameValue(:)),validNames,nr,nbins);
varargin(iNameValue(:)) = [];

% Parse the remaining inputs
switch length(varargin)
  case 0
    % No Op
  case 1
    penalty = varargin{1};
end    

% Assign default nbins if nr is greater than 1
if nr > 1 && isempty(nbins)
  nbins = 4;
end

%--------------------------------------------------------------------------
function validateInputs(tfm,f,penalty,nr,nbins)

validateattributes(tfm,{'single','double'},...
{'nonsparse','finite','nonempty','nonnan'},'tfridge','TFM');
validateattributes(f,{'single','double'},...
  {'real','finite','nonnan','vector'},'tfridge','F');
validateattributes(penalty,{'numeric'},...
  {'finite','nonnan','nonempty','nonnegative'},'tfridge','PENALTY');
validateattributes(nr,{'numeric'},...
  {'finite','nonnan','nonempty','positive','integer'},'tfridge','NR');
validateattributes(nbins,{'numeric'},...
  {'finite','nonnan','positive','integer'},'tfridge','NBINS');

% Warn if nbins is specified and nr is 1
if nr == 1 && ~(isempty(nbins))
  warning(message('signal:tfridge:nbinsIgnored'));
end

%--------------------------------------------------------------------------
function [varargout] = parsePairs(nvp,validNames,varargin)
% Varargin contains variables in the order corresponding to the names in
% the string cell array validNames

% By default, pass through unchanged
varargout = varargin;

names = nvp(1:2:end);
values = nvp(2:2:end);

% Validate the names ane make sure they are unique
names = cellfun(@(x) validatestring(x,validNames,'tfridge',''),names,...
  'UniformOutput',false);

if ~isequal(sort(names),unique(names))
  error(message('signal:tfridge:UnrecognizedString'));
end

% Assign varargout based on matches between names and validNames
for i = 1:length(names)
  iName = strcmp(names{i},validNames);
  varargout{iName} = values{i};
  validNames{iName} = [];
end



  