classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) nyquist < fdesign.abstracttypewband & dynamicprops
%NYQUIST   Construct a nyquist filter designer.
%   D = FDESIGN.NYQUIST(L) constructs a Lth band Nyquist filter designer D.
%
%   The band of a Nyquist filter is the inverse of the cutoff frequency in
%   terms of normalized units. For instance, a 4th-band filter has a cutoff
%   of 1/4. The case L=2 is referred to as a halfband filter. Use
%   FDESIGN.HALFBAND for more options with halfband filter design.
%
%   D = FDESIGN.NYQUIST(L,SPEC) initializes the filter designer
%   'Specification' property to SPEC.  SPEC is one of the following
%   strings and is not case sensitive:
%
%       'TW,Ast' - (minimum order, default) 
%       'N'      
%       'N,Ast'  
%       'N,TW'  
%
%  where 
%       Ast   - Stopband Attenuation (dB)
%       N     - Filter Order
%       TW    - Transition Width
%
%   By default, all frequency specifications are assumed to be in
%   normalized frequency units. Moreover, all magnitude specifications are
%   assumed to be in dB.
%
%   Different specification types may have different design methods
%   available. Use DESIGNMETHODS(D) to get a list of design methods
%   available for a given SPEC.
%
%   D = FDESIGN.NYQUIST(L, SPEC, SPEC1, SPEC2, ...) initializes the filter
%   designer specifications with SPEC1, SPEC2, etc...
%   Use GET(D, 'DESCRIPTION') for a description of SPEC1, SPEC2, etc.
%
%   D = FDESIGN.NYQUIST(L, TransitionWidth, Astop) uses the  default
%   SPEC ('TW,Ast') and sets the transition width and stopband        
%   attenuation.
%
%   D = FDESIGN.NYQUIST(...,Fs) specifies the sampling frequency (in
%   Hz). In this case, the transition width, if specified, is also in Hz.
%
%   D = FDESIGN.NYQUIST(...,MAGUNITS) specifies the units for any
%   magnitude specification given in the constructor. MAGUNITS can be one
%   of the following: 'linear', 'dB', or 'squared'. If this argument is
%   omitted, 'dB' is assumed. Note that the magnitude specifications are
%   always converted and stored in dB regardless of how they were
%   specified.
%
%   % Example #1 - Design a minimum order, 4th band Nyquist filter.
%   d = fdesign.nyquist(4,'TW,Ast',.01, 80);
%   designmethods(d);
%   Hd = design(d, 'kaiserwin'); 
%   fvtool(Hd)
%
%   % Example #2 - Design a 42nd order, 5th band Nyquist filter.
%   d = fdesign.nyquist(5,'N,Ast', 42, 80)
%   design(d)
%
%   % Example #3 - Control the transition width.
%   d = fdesign.nyquist(5,'N,TW', 42, .1)
%   design(d)
%
%   % Example #4 - Design a 2nd band (halfband) Nyquist filter. Compare FIR
%   % equiripple and IIR elliptic designs
%   d = fdesign.nyquist(2,'TW,Ast',.1,80);
%   H(1) = design(d,'equiripple');
%   H(2) = design(d,'ellip');
%   hfvt = fvtool(H); legend(hfvt,'Equiripple','Elliptic')
%
%   See also FDESIGN, FDESIGN/SETSPECS, FDESIGN/DESIGN.

%   Copyright 2004-2015 The MathWorks, Inc.

%fdesign.nyquist class
%   fdesign.nyquist extends fdesign.abstracttypewband.
%
%    fdesign.nyquist properties:
%       Response - Property is of type 'ustring' (read only) 
%       Description - Property is of type 'string vector' (read only) 
%       Band - Property is of type 'posint user-defined'  
%       Specification - Property is of type 'nyquistSpecsTypes enumeration: {'TW,Ast','N','N,Ast','N,TW'}'  
%
%    fdesign.nyquist methods:
%       getconstructor -   Return the constructor for the specification type.
%       getdefaultmethod -   Get the defaultmethod.
%       getmask -   Get the mask.
%       getmeasureconstructor -   Get the measureconstructor.
%       getnoiseshapefilter - Get the noiseshapefilter.
%       noiseshape - Noise-shape the FIR filter Hd
%       noiseshapeparetobands - Returns the band where to measure the frequency
%       passbandspecmet - Check whether passband response is within spec.
%       propstoadd -   Return the properties to add to the parent object.
%       setspecs -   Set the specs.


properties (SetObservable, GetObservable)
  %SPECIFICATION Property is of type 'nyquistSpecsTypes enumeration: {'TW,Ast','N','N,Ast','N,TW'}' 
  Specification
end


methods  % constructor block
  function this = nyquist(varargin)

  % this = fdesign.nyquist;

  this.Response = 'Nyquist';
  
  this.Specification = 'TW,Ast';

  if nargin>0,
      defaulttw(this,varargin{1})
  end

  this.setspecs(varargin{:});

  capture(this);


  end  % nyquist
        
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
        vals = {'TW,Ast',...
                'N',...
                'N,Ast',...
                'N,TW'}';
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
  cSpecCon = getconstructor(this,stype)
  defaultmethod = getdefaultmethod(this)
  [F,A] = getmask(this,fcns,rcf,specs)
  measureconstructor = getmeasureconstructor(this)
  nsf = getnoiseshapefilter(this,nnsf,cb)
  Hns = noiseshape(this,Hd,WL,args)
  bands = noiseshapeparetobands(this)
  flag = passbandspecmet(Hf,Hd,ng)
  p = propstoadd(this)
  setspecs(this,B,varargin)
end  % public methods 


methods (Hidden) % possibly private or hidden
  varargout = currentfdesigndesignmethods(this,varargin)
  defaulttw(this,band)
  multiratedefaults(this,maxfactor)
  [xlim,ylim] = thispassbandzoom(this,fcns,Hd,hfm)
end  % possibly private or hidden 

end  % classdef

