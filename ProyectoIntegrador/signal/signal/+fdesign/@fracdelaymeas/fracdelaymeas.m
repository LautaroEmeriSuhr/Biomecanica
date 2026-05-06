classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) fracdelaymeas < fdesign.abstractmeas
%FRACDELAYMEAS Construct a FRACDELAYMEAS object.

%   Copyright 2004-2015 The MathWorks, Inc.

%fdesign.fracdelaymeas class
%   fdesign.fracdelaymeas extends fdesign.abstractmeas.
%
%    fdesign.fracdelaymeas properties:
%       NormalizedFrequency - Property is of type 'bool' (read only) 
%       Fs - Property is of type 'mxArray' (read only) 
%       Fpass1 - Property is of type 'mxArray' (read only) 
%       Fpass2 - Property is of type 'mxArray' (read only) 
%       Apass - Property is of type 'mxArray' (read only) 
%       NomGrpDelay - Property is of type 'mxArray' (read only) 
%       FracDelayError - Property is of type 'mxArray' (read only) 
%
%    fdesign.fracdelaymeas methods:
%       getprops2norm -   Get the props2norm.
%       isspecmet -   True if the object is specmet.
%       measureripple -   Return the ripple in the passband.
%       setprops2norm -   Set the props2norm.
%       thisfindfpass -  If both Fpass and fderr are empty we cannot find an Fpass. 


properties (SetAccess=protected, AbortSet, SetObservable, GetObservable)
  %FPASS1 Property is of type 'mxArray' (read only)
  Fpass1 = [];
  %FPASS2 Property is of type 'mxArray' (read only)
  Fpass2 = [];
  %APASS Property is of type 'mxArray' (read only)
  Apass = [];
  %NOMGRPDELAY Property is of type 'mxArray' (read only)
  NomGrpDelay = [];
  %FRACDELAYERROR Property is of type 'mxArray' (read only)
  FracDelayError = [];
end


methods  % constructor block
  function this = fracdelaymeas(hfilter, hfdesign, varargin)
    %FRACDELAYMEAS   Construct a FRACDELAYMEAS object.

    narginchk(1,inf);

    % this = fdesign.fracdelaymeas;

    % Parse the inputs to get the specification and the measurements list.
    minfo = parseconstructorinputs(this, hfilter, hfdesign, varargin{:});

    if this.NormalizedFrequency, Fs = 2;
    else,                        Fs = this.Fs; end

    [gpd w]= grpdelay(hfilter,1024,Fs);

    % Measure the fractional delay filter.
    if isempty(minfo.Apass),
        this.Fpass1 = findfpass(this, hfilter, minfo.Fpass1, minfo.Apass, 'up',...
            [],{gpd w minfo.FracDelayError 'up' Fs});
        this.Fpass2 = findfpass(this, hfilter, minfo.Fpass2, minfo.Apass, 'down',...
            [],{gpd w minfo.FracDelayError 'down' Fs});
    else
        this.Fpass1 = findfpass(this, hfilter, minfo.Fpass1, minfo.Apass, 'up');
        this.Fpass2 = findfpass(this, hfilter, minfo.Fpass2, minfo.Apass, 'down');
    end

    % Measure Apass always after Fpass1 and Fpass2
    this.Apass  = measureripple(this, hfilter, minfo.Fpass1, minfo.Fpass2, minfo.Apass);

    if this.NormalizedFrequency,
        this.NomGrpDelay = gpd(1)-hfilter.FracDelay;
    else
        this.NomGrpDelay = (gpd(1)-hfilter.FracDelay)/Fs;
    end
    this.FracDelayError = measurefracdelayerr(this, hfilter, minfo.Fpass1, minfo.Fpass2, ...
        minfo.Apass, minfo.FracDelayError);


  end  % fracdelaymeas

end  % constructor block

methods 
  function set.Fpass1(obj,value)
  obj.Fpass1 = value;
  end
  %------------------------------------------------------------------------
  function set.Fpass2(obj,value)
  obj.Fpass2 = value;
  end
  %------------------------------------------------------------------------
  function set.Apass(obj,value)
  obj.Apass = value;
  end
  %------------------------------------------------------------------------
  function set.NomGrpDelay(obj,value)
  obj.NomGrpDelay = value;
  end
  %------------------------------------------------------------------------
  function set.FracDelayError(obj,value)
  obj.FracDelayError = value;
  end

end   % set and get functions 

methods  % public methods
  props2norm = getprops2norm(this)
  b = isspecmet(this,hfdesign)
  rip = measureripple(this,hfilter,Fstart,Fend,Apass)
  setprops2norm(this,props2norm)
  F = thisfindfpass(this,hfilter,cellarray)
end  % public methods 


methods (Hidden) % possibly private or hidden
  fderr = measurefracdelayerr(this,hfilter,Fstart,Fend,Apass,FracDelayError)
end  % possibly private or hidden 

end  % classdef

