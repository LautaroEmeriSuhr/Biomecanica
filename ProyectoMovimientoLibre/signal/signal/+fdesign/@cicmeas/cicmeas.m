classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) cicmeas < fdesign.abstractmeas
%CICMEAS Construct a CICMEAS object.

%   Copyright 2004-2015 The MathWorks, Inc.    
  
%fdesign.cicmeas class
%   fdesign.cicmeas extends fdesign.abstractmeas.
%
%    fdesign.cicmeas properties:
%       NormalizedFrequency - Property is of type 'bool' (read only) 
%       Fs - Property is of type 'mxArray' (read only) 
%       Fpass - Property is of type 'mxArray' (read only) 
%       Fstop - Property is of type 'mxArray' (read only) 
%       Fnulls - Property is of type 'mxArray' (read only) 
%       Apass - Property is of type 'mxArray' (read only) 
%       Astop - Property is of type 'mxArray' (read only) 
%
%    fdesign.cicmeas methods:
%       getprops2norm -   Get the props2norm.
%       isspecmet -   True if the object is specmet.
%       setprops2norm -   Set the props2norm.


properties (SetAccess=protected, AbortSet, SetObservable, GetObservable)
  %FPASS Property is of type 'mxArray' (read only)
  Fpass = [];
  %FSTOP Property is of type 'mxArray' (read only)
  Fstop = [];
  %FNULLS Property is of type 'mxArray' (read only)
  Fnulls = [];
  %APASS Property is of type 'mxArray' (read only)
  Apass = [];
  %ASTOP Property is of type 'mxArray' (read only)
  Astop = [];
end


methods  % constructor block
  function this = cicmeas(hfilter, hfdesign)
    %CICMEAS   Construct a CICMEAS object.

    narginchk(1,2);

    % this = fdesign.cicmeas;

    % If the specification is not passed, use the stored specification.
    if nargin < 2
        hfdesign = getfdesign(hfilter);
        if isempty(hfdesign)
            error(message('signal:fdesign:cicmeas:cicmeas:missingFDesign'));
        end
    end

    % Set CIC nulls
    if isa(hfilter,'mfilt.cicdecim'),
        Fo = cicnulls(hfilter.DecimationFactor,hfilter.DifferentialDelay);
    else
        Fo = cicnulls(hfilter.InterpolationFactor,hfilter.DifferentialDelay);
    end

    this.Fnulls = Fo;

    % Sync up the sampling frequencies.
    if ~hfdesign.NormalizedFrequency
        this.normalizefreq(false, get(hfdesign, 'fs'));
    end

    % Sync up Passband Frequency
    this.Fpass = hfdesign.Fpass;

    % Set stopband frequency
    this.Fstop = this.Fnulls(1) - this.Fpass;

    set(this, 'Specification', hfdesign);

    % Find passband ripple and stopband attenuation
    if this.NormalizedFrequency,
        H = freqz(hfilter,[0, this.Fpass, this.Fstop]*pi);
    else
        H = freqz(hfilter,[0, this.Fpass, this.Fstop],this.Fs);
    end

    dcgain = 20*log10(abs(H(1)));

    this.Apass = dcgain - 20*log10(abs(H(2)));
    this.Astop = dcgain - 20*log10(abs(H(3)));


  end  % cicmeas

end  % constructor block

methods 
  function set.Fpass(obj,value)
  obj.Fpass = value;
  end
  %------------------------------------------------------------------------
  function set.Fstop(obj,value)
  obj.Fstop = value;
  end
  %------------------------------------------------------------------------
  function set.Fnulls(obj,value)
  obj.Fnulls = value;
  end
  %------------------------------------------------------------------------
  function set.Apass(obj,value)
  obj.Apass = value;
  end
  %------------------------------------------------------------------------
  function set.Astop(obj,value)
  obj.Astop = value;
  end

end   % set and get functions 

methods  % public methods
  props2norm = getprops2norm(this)
  b = isspecmet(this,hspecs)
  setprops2norm(this,props2norm)
end  % public methods 

end  % classdef

