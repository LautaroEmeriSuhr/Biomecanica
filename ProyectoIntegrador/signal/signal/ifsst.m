function xrec = ifsst(sst,varargin)
%IFSST Inverse Fourier synchrosqueezed transform
%   XREC = IFSST(SST) returns the inverse of the Fourier synchrosqueezed
%   transform matrix, SST. XREC is a 1-by-N vector, where N is the number
%   of columns in SST. XREC is reconstructed using the default window and
%   the entire time-frequency plane.
%
%   XREC = IFSST(SST,WINDOW) reconstructs the signal whose SST was computed
%   by FSST using WINDOW. WINDOW is a positive vector containing the window
%   function or a scalar specifying the length of a Kaiser window with a
%   beta parameter of 10. You can leave WINDOW unspecified or as an empty
%   array in IFSST and the default Kaiser window will be used. 
%
%   XREC = IFSST(SST,WINDOW,F,FREQRANGE) uses the frequency vector F and
%   the two-element vector FREQRANGE to invert the synchrosqueezed
%   transform. F is the vector of frequencies corresponding to the rows of
%   SST. The synchrosqueezed transform is inverted for the bins in SST with
%   frequencies in FREQRANGE. FREQRANGE is a two-element vector with
%   strictly increasing values and must lie in the range of F.
%
%   XREC = IFSST(SST,WINDOW,IRIDGE) inverts the synchrosqueezed transform
%   along the time-frequency ridges specified by the index vector or matrix
%   IRIDGE. IRIDGE is an output of TFRIDGE. If IRIDGE is a matrix, IFSST
%   first inverts the synchrosqueezed transform along the first column of
%   IRIDGE, then iteratively reconstructs along subsequent columns of
%   IRIDGE. XREC has the same size as IRIDGE.
%
%   XREC = IFSST(SST,WINDOW,IRIDGE,'NumFrequencyBins',NBINS) specifies the
%   number of frequency bins on each side of IRIDGE to use in the
%   reconstruction. If the index of the time-frequency ridge +/- NBINS
%   exceeds the range of frequency bins at any time step, IFSST truncates
%   the reconstruction at the first or last frequency bin. If unspecified,
%   NBINS defaults to 4. The name-value pair 'NumFrequencyBins', NBINS is
%   valid only if you provide the IRIDGE input.
%
%   % Example 1
%   %   Extract and reconstruct each of two signal components using the
%   %   Fourier synchrosqueezed transform.  
%   fs = 3000; 
%   t = 0:1/fs:1-1/fs; 
%   x1 = 2*chirp(t,500,t(end),1000); 
%   x2 = chirp(t,400,t(end),800); 
%   [sst,f] = fsst(x1+x2,fs);
%
%   %   Extract a ridge for each component.
%   [~,iridge] = tfridge(sst,f,'NumRidges',2);
%
%   %   Reconstruct a waveform for each ridge.
%   xrec = ifsst(sst,[],iridge);
%
%   %   Plot the extracted waveforms.
%   figure, subplot(2,1,1)
%   plot(t,xrec(:,1))
%   title('Waveform Extraction')
%   xlabel('Time (s)'), ylabel('Amplitude')
%   legend('Chirp 1')
%   grid
%   subplot(2,1,2)
%   plot(t,xrec(:,2),'Color',[0.85 0.325 0.098])
%   xlabel('Time (s)'), ylabel('Amplitude')
%   legend('Chirp 2')
%   grid
%
%   % Example 2
%   %   Compute the Fourier synchrosqueezed transform of a speech signal.
%   %   Invert the transform to reconstruct the signal, plot the
%   %   reconstructed signal, and compare the original and reconstructed 
%   %   signals using the L-infinity norm.
%   
%   %   Load the speech signal and compute the synchrosqueezed transform.
%   load mtlb
%   [sst,f] = fsst(mtlb,Fs);
%
%   %   Invert the synchrosqueezed transform and reconstruct the signal.
%   xrec = ifsst(sst);
%
%   %   Plot the orignal and reconstructed signals.
%   t = (0:length(mtlb)-1)/Fs;
%   plot(t,mtlb,t,xrec)
%   xlabel('Time (s)')
%   legend('Original','Reconstructed')
%   title('Original and Reconstructed Speech Signals')
%   
%   %   Compute the L-infinity norm of the difference between original and
%   %   reconstructed signals.
%   Linf = norm(abs(mtlb-xrec),Inf)
%
%   See also fsst, tfridge.

% Copyright 2015-2016 MathWorks, Inc.

narginchk(1,5);
nargoutchk(0,1);

[win,iridge,f,freqrange,nfft,nbins,fReal] = parseInputs(sst,varargin{:});

validateInputs(sst,win,iridge,f,freqrange,nbins);

% Cast to enforce precision rules
% The output xrec will be single only if the input sst is single. If the
% window used was single, sst would be single.
win = double(win);

% Convert to column vectors
win = win(:);
f = f(:);
freqrange = freqrange(:);

% Compute window scale factor, frequency interval, and real input flag
g0 = win(round(length(win)/2)); 
df = 1/nfft;

% Determine the last index to use in the second side of the spectrum.
% For an even length fft, the one-sided spectrum has (nfft/2)+1 elements,
% while for an odd length fft, the one-sided spectrum has (nfft+1)/2
% elements.
if mod(nfft,2)
  iend = size(sst,1);
else
  iend = size(sst,1)-1;
end
% Extract ridges if provided
if ~isempty(iridge)
  xrec = zeros(size(iridge));
  for j = 1:size(iridge,2)
    Mask = zeros(size(sst));
    for i = 1:size(iridge,1)
       Mask(max(iridge(i,j)-nbins,1):min(iridge(i,j)+nbins,size(sst,1)),i) = 1;
    end
    % Do the inverse 
    maskSST = sst.*Mask;
    if fReal
      xrec(:,j) = 1/g0*df*real(sum(maskSST)+ ...
        conj(sum(maskSST(2:iend,:))))';
    else
      xrec(:,j) = 1/g0*df*(sum(maskSST)).';  
    end
  end
elseif ~isempty(freqrange);
  [~,i1] = min(abs(f - freqrange(1)));  
  [~,i2] = min(abs(f - freqrange(2)));
   % Do the inverse 
    if fReal
      xrec = 1/g0*df*real(sum(sst(i1:i2,:)) + ...
        conj(sum(sst(max(i1,2):min(i2,iend),:))));
    else
      xrec = 1/g0*df*(sum(sst(i1:i2,:)));
    end
  xrec = xrec(:);
else
  % Do the inverse 
  if fReal
    xrec = 1/g0*df*real(sum(sst) + conj(sum(sst(2:iend,:))));
  else
    xrec = 1/g0*df*(sum(sst));
  end
  xrec = xrec(:);
end

%--------------------------------------------------------------------------
function [win,iridge,f,freqrange,nfft,nbins,fReal] = parseInputs(sst,varargin)

sstSize=size(sst);

if sstSize(2) < 256
   win = kaiser(sstSize(2),10);
else
   win = kaiser(256,10);
end

iridge = [];
f = [];
freqrange = [];
nbins = 4; %#ok<*NASGU>

if nargin > 1
  % The first optional argument is WINDOW
    win = getWin(varargin{1},win);
end

if nargin == 3
  % This is a ridge
    iridge = varargin{2};
end

if nargin == 4
  % This F and FREQRANGE
  if ~ischar(varargin{3})
    f = varargin{2};
    freqrange = varargin{3};
  else
    error(message('signal:ifsst:NVMustBeEven'));
  end
end

if nargin == 5
  iridge = varargin{2};
  % This is ridge and name-value pair
  validatestring(varargin{3},{'NumFrequencyBins'});
  nbins = varargin{4};
end

nfft = length(win);

if sstSize(1) == nfft
  fReal = false;
else
  fReal = true;
end

%--------------------------------------------------------------------------
function win = getWin(newwin,currentWin)
  if isempty(newwin)
    win = currentWin;
  elseif isscalar(newwin)
      validateattributes(newwin,{'single','double'},{'positive'},'ifsst','WINDOW');
      win = kaiser(newwin,10);
  else
    win = newwin;
  end
%--------------------------------------------------------------------------
function validateInputs(sst,win,iridge,f,freqrange,nbins)

validateattributes(sst,{'single','double'},...
  {'nonsparse','finite','nonnan','nonempty'},'ifsst','SST');
validateattributes(win,{'single','double'},...
  {'real','finite','nonnegative','nonnan','vector'},'ifsst','WINDOW');

if ~isempty(iridge)
  validateattributes(iridge,{'single','double'},...
    {'real','positive','integer','nonsparse','finite','nonnan'},'ifsst','IRIDGE');
end
if ~isempty(f) || ~isempty(freqrange)
  validateattributes(f,{'single','double'},...
    {'real','finite','nonnan','vector'},'ifsst','F');
  validateattributes(freqrange,{'single','double'},...
    {'real','finite','nonnan','vector'},'ifsst','FREQRANGE');
end
validateattributes(nbins,{'numeric'},...
  {'real','positive','integer','finite','nonnan','scalar','nonempty'},'ifsst','BINS');

% check that sst is a matrix. fsst has a minimum signal size of 2, which
% will produce a 2x2 array.
if isvector(sst)
  error(message('signal:ifsst:SSTisVector'));
end  

% Window length matches the size of sst
sizeSST = size(sst);
winLen = length(win);

% Expected window length for a real signal
if mod(winLen,2)
  winLenReal = 2*sizeSST(1)-1; 
else
  winLenReal = 2*(sizeSST(1)-1); 
end

if ~(winLen == sizeSST(1) || winLen == winLenReal)
  error(message('signal:ifsst:winLen'));
end

% Size of f matches SST
if ~isempty(f) && ~(length(f) == size(sst,1))
  error(message('signal:ifsst:fSize'));
  % The length of F must match the number of rows of SST. 
end

% Size of iridge matches SST
if ~isempty(iridge) && ~(size(iridge,1) == size(sst,2))
  error(message('signal:ifsst:iridgeSize'));
  % The number of rows of IRIDGE must match the number of rows of SST.
end

% Length of freqrange is 2, values are within the range of f and strictly
% increasing
if ~isempty(freqrange) && (~(length(freqrange) == 2) || ... 
  freqrange(2) <= freqrange(1) || freqrange(1) < f(1) || freqrange(2) > f(end)) 
  error(message('signal:ifsst:freqrange'));
end

