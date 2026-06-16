classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) audioweighting < fdesign.abstracttypewspecs & dynamicprops
%   AUDIOWEIGHTING  Construct an audio weighting filter designer.
%   D = FDESIGN.AUDIOWEIGHTING(SPECSTRING,VALUE1,VALUE2,...) constructs an audio
%   weighting filter designer D. Note that D is not the design itself. It only
%   contains the design specifications. In order to design the filter, invoke
%   the DESIGN method on D. For example (more examples below): 
%   D = fdesign.audioweighting('WT,Class','A',1); 
%   H = design(D); % H is a DFILT object
%
%   SPECSTRING is a string that determines what design specifications are used.
%   The full list of possible specifications is given below.
%
%   Different specifications may have different design methods available. Use
%   DESIGNMETHODS to get a list of design methods available for a given
%   SPECSTRING: 
%   designmethods(D)
%
%   VALUE1, VALUE2,... provide the values of the corresponding specifications.
%   Use get(D,'description') for a description of VALUE1, VALUE2, etc.
%
%   D = FDESIGN.AUDIOWEIGHTING(...,Fs) provides the sampling frequency in Hz 
%   used to design the filter. Fs must be a scalar trailing all other provided
%   values. Because audio weighting filter standards specify specific
%   attenuation values at a given frequency point, a filter designed for a
%   sampling frequency Fs only meets the specifications in the standard when
%   operating at that sampling frequency. If a sampling frequency is not
%   provided, the sampling frequency defaults to 48 kHz (80 KHz for the case of
%   ITU-R 468-4 designs). If you set normalized frequency to true using the
%   normalizefreq method, a warning is issued when the design method is invoked
%   and the default sampling frequency is used in the design.
%
%   The full list of possible values for SPECSTRING (not case sensitive) is:
%
%      'WT,Class' (default)
%      'WT'
%
%   where 
%       WT     - Weighting Type
%       Class  - Filter Class 
% 
%   The 'WT,Class' SPECSTRING will generate a filter designer for ANSI
%   S1.42-2001 weighting filters. Obtain a designer for an A-weighting filter by
%   setting the weighting type property to 'A'. Obtain a designer for a
%   C-weighting filter by setting the weighting type property to 'C'. The class
%   of these filters may be set to 1 or 2. The class value does not affect the
%   design. The class value is only used to provide a specification mask in
%   fvtool for the analysis of the filter design. Use the isspecmet method to
%   check that the filter design meets the specifications.
%
%   The 'WT' SPECSTRING generates a filter designer for a C-message (Bell System
%   Technical Reference 41009) weighting filter when you set the weighting type
%   property to 'Cmessage'. Obtain a filter designer for a Psophometer weighting
%   filter (ITU-T 0.41) by setting the weighting type property to 'ITUT041'.
%   Obtain an ITU-R 468-4 weighting filter designer by setting the weighting
%   type property to 'ITUR4684'.
%
%   D = FDESIGN.AUDIOWEIGHTING uses the default SPECSTRING ('WT,Class') and sets
%   the corresponding values to 'A', and 1. The default sampling frequency is 48
%   kHz.
%
%   % Example #1 - Design a class 2, A-weighting filter for a sampling 
%   % frequency of 44.1 KHz.
%   d  = fdesign.audioweighting('WT,Class','A',2,44.1e3)
%   Hd = design(d);
%   fvtool(Hd)
%
%   % Example #2 - Design a C-message IIR weighting filter for a sampling 
%   % frequency of 48 KHz.
%   d  = fdesign.audioweighting('WT','Cmessage',48e3)
%   Hd = design(d,'bell41009');
%   fvtool(Hd)
%
%   % Example #3 - Design a C-message FIR weighting filter for a sampling 
%   % frequency of 20 KHz.
%   d  = fdesign.audioweighting('WT','Cmessage',20e3)
%   Hd = design(d,'equiripple');
%   fvtool(Hd)
%
%   % Example #4 - Design a ITU-R 468-4 IIR weighting filter for a sampling 
%   % frequency of  44.1 KHz.
%   d  = fdesign.audioweighting('WT','ITUR4684',44.1e3)
%   Hd = design(d,'iirlpnorm');
%   fvtool(Hd)
%
%   See also FDESIGN, FDESIGN/SETSPECS, FDESIGN/DESIGN, FDESIGN/DESIGNOPTS.

%   Copyright 2004-2015 The MathWorks, Inc.

%fdesign.audioweighting class
%   fdesign.audioweighting extends fdesign.abstracttypewspecs.
%
%    fdesign.audioweighting properties:
%       Response - Property is of type 'ustring' (read only) 
%       Description - Property is of type 'string vector' (read only) 
%       Specification - Property is of type 'weightingSpecTypes enumeration: {'WT','WT,Class'}'  
%
%    fdesign.audioweighting methods:
%       disp -   Display this object.
%       getconstructor -   Get the constructor.
%       getdefaultmethod -   Get the defaultmethod.
%       getfvtoolinputs - Get the fVToolInputs.
%       getmask -   Get the mask.
%       getmeasureconstructor -   Get the measureconstructor.
%       propstocopy -   Returns the properties to copy.
%       setspecs -   Set the specifications
%       sosreorder -   Reorder SOS filter.


properties (SetObservable, GetObservable)
  %SPECIFICATION Property is of type 'weightingSpecTypes enumeration: {'WT','WT,Class'}' 
  Specification
end


methods  % constructor block
  function this = audioweighting(varargin)

    % this = fdesign.audioweighting;

    this.Response = 'Audio Weighting';

    this.Specification  = 'WT,Class'; 
    
    this.setspecs(varargin{:});


  end  % audioweighting

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
      vals = {'WT','WT,Class'}';
    elseif strcmp(prop,'WeightingType')
      if strcmp(obj.Specification,'WT')
        vals = {'Cmessage','ITUT041','ITUR4684'}';
      else
        vals = {'A','C'}';
      end
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
    propList = reorderstructure(propList,'Response', 'Specification', 'Description', 'NormalizedFrequency','Fs',cpropList{:});
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
  [F,A] = getmask(this,fcns,~,~)
  measureconstructor = getmeasureconstructor(this)
  p = propstocopy(this)
  setspecs(this,varargin)
  sosreorder(this,Hd)
end  % public methods 


methods (Hidden) % possibly private or hidden
  b = haspassbandzoom(~)
  minfo = measureinfo(this)
end  % possibly private or hidden 

end  % classdef

