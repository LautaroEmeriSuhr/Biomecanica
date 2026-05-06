classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) arbgrpdelay < fdesign.abstractarbresponse & dynamicprops
%ARBGRPDELAY  Arbitrary Group Delay filter designer.
%   D = FDESIGN.ARBGRPDELAY constructs an arbitrary group delay filter designer D.
%
%   D = FDESIGN.ARBGRPDELAY(SPEC) initializes the filter designer
%   'Specification' property to SPEC. SPEC is one of the following strings
%   and is not case sensitive:
%
%       'N,F,Gd'   - Single-band design (default)
%       'N,B,F,Gd' - Multi-band design
%
%  where 
%       Gd - Group delay response 
%       B  - Number of Bands
%       F  - Frequency Vector
%       N  - Filter Order
%
%   By default, all frequency specifications are assumed to be in
%   normalized frequency units. When the NormalizedFrequency property is
%   true, the designer assumes that the group delay values that you specify
%   are in samples. When the NormalizedFrequency property is false, the
%   designer assumes that the group delay values that you specify are in
%   seconds.
%
%   Different specification types may have different design methods
%   available. Use DESIGNMETHODS(D) to get a list of design methods
%   available for a given SPEC.
%
%   D = FDESIGN.ARBGRPDELAY(SPEC, SPEC1, SPEC2, ...) initializes the filter
%   designer specifications with SPEC1, SPEC2, etc. 
%   Use GET(D, 'DESCRIPTION') for a description of SPEC1, SPEC2, etc.
%
%   D = FDESIGN.ARBGRPDELAY(N, F, Gd) uses the  default SPEC ('N,F,Gd') and
%   sets the order, the frequency vector, and the group delay vector.
%
%   D = FDESIGN.ARBGRPDELAY(...,Fs) specifies the sampling frequency (in
%   Hz). In this case, all other frequency specifications are also in Hz,
%   and group delay specifications are in seconds.
%
%   % Example #1 - Design an allpass filter with an arbitrary group delay.
%   f = [0 0.02 0.04 0.06 0.08 0.1 0.25 0.5 0.75 1];
%   g = [5 5 5 5 5 5 4 3 2 1];
%   w = [2 2 2 2 2 2 1 1 1 1];
%   hgd = fdesign.arbgrpdelay('N,F,Gd',10,f,g);
%   Hgd = design(hgd,'iirlpnorm','Weights',w,'MaxPoleRadius',0.95);
%   fvtool(Hgd,'Analysis','grpdelay')
%             
%   % Example #2 - Group delay equalization of a bandstop Chebyshev filter  
%   %              operating with a sampling frequency of 1 KHz.
%   Fs = 1e3;
%   Hcheby2 = design(fdesign.bandstop('N,Fst1,Fst2,Ast',10,150,400,60,Fs),'cheby2');
%   f1 = 0.0:0.5:150; % Hz
%   g1 = grpdelay(Hcheby2,f1,Fs).'/Fs; % seconds
%   f2 = 400:0.5:500; % Hz
%   g2 = grpdelay(Hcheby2,f2,Fs).'/Fs; % seconds
%   maxg = max([g1 g2]);
%   % Design an arbitrary group delay allpass filter to equalize the group
%   % delay of the bandstop filter. Use an 18 order multiband design and
%   % specify two bands.
%   hgd = fdesign.arbgrpdelay('N,B,F,Gd',18,2,f1,maxg-g1,f2,maxg-g2,Fs);
%   Hgd = design(hgd,'iirlpnorm','MaxPoleRadius',0.95);
%   Hcascade = cascade(Hcheby2,Hgd);
%   fvtool(Hcheby2,Hgd,Hcascade,'Analysis','grpdelay','Legend','on');
%
%   See also FDESIGN, FDESIGN/SETSPECS, FDESIGN/DESIGN.

%   Copyright 2004-2015 The MathWorks, Inc.    
  
%fdesign.arbgrpdelay class
%   fdesign.arbgrpdelay extends fdesign.abstractarbresponse.
%
%    fdesign.arbgrpdelay properties:
%       Response - Property is of type 'ustring' (read only) 
%       Description - Property is of type 'string vector' (read only) 
%       Specification - Property is of type 'arbgrpdelaySpecTypes enumeration: {'N,F,Gd','N,B,F,Gd'}'  
%
%    fdesign.arbgrpdelay methods:
%       getconstructor -   Get the constructor.
%       getdefaultmethod -   Get the defaultmethod.
%       getmask -   Get the mask.
%       getmeasureconstructor - Get the measureconstructor.
%       getmultiratespectypes - Get the multiratespectypes.


properties (SetObservable, GetObservable)
  %SPECIFICATION Property is of type 'arbgrpdelaySpecTypes enumeration: {'N,F,Gd','N,B,F,Gd'}' 
  Specification 
end


methods  % constructor block
  function this = arbgrpdelay(varargin)

    % this = fdesign.arbgrpdelay;

    this.Response = 'Arbitrary Group Delay';

    this.Specification = 'N,F,Gd';
    
    this.setspecs(varargin{:});

    capture(this);


  end  % arbgrpdelay

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
      vals = {'N,F,Gd',...
              'N,B,F,Gd'}';
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
  [F,A,Gd] = getmask(~,~,~,~)
  measureconstructor = getmeasureconstructor(~)
  multiratespectypes = getmultiratespectypes(~)
end  % public methods 

end  % classdef

