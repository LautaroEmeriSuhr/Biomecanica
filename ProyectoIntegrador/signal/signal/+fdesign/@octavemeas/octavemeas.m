classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) octavemeas < fdesign.abstractmeas
%OCTAVEMEAS Construct an OCTAVEMEAS object.

%   Copyright 2004-2015 The MathWorks, Inc.
  
%fdesign.octavemeas class
%   fdesign.octavemeas extends fdesign.abstractmeas.
%
%    fdesign.octavemeas properties:
%       NormalizedFrequency - Property is of type 'bool' (read only) 
%       Fs - Property is of type 'mxArray' (read only) 
%       Frequencies - Property is of type 'mxArray' (read only) 
%       Magnitudes - Property is of type 'mxArray' (read only) 
%
%    fdesign.octavemeas methods:
%       getprops2norm -   Get the props2norm.
%       isspecmet -   True if the object is specmet.
%       setprops2norm -   Set the props2norm.


properties (SetAccess=protected, AbortSet, SetObservable, GetObservable)
  %FREQUENCIES Property is of type 'mxArray' (read only)
  Frequencies = [];
  %MAGNITUDES Property is of type 'mxArray' (read only)
  Magnitudes = [];
end


methods  % constructor block
  function this = octavemeas(hfilter, hfdesign, varargin)
    %OCTAVEMEAS   Construct an OCTAVEMEAS object.

    narginchk(1,inf);

    % this = fdesign.octavemeas;

    % Parse the inputs to get the specification and the measurements list.
    minfo = parseconstructorinputs(this, hfilter, hfdesign, varargin{:});

    if this.NormalizedFrequency, Fs = 2;
    else,                        Fs = this.Fs; end

    % Measure the arbitrary magnitude filter.
    F = minfo.Frequencies;
    this.Frequencies = F;
    A = 20*log10(abs(freqz(hfilter,F,Fs)));
    this.Magnitudes = A(:).';


  end  % octavemeas

end  % constructor block

methods 
  function set.Frequencies(obj,value)
  obj.Frequencies = value;
  end
  %------------------------------------------------------------------------
  function set.Magnitudes(obj,value)
  obj.Magnitudes = value;
  end

end   % set and get functions 

methods  % public methods
  props2norm = getprops2norm(this)
  b = isspecmet(this,hfdesign)
  setprops2norm(this,props2norm)
end  % public methods 

end  % classdef

