function [timeRes, segLen] = getWinDurationForAGivenRBW(desiredRBW,win,winParam,Fs,isKaiserBeta)
% getWinDurationForAGivenRBW Compute window duration for a given RBW value.
%   This function is for internal use only. It may be removed in the future.

%   Copyright 2015 The MathWorks, Inc.

% If isKaiserBeta is true then the winParam input will be interpreted as
% Kaiser window beta parameter instead of a sidelobe attenuation value. If
% not specified this flag defaults to false. This input is irrelevant if
% win is not 'kaiser'.

% Segment length will depend on ENBW (which in turns depends on segment
% length). Thus, an initial ENBW is obtained using a segment length of
% 1000

if nargin < 5
  isKaiserBeta = false;
end 

ENBW = getENBW(1000, win, winParam, isKaiserBeta);

% Compute segment length
segLen = ceil(ENBW*Fs/desiredRBW);

% Iterate over segment length to minimize
% error between requested RBW and actual RBW:
count = 1;
segLenVect = segLen;
while(count<100) % protect against very long convergence
  new_segLen = ceil(getENBW(ceil(segLen),win,winParam,isKaiserBeta) * Fs/ desiredRBW);
  err = abs(new_segLen - segLen);
  if (err == 0) % we have converged
    segLen = new_segLen;
    timeRes = segLen/Fs;
    break;
  end
  if ~any(segLenVect == new_segLen)
    segLenVect = [ segLenVect new_segLen]; %#ok<AGROW>
    segLen = new_segLen;
    count = count + 1;
  else
    % We hit a previously computed segment length. The sequence
    % will repeat. Break out and select the segment length that
    % minimizes the error
    L = length(segLenVect);
    computed_RBW = zeros(L,1);
    for ind=1:L
      % Get RBW corresponding to segLenVect(ind)
      computed_RBW(ind) = getENBW(segLenVect(ind),win,winParam,isKaiserBeta) * Fs / segLenVect(ind);
    end
    % Select segment length that minimizes absolute error between
    % actual and desired RBW:
    RBWErr = abs(desiredRBW -  computed_RBW);
    [~,ind_min] = min(RBWErr);
    segLen = segLenVect(ind_min);
    timeRes = segLen/Fs;
    break;
  end
end

if count == 100
  error(message('measure:SpectrumAnalyzer:MinTimeResConvergence'));
end
 %------------------------------------------------------------------------  
  function ENBW = getENBW(L, Win, winParam, isKaiserBeta)
  % Get window parameters based on a segment legnth L
  % The optional string argument 'beta' specifies that the value in
  % sideLobeAttn is the beta parameter. This was do to maintain backwards
  % compatibility.
  
    switch lower(Win)
      case {'rectangular','rectwin'}
        ENBW = 1;
      case 'hann'
        w = hann(L);
        ENBW = (sum(w.^2)/sum(w)^2)*L;    
      case 'hamming'
        w = hamming(L);
        ENBW = (sum(w.^2)/sum(w)^2)*L;    
      case {'flat top', 'flattopwin'}        
        w = flattopwin(L);
        ENBW = (sum(w.^2)/sum(w)^2)*L; 
      case {'chebyshev','chebwin'}
        w = chebwin(L,winParam);
        ENBW = (sum(w.^2)/sum(w)^2)*L;
      case 'kaiser'
        if isKaiserBeta
          % Input winParam is actually kaiser beta
          beta = winParam;
        else
          % Input winParam is trully a sidelobe attenuation value so
          % convert it to beta
          beta = signal.internal.kaiserBeta(winParam);    
        end    
        w = kaiser(L,beta);
        ENBW = (sum(w.^2)/sum(w)^2)*L;
        
    end    
    
    
