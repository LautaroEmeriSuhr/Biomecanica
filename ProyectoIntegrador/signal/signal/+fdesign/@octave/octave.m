classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) octave < fdesign.abstracttypewspecs & dynamicprops
%OCTAVE   Construct an octave filter designer.
%   D = FDESIGN.OCTAVE(L) constructs a fractional-octave-band filter
%   designer D with L bands per octave. L defaults to 1.
%
%   D = FDESIGN.OCTAVE(L,MASK) initializes the filter designer 'Mask'
%   property to MASK.  MASK is one of the following strings: 'Class 0',
%   'Class 1', 'Class 2'. Notice that MASK is not a design parameter. It is
%   just used to draw the specification mask in FVTool.
%
%   D = FDESIGN.OCTAVE(L,MASK,SPEC) initializes the filter designer
%   'Specification' property to SPEC.  SPEC is one of the following strings
%   and is not case sensitive:
%
%       'N,F0'  
%
%  where 
%       N     - Filter Order
%       F0    - Center Frequency
%
%   Use GET(D, 'DESCRIPTION') for a description of SPEC. By default, all
%   frequency specifications are assumed to be in normalized frequency
%   units. 
%
%   D = FDESIGN.OCTAVE(L, MASK, N, F0) uses the  default SPEC ('N,F0') and
%   sets the filter order and center frequency.
%
%   D = FDESIGN.OCTAVE(...,Fs) specifies the sampling frequency (in Hz). In
%   this case, the center frequency is also in Hz and must be between 20Hz
%   and 20kHz (audio range).
%
%   % Example #1 - Design an 6th order, octave-band class 0 filter with:
%   %              a center frequency of 1000 Hz and,
%   %              a sampling frequency of 44.1kHz.
%   d = fdesign.octave(1,'Class 0','N,F0',6,1000,44100)
%   Hd = design(d)
%   fvtool(Hd,'Fs',44100,'FrequencyScale','log')
%
%   % Example #2 - Design a 6th order, 1/3-octave-band Class 2 filter with:
%   %              a center frequency of 10 KHz,
%   %              a sampling frequency of 48 kHz,
%   %              a Direct-Form I, Second-Order Sections structure.
%   d = fdesign.octave(3,'Class 2','N,F0',6,10000,48000)
%   design(d,'FilterStructure','df1sos')
%
%   See also FDESIGN, FDESIGN/SETSPECS, FDESIGN/DESIGN.

%   Copyright 2004-2015 The MathWorks, Inc.
  
%fdesign.octave class
%   fdesign.octave extends fdesign.abstracttypewspecs.
%
%    fdesign.octave properties:
%       Response - Property is of type 'ustring' (read only) 
%       Description - Property is of type 'string vector' (read only) 
%       Specification - Property is of type 'octaveSpecTypes enumeration: {'N,F0'}'  
%       BandsPerOctave - Property is of type 'posint user-defined'  
%       Mask - Property is of type 'octaveMaskSpecTypes enumeration: {'Class 0','Class 1','Class 2'}'  
%
%    fdesign.octave methods:
%       disp -   Display this object.
%       getconstructor -   Get the constructor.
%       getdefaultmethod -   Get the defaultmethod.
%       getfvtoolinputs - Get the fVToolInputs.
%       getmask -   Get the mask.
%       getmeasureconstructor -   Get the measureconstructor.
%       isspecmet -   True if the object is specmet.
%       propstocopy -   Returns the properties to copy.
%       set_bandsperoctave -   PreSet function for the 'bandsperoctave' property.
%       sosreorder -   Reorder SOS filter.
%       thisloadobj -   Load this object.
%       thissaveobj -   Save this object.
%       validfrequencies -  Return the valid values for the 'CenterFreq' property.


properties (SetObservable, GetObservable)
  %SPECIFICATION Property is of type 'octaveSpecTypes enumeration: {'N,F0'}' 
  Specification 
  %BANDSPEROCTAVE Property is of type 'posint user-defined' 
  BandsPerOctave = 1;
  %MASK Property is of type 'octaveMaskSpecTypes enumeration: {'Class 0','Class 1','Class 2'}' 
  Mask = 'Class 0';
end


methods  % constructor block
  function this = octave(varargin)

  % this = fdesign.octave;
  this.Response = 'Octave and Fractional Octave';
  this.Specification = 'N,F0';
  
  if nargin>0,
      this.BandsPerOctave = varargin{1};
      varargin(1) = [];
  end
  if nargin>1,
      this.Mask = varargin{1};
      varargin(1) = [];
  end

  setspecs(this, varargin{:});


  end  % octave

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
  %------------------------------------------------------------------------
  function set.BandsPerOctave(obj,value)
  % User-defined DataType = 'posint user-defined'
  validateattributes(value,{'numeric'},{'integer','positive','scalar'}...
  ,'','BandsPerOctave')
  obj.BandsPerOctave = set_bandsperoctave(obj,value);
  end
  %------------------------------------------------------------------------
  function set.Mask(obj,value)
  value = validatestring(value,getAllowedStringValues(obj,'Mask'),'','Mask');
  obj.Mask = value;
  end

end   % set and get functions 

methods
    function vals = getAllowedStringValues(obj,prop)
      if strcmp(prop,'Specification')
        vals = {'N,F0'};
      elseif strcmp(prop, 'Mask')
        vals = {'Class 0','Class 1','Class 2'}';
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
    propList = reorderstructure(propList,'Response','BandsPerOctave','Mask','Specification','Description',cpropList{:});
    if propList.NormalizedFrequency 
      propList = rmfield(propList, 'Fs');
    end
    propgrp = matlab.mixin.util.PropertyGroup(propList);
  end
end

methods  % public methods
  cSpecCon = getconstructor(this,stype)
  defaultmethod = getdefaultmethod(this)
  fvtoolInputs = getfvtoolinputs(this)
  [F,A] = getmask(this,fcns,rcf,specs)
  measureconstructor = getmeasureconstructor(this)
  b = isspecmet(this,Hd)
  p = propstocopy(this)
  lthoctave = set_bandsperoctave(this,lthoctave)
  sosreorder(this,Hd)
  thisloadobj(this,s)
  s = thissaveobj(this)
  f = validfrequencies(this)
end  % public methods 


methods (Hidden) % possibly private or hidden
  b = haspassbandzoom(this)
  minfo = measureinfo(this)
end  % possibly private or hidden 

end  % classdef

