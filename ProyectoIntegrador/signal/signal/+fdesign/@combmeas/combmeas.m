classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) combmeas < fdesign.abstractmeas & dynamicprops
%COMBMEAS Construct a COMBMEAS object.

%   Copyright 2004-2015 The MathWorks, Inc.  
  
%fdesign.combmeas class
%   fdesign.combmeas extends fdesign.abstractmeas.
%
%    fdesign.combmeas properties:
%       NormalizedFrequency - Property is of type 'bool' (read only) 
%       Fs - Property is of type 'mxArray' (read only) 
%       BW - Property is of type 'mxArray' (read only) 
%       Q - Property is of type 'mxArray' (read only) 
%       GBW - Property is of type 'mxArray' (read only) 
%       Gref - Property is of type 'mxArray' (read only) 
%
%    fdesign.combmeas methods:
%       getprops2norm - LIZE   Return the property name to normalize.
%       setprops2norm - LIZE   Return the property name to normalize.


properties (SetAccess=protected, AbortSet, SetObservable, GetObservable)
  %BW Property is of type 'mxArray' (read only)
  BW = [];
  %Q Property is of type 'mxArray' (read only)
  Q = [];
  %GBW Property is of type 'mxArray' (read only)
  GBW = [];
  %GREF Property is of type 'mxArray' (read only)
  Gref = [];
end


methods  % constructor block
  function this = combmeas(hfilter, varargin)
    %PEAKNOTCHMEAS   Construct a COMBMEAS object.


    narginchk(1,inf);

    % this = fdesign.combmeas;

    % Parse the inputs.
    minfo = parseconstructorinputs(this, hfilter, varargin{:});
    N = minfo.FilterOrder;

    if this.NormalizedFrequency
        Fs = 2;
    else
        Fs = this.Fs;
    end

    [H,w] = freqz(hfilter,32768,Fs);
    HdB = 20*log10(abs(H));

    %Measure BW
    % Get freq. range in which to search (first peak or notch centered at zero)
    idx = w < (1/N)*(Fs/2);
    wL = w(idx);
    HbwL = HdB(idx);
    [dummy,idxL] = min(abs(HdB(idx)-minfo.GBW));
    idxL = idxL(1);
    if idxL > 1
        if isequal(lower(minfo.CombType),'peak')
            if HbwL(idxL) > minfo.GBW
               X = [HbwL(idxL) HbwL(idxL+1)];
               Y = [wL(idxL) wL(idxL+1)];
            else
               X = [HbwL(idxL-1) HbwL(idxL)];
               Y = [wL(idxL-1) wL(idxL)];
            end
        else %notch
            if HbwL(idxL) > minfo.GBW
               X = [HbwL(idxL-1) HbwL(idxL)];
               Y = [wL(idxL-1) wL(idxL)];            
            else
               X = [HbwL(idxL) HbwL(idxL+1)];
               Y = [wL(idxL) wL(idxL+1)];            
            end
        end  
        X(X==-inf) = -3000; %to avoid NaN errors in tostring functions
        p = polyfit(X,Y,1);            
        this.BW = 2*polyval(p,minfo.GBW);
        this.GBW = minfo.GBW;        
    else
        this.BW = 2*wL(idxL);
        this.GBW = HbwL(idxL);
    end

    if N>1
        this.Q = (2/N)*(Fs/2)/this.BW;
    else
        this.Q = [];
    end

    %Measure peak/notch positions and their respective magnitudes
    %Find windows for each peak/notch
    %Measure frequency position and magnitude value at each window
    %Measure reference gain and peak/notch gain
    if isequal(lower(minfo.CombType),'notch')    
        this.Gref = 20*log10(max(abs(H)));
        this = measureFreqs(this,HdB,w,N,Fs,'notch');   
    else
        this.Gref = 20*log10(min(abs(H)));   
        this = measureFreqs(this,HdB,w,N,Fs,'peak');   
    end

  end

    %-------------------------------------------------------------------------p
    %,

end  % constructor block

methods 
  function set.BW(obj,value)
  obj.BW = value;
  end
  %------------------------------------------------------------------------
  function set.Q(obj,value)
  obj.Q = value;
  end
  %------------------------------------------------------------------------
  function set.GBW(obj,value)
  obj.GBW = value;
  end
  %------------------------------------------------------------------------
  function set.Gref(obj,value)
  obj.Gref = value;
  end

end   % set and get functions 

methods  % public methods
  props2norm = getprops2norm(this)
  setprops2norm(this,props2norm)
end  % public methods 

end  % classdef

function this = measureFreqs(this,HdB,w,N,Fs,ctype)
  %Measure position and magnitude of peak or notch frequencies

  if ~rem(N,2)
      K = (N/2)+1;
  else
      K = (N+1)/2;
  end

  mGains = zeros(1,K);
  mFreqs = zeros(1,K);

  for k = 1:K
      idx = (w>=0)&(w>(2*k-3)*(Fs/2)/N) & (w < (2*k-1)*(Fs/2)/N) & (w<=Fs/2);
      W = w(idx);
      Hw = HdB(idx);
      if isequal(ctype,'notch')
          [mag, idx2] = min(Hw);
      else
          [mag, idx2] = max(Hw);
      end
      mGains(k) = mag(1);
      mFreqs(k) = W(idx2(1));
      clear W Hw
  end

  %Create dynamic private properties depending on whether we have a peak or
  %notch comb filter. Set the corresponding properties with the measured
  %gains and frequency values. 
  if isequal(ctype,'notch')
    p = addprop(this, 'Gnotch');
    p.GetObservable = 1; 
    p.SetObservable = 1;
    p.AbortSet = 1;
    p.NonCopyable = 0;
    p.Hidden = 0;
    p.SetAccess = 'protected';
    this.Gnotch = mGains;

    
    % 
    p = addprop(this, 'NotchFrequencies');
    p.GetObservable = 1; 
    p.SetObservable = 1;
    p.AbortSet = 1;
    p.NonCopyable = 0;
    p.Hidden = 0;
    p.SetAccess = 'protected';
    this.NotchFrequencies = mFreqs;

  else
    p = addprop(this, 'Gpeak');
    p.GetObservable = 1; 
    p.SetObservable = 1;
    p.AbortSet = 1;
    p.NonCopyable = 0;
    p.Hidden = 0;
    p.SetAccess = 'protected';
    this.Gpeak = mGains;
% 
    p = addprop(this, 'PeakFrequencies');
    p.GetObservable = 1; 
    p.SetObservable = 1;
    p.AbortSet = 1;
    p.NonCopyable = 0;
    p.Hidden = 0;
    p.SetAccess = 'protected';
    this.PeakFrequencies = mFreqs;

  end

    
end


