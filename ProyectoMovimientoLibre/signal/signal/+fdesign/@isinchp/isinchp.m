classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) isinchp < fdesign.abstracttypewspecs & dynamicprops
%ISINCHP  Construct an inverse-sinc highpass filter designer.
%   D = FDESIGN.ISINCHP constructs an inverse-sinc highpass filter designer D.
%
%   D = FDESIGN.ISINCHP(SPEC) initializes the filter designer
%   'Specification' property to SPEC.  SPEC is one of the following
%   strings and is not case sensitive:
%
%       'Fst,Fp,Ast,Ap' - (minimum order, default) 
%       'N,Fc,Ast,Ap'   
%       'N,Fp,Ast,Ap'   
%       'N,Fst,Fp'  
%       'N,Fst,Ast,Ap'  
%
%  where 
%       Ap    - Passband Ripple (dB)
%       Ast   - Stopband Attenuation (dB)
%       Fc    - Cutoff Frequency
%       Fp    - Passband Frequency
%       Fst   - Stopband Frequency
%       N     - Filter Order
%
%   By default, all frequency specifications are assumed to be in
%   normalized frequency units. Moreover, all magnitude specifications are
%   assumed to be in dB.
%
%   Different specification types may have different design methods
%   available. Use DESIGNMETHODS(D) to get a list of design methods
%   available for a given SPEC.
%
%   D = FDESIGN.ISINCHP(SPEC, SPEC1, SPEC2, ...) initializes the filter
%   designer specifications with SPEC1, SPEC2, etc...
%   Use GET(D, 'DESCRIPTION') for a description of SPEC1, SPEC2, etc.
%
%   D = FDESIGN.ISINCHP(Fstop, Fpass, Astop, Apass) uses the default
%   SPEC ('Fst,Fp,Ast,Ap') and sets the stopband-edge frequency,
%   passband-edge frequency, stopband attenuation, and passband ripple.
%
%   D = FDESIGN.ISINCHP(..., Fs) specifies the sampling frequency (in Hz).
%   In this case, all other frequency specifications are also in Hz.
%
%   D = FDESIGN.ISINCHP(..., MAGUNITS) specifies the units for any
%   magnitude specification given in the constructor. MAGUNITS can be one
%   of the following: 'linear', 'dB', or 'squared'. If this argument is
%   omitted, 'dB' is assumed.  Note that the magnitude specifications are
%   always converted and stored in dB regardless of how they were
%   specified.
%
%   The design method of FDESIGN.ISINCHP implements a filter with a
%   passband magnitude response equal to H(w) = sinc(C*(1-w))^(-P). You can 
%   control the values of the sinc frequency factor, C, and the sinc power, 
%   P, using the 'SincFrequencyFactor' and 'SincPower' options in the design 
%   method. C and P default to 0.5 and 1 respectively.
%
%   % Example #1 - Design a minimum order inverse-sinc highpass filter.
%   d = fdesign.isinchp('Fst,Fp,Ast,Ap',.4,.5,40,0.01);
%   Hd = design(d);
%   % Shape the stopband to have a linear slope of 20 dB/rad/sample
%   Hd1 = design(d,'StopbandShape','linear','StopbandDecay',20);
%   fvtool(Hd,Hd1);
%
%   % Example #2 - Design a 50th order inverse-sinc highpass filter. Set the
%   %              sinc frequency factor to 0.25, and the sinc power to 16
%   %              to achieve a magnitude response in the passband of the form 
%   %              H(w) = sinc(0.25*(1-w))^(-16).
%   d = fdesign.isinchp('N,Fst,Fp',50,.4,.5);
%   Hd = design(d,'SincFrequencyFactor',0.25,'SincPower',16);
%   fvtool(Hd);
%
%
%   See also FDESIGN, FDESIGN/SETSPECS, FDESIGN/DESIGN.

%   Copyright 2004-2015 The MathWorks, Inc.
    
%fdesign.isinchp class
%   fdesign.isinchp extends fdesign.abstracttypewspecs.
%
%    fdesign.isinchp properties:
%       Response - Property is of type 'ustring' (read only) 
%       Description - Property is of type 'string vector' (read only) 
%       Specification - Property is of type 'isinchp_specificationtypes enumeration: {'Fst,Fp,Ast,Ap','N,Fc,Ast,Ap','N,Fp,Ast,Ap','N,Fst,Fp','N,Fst,Ast,Ap'}'  
%
%    fdesign.isinchp methods:
%       getconstructor - Get the constructor.
%       getmask - Get the mask.
%       getmeasureconstructor - Get the measureconstructor.
%       multiratedefaults - Setup the isinchp object for multirate.


properties (SetObservable, GetObservable)
  %SPECIFICATION Property is of type 'isinchp_specificationtypes enumeration: {'Fst,Fp,Ast,Ap','N,Fc,Ast,Ap','N,Fp,Ast,Ap','N,Fst,Fp','N,Fst,Ast,Ap'}' 
  Specification 
end


methods  % constructor block
  function this = isinchp(varargin)

    % this = fdesign.isinchp;

    this.Response = 'Inverse-sinc Highpass';
    
    this.Specification = 'Fst,Fp,Ast,Ap';

    setspecs(this, varargin{:});

  end  % isinchp

end  % constructor block

methods 
  function value = get.Specification(obj)
  value = get_specification(obj,obj.Specification);
  end
  %------------------------------------------------------------------------
  function set.Specification(obj,value)
  value = validatestring(value,getAllowedStringValues(obj,'Specification'),'','Specification');
  obj.Specification = set_specification(obj,value);
  end

end   % set and get functions 

methods
  function vals = getAllowedStringValues(obj,prop)
    if strcmp(prop,'Specification')
      vals = {'Fst,Fp,Ast,Ap',...
             'N,Fc,Ast,Ap',...
             'N,Fp,Ast,Ap',....
             'N,Fst,Fp',...
             'N,Fst,Ast,Ap'}';
    else
      vals = {};
    end
  end
end

methods (Access = protected)
  %This function defines the display behavior for the class
  %using matlab.mixin.util.CustomDisplay
  function propgrp = getPropertyGroups(obj)
    propList = get(obj);
    cpropList = propstoadd(obj.CurrentSpecs);
    propList = reorderstructure(propList,'Response','Specification','Description',cpropList{:});
    if propList.NormalizedFrequency 
      propList = rmfield(propList, 'Fs');
    end
    propgrp = matlab.mixin.util.PropertyGroup(propList);
  end
end
     

methods  % public methods
  c = getconstructor(this,stype)
  [F,A] = getmask(this,fcns,~,specs)
  measureconstructor = getmeasureconstructor(~)
  multiratedefaults(this,maxfactor)
end  % public methods 


methods (Hidden) % possibly private or hidden
  b = haspassbandzoom(~)
end  % possibly private or hidden 

end  % classdef

