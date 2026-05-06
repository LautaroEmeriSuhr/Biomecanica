classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) arbmagnphase < fdesign.abstractarbresponse & dynamicprops
%ARBMAGNPHASE   Arbitrary Magnitude and Phase filter designer.
%   D = FDESIGN.ARBMAGNPHASE constructs an arbitrary magnitude filter designer D.
%
%   D = FDESIGN.ARBMAGNPHASE(SPEC) initializes the filter designer
%   'Specification' property to SPEC.  SPEC is one of the following
%   strings and is not case sensitive:
%
%       'N,F,H'       - Single-band design (default)
%       'Nb,Na,F,H'   - Single-band IIR design
%       'N,B,F,H'     - Multi-band design
%
%  where 
%       H  - Complex Frequency Response 
%       B  - Number of Bands
%       F  - Frequency Vector
%       N  - Filter Order
%       Nb - Numerator Order
%       Na - Denominator Order
%
%   By default, all frequency specifications are assumed to be in
%   normalized frequency units. 
%
%   Different specification types may have different design methods
%   available. Use DESIGNMETHODS(D) to get a list of design methods
%   available for a given SPEC.
%
%   D = FDESIGN.ARBMAGNPHASE(SPEC, SPEC1, SPEC2, ...) initializes the filter
%   designer specifications with SPEC1, SPEC2, etc. 
%   Use GET(D, 'DESCRIPTION') for a description of SPEC1, SPEC2, etc.
%
%   D = FDESIGN.ARBMAGNPHASE(N, F, H) uses the  default SPEC ('N,F,H') and
%   sets the order, the frequency vector, and the frequency response vector.
%
%   D = FDESIGN.ARBMAGNPHASE(...,Fs) specifies the sampling frequency (in Hz).
%   In this case, all other frequency specifications are also in Hz.
%
%   % Example #1 - Model a Complex Analog Filter.
%   d=fdesign.arbmagnphase('N,F,H',100);
%   design(d,'freqsamp');
%
%   % Example #2 - Design a Bandpass Filter with a Low Group Delay
%   N  = 50;  % Group Delay of linear phase filter would be 25
%   gd = 12; % Desired Group Delay
%   F1 = linspace(0,.25,30); F2=linspace(.3,.56,40); F3=linspace(.62,1,30);
%   H1 = zeros(size(F1)); H2 = exp(-1i*pi*gd*F2); H3 = zeros(size(F3));
%   d  = fdesign.arbmagnphase('N,B,F,H',50,3,F1,H1,F2,H2,F3,H3); 
%   Hd = design(d,'equiripple');
%   fvtool(Hd)
%
%   For more information, see the <a href="matlab:web([matlabroot,'\toolbox\dsp\dspdemos\html\arbmagnphasedemo.html'])">Arbitrary Magnitude and Phase Demo</a>. 
%
%   See also FDESIGN, FDESIGN/SETSPECS, FDESIGN/DESIGN.

%   Copyright 2004-2015 The MathWorks, Inc.
    
%fdesign.arbmagnphase class
%   fdesign.arbmagnphase extends fdesign.abstractarbresponse.
%
%    fdesign.arbmagnphase properties:
%       Response - Property is of type 'ustring' (read only) 
%       Description - Property is of type 'string vector' (read only) 
%       Specification - Property is of type 'arbmagnphaseSpecTypes enumeration: {'N,F,H','Nb,Na,F,H','N,B,F,H'}'  
%
%    fdesign.arbmagnphase methods:
%       getconstructor -   Get the constructor.
%       getdefaultmethod -   Get the defaultmethod.
%       getmask - Get the mask.
%       getmeasureconstructor -   Get the measureconstructor.
%       getmultiratespectypes -   Get the multiratespectypes.


properties (SetObservable, GetObservable)
  %SPECIFICATION Property is of type 'arbmagnphaseSpecTypes enumeration: {'N,F,H','Nb,Na,F,H','N,B,F,H'}' 
  Specification 
end


methods  % constructor block
  function this = arbmagnphase(varargin)

    % this = fdesign.arbmagnphase;

    this.Response = 'Arbitrary Magnitude and Phase';

    this.Specification = 'N,F,H';
    
    this.setspecs(varargin{:});

    capture(this);


  end  % arbmagnphase

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
      vals = {'N,F,H',...
              'Nb,Na,F,H',...
              'N,B,F,H'}';
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
  [F,A,P] = getmask(this,fcns,~,~)
  measureconstructor = getmeasureconstructor(this)
  multiratespectypes = getmultiratespectypes(this)
end  % public methods 

end  % classdef

