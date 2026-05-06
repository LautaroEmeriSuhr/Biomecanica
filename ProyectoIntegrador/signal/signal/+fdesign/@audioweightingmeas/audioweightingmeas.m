classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) audioweightingmeas < fdesign.abstractmeas
%AUDIOWEIGHTINGMEAS  Construct an AUDIOWEIGHTINGMEAS object.

%   Copyright 2004-2015 The MathWorks, Inc.    
  
%fdesign.audioweightingmeas class
%   fdesign.audioweightingmeas extends fdesign.abstractmeas.
%
%    fdesign.audioweightingmeas properties:
%       NormalizedFrequency - Property is of type 'bool' (read only) 
%       Fs - Property is of type 'mxArray' (read only) 
%       Frequencies - Property is of type 'mxArray' (read only) 
%       Magnitudes - Property is of type 'mxArray' (read only) 
%
%    fdesign.audioweightingmeas methods:
%       getprops2norm - LIZE   Return the property name to normalize.
%       isspecmet -   True if the object is specmet.
%       setprops2norm - LIZE   Return the property name to normalize.


properties (GetAccess=protected, AbortSet, SetObservable, GetObservable, Hidden)
  %FREQUENCIESINTERP Property is of type 'mxArray' (hidden)
  FrequenciesInterp = [];
  %MAGNITUDESINTERP Property is of type 'mxArray' (hidden)
  MagnitudesInterp = [];
end

properties (SetAccess=protected, AbortSet, SetObservable, GetObservable)
  %FREQUENCIES Property is of type 'mxArray' (read only)
  Frequencies = [];
  %MAGNITUDES Property is of type 'mxArray' (read only)
  Magnitudes = [];
end


methods  % constructor block
  function this = audioweightingmeas(hfilter, varargin)
    %AUDIOWEIGHTINGMEAS   Construct a AUDIOWEIGHTINGMEAS object.


    narginchk(1,inf);

    % this = fdesign.audioweightingmeas;

    % Parse the inputs.
    minfo = parseconstructorinputs(this, hfilter, varargin{:});

    % Measure attenuations at the frequencies specified by the standards
    Resp = freqz(hfilter,minfo.F,minfo.Fs);
    this.Magnitudes = 20*log10(abs(Resp));
    this.Frequencies = minfo.F;

    this.Magnitudes(this.Frequencies > minfo.Fs/2) = NaN;
    this.Frequencies(this.Frequencies > minfo.Fs/2) = NaN;

    % Measure attenuations using interpolated masks. These measurements will be the
    % ones used to decide if specs are met or not.
    Resp = freqz(hfilter,minfo.Finterp,minfo.Fs);
    this.MagnitudesInterp = 20*log10(abs(Resp));
    this.FrequenciesInterp = minfo.Finterp;
  end  % audioweightingmeas

end  % constructor block

methods 
  function set.Frequencies(obj,value)
  obj.Frequencies = value;
  end
  %------------------------------------------------------------------------
  function set.Magnitudes(obj,value)
  obj.Magnitudes = value;
  end
  %------------------------------------------------------------------------
  function set.FrequenciesInterp(obj,value)
  obj.FrequenciesInterp = value;
  end
  %------------------------------------------------------------------------
  function set.MagnitudesInterp(obj,value)
  obj.MagnitudesInterp = value;
  end

end   % set and get functions 

methods  % public methods
  props2norm = getprops2norm(this)
  b = isspecmet(this,hfdesign)
  setprops2norm(this,props2norm)
end  % public methods 

end  % classdef

