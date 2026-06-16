classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) halfband < fdesign.abstracttypewspecs & dynamicprops
%HALFBAND   Construct a halfband filter designer.
%   D = FDESIGN.HALFBAND constructs a halfband filter designer D.
%
%   D = FDESIGN.HALFBAND('TYPE',TYPE) initializes the filter designer
%   'Type' property with TYPE.  TYPE must be either 'Lowpass' or 'Highpass'
%   and is not case sensitive.
%
%   D = FDESIGN.HALFBAND(SPEC) initializes the filter designer
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
%   D = FDESIGN.HALFBAND(SPEC, SPEC1, SPEC2, ...) initializes the filter
%   designer specifications with SPEC1, SPEC2, etc...
%   Use GET(D, 'DESCRIPTION') for a description of SPEC1, SPEC2, etc.
%
%   D = FDESIGN.HALFBAND(TransitionWidth, Astop) uses the  default
%   SPEC ('TW,Ast') and sets the transition width and stopband        
%   attenuation.
%
%   D = FDESIGN.HALFBAND(...,Fs) specifies the sampling frequency (in
%   Hz). In this case, the transition width, if specified, is also in Hz.
%
%   D = FDESIGN.HALFBAND(...,MAGUNITS) specifies the units for any
%   magnitude specification given in the constructor. MAGUNITS can be one
%   of the following: 'linear', 'dB', or 'squared'. If this argument is
%   omitted, 'dB' is assumed. Note that the magnitude specifications are
%   always converted and stored in dB regardless of how they were
%   specified.
%
%   % Example #1 
%       %Design a minimum order equiripple halfband lowpass filter.
%       %Compare to an elliptic IIR halfband filter
%       d = fdesign.halfband('Type','Lowpass',.01, 80);
%       Hfir = design(d,'equiripple');
%       Hiir = design(d,'ellip');
%       fvtool(Hfir,Hiir)
%
%   % Example #2 
%       %Design a 80th order equiripple halfband highpass filter 
%       %with 70dB of stopband attenuation.
%       d = fdesign.halfband('Type','Highpass','N,Ast',80,70);
%       Hd = design(d,'equiripple');
%
%   % Example #3 
%       %Design a 42th order equiripple halfband lowpass filter 
%       %with a controlled transition width.
%       d = fdesign.halfband('Type','Lowpass','N,TW', 42, .04);
%       designmethods(d);
%       Hd = design(d,'firls');
%
%   For more information about halfband filters, see the
%   <a href="matlab:web([matlabroot,'\toolbox\dsp\dspdemos\html\firhalfbanddemo.html'])">FIR Halfband Filter Design</a> demo. 
%
%   See also FDESIGN, FDESIGN/SETSPECS, FDESIGN/DESIGN.

%   Copyright 2004-2015 The MathWorks, Inc.

%fdesign.halfband class
%   fdesign.halfband extends fdesign.abstracttypewspecs.
%
%    fdesign.halfband properties:
%       Response - Property is of type 'ustring' (read only) 
%       Description - Property is of type 'string vector' (read only) 
%       Type - Property is of type 'halfbandresponseTypes enumeration: {'Lowpass','Highpass'}'  
%       Specification - Property is of type 'halfbandSpecsTypes enumeration: {'TW,Ast','N','N,Ast','N,TW'}'  
%
%    fdesign.halfband methods:
%       getconstructor -   Return the constructor for the specification type.
%       getmask -   Get the mask.
%       getmeasureconstructor -   Get the measureconstructor.
%       getnoiseshapefilter - Get the noiseshapefilter.
%       minwordlengthApass - Determine the passband ripples of the minimum wordlength filter
%       noiseshape - Noise-shape the FIR filter Hd 
%       noiseshapeparetobands - Returns the band where to measure the frequency
%       passbandspecmet - Check whether passband response is within spec.
%       propstoadd -   Return the properties to add to the parent object.
%       propstocopy -   Returns the properties to copy that are not part of the specs.
%       set_type - PreSet function for the 'type' property
%       setspecs -   Set the specs.


properties (AbortSet, SetObservable, GetObservable)
    %TYPE Property is of type 'halfbandresponseTypes enumeration: {'Lowpass','Highpass'}' 
    Type = 'Lowpass';
end

properties (Access=protected, SetObservable, GetObservable)
    %PRIVTYPE Property is of type 'halfbandresponseTypes enumeration: {'Lowpass','Highpass'}'
    privType = 'Lowpass';
end

properties (SetObservable, GetObservable)
    %SPECIFICATION Property is of type 'halfbandSpecsTypes enumeration: {'TW,Ast','N','N,Ast','N,TW'}' 
    Specification;
end


methods  % constructor block
  function this = halfband(varargin)

  % this = fdesign.halfband;
  
  this.Response = 'Halfband';

  this.Specification = 'TW,Ast';

  this.setspecs(varargin{:});
  
  capture(this);


  end  % halfband

end  % constructor block

methods 
  function set.Type(obj,value)
  % Enumerated DataType = 'halfbandresponseTypes enumeration: {'Lowpass','Highpass'}'
  value = validatestring(value,{'Lowpass','Highpass'},'','Type');
  obj.Type = set_type(obj,value);
  end
  %------------------------------------------------------------------------
  function set.privType(obj,value)
  % Enumerated DataType = 'halfbandresponseTypes enumeration: {'Lowpass','Highpass'}'
  value = validatestring(value,{'Lowpass','Highpass'},'','privType');
  obj.privType = value;
  end
  %------------------------------------------------------------------------
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
        vals = {'TW,Ast','N','N,Ast','N,TW'}';
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
    propList = reorderstructure(propList,'Response','Specification','Description','Type',cpropList{:});
    if propList.NormalizedFrequency 
      propList = rmfield(propList, 'Fs');
    end
    propgrp = matlab.mixin.util.PropertyGroup(propList);
  end
end

methods  % public methods
  cSpecCon = getconstructor(this)
  [F,A] = getmask(this,fcns,rcf,specs)
  measureconstructor = getmeasureconstructor(this)
  nsf = getnoiseshapefilter(this,nnsf,cb)
  Apass = minwordlengthApass(f,md,Astop)
  Hns = noiseshape(this,Hd,WL,args)
  bands = noiseshapeparetobands(this)
  flag = passbandspecmet(Hf,Hd,ng)
  p = propstoadd(this)
  p = propstocopy(this)
  type = set_type(this,type)
  setspecs(this,varargin)
end  % public methods 


methods (Hidden) % possibly private or hidden
  varargout = currentfdesigndesignmethods(this,varargin)
  [xlim,ylim] = thispassbandzoom(this,fcns,Hd,hfm)
end  % possibly private or hidden 

end  % classdef

