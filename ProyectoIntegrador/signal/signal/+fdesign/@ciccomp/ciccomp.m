classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) ciccomp < fdesign.abstracttypewspecs & dynamicprops
%CICCOMP   Construct a CIC compensator filter designer.
%   D = FDESIGN.CICCOMP constructs a CIC compensator filter designer D.
%
%   D = FDESIGN.CICCOMP(DELAY, NSECTIONS, RCIC) constructs a CIC
%   compensator filter designer with DifferentialDelay set to DELAY,
%   NumberOfSections set to NSECTIONS, and CICRateChangeFactor set to RCIC.
%   By default these parameters are equal to 2, 1, and 1 respectively. In
%   general, the design method implements a filter with a passband response
%   equal to an inverse Dirichlet sinc that matches exactly the inverse
%   passband response of a CIC filter with a differential delay equal to
%   DELAY, number of sections equal to NSECTIONS, and rate change factor
%   equal to RCIC. When RCIC is not specified or is set to 1, the design
%   method implements a filter with a passband response equal to an inverse
%   sinc that is an approximation to the true inverse passband response of
%   the CIC filter.
%
%   D = FDESIGN.CICCOMP(..., SPEC) constructs a CIC compensator and
%   sets its 'Specification' property to SPEC.  SPEC is not case
%   sensitive and must be one of the following:
%
%       'Fp,Fst,Ap,Ast' (minimum order, default)
%       'N,Fc,Ap,Ast'
%       'N,Fp,Ap,Ast'
%       'N,Fp,Fst'
%       'N,Fst,Ap,Ast'
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
%   D = FDESIGN.CICCOMP(..., SPEC, SPEC1, SPEC2, ...) initializes the
%   filter designer specifications in the order they are specified in the
%   SPEC input. Use GET(D, 'DESCRIPTION') for a description of SPEC1,
%   SPEC2, etc.
%
%   D = FDESIGN.CICCOMP(...,Fs) provides the sampling frequency of the
%   signal to be filtered. Fs must be specified as a scalar trailing the
%   other numerical values provided. For this case, Fs is assumed to be in
%   Hz as are all other frequency values provided. Note that you don't
%   change the specification string in this case. 
%
%   D = FDESIGN.CICCOMP(...,MAGUNITS) specifies the units for any magnitude
%   specification given. MAGUNITS can be one of the following: 'linear',
%   'dB', or 'squared'. If this argument is omitted, 'dB' is assumed. Note
%   that the magnitude specifications are always converted and stored in dB
%   regardless of how they were specified. If Fs is provided, MAGUNITS must
%   be provided after Fs in the input argument list.
%
%   % Example #1 - Design a minimum-order CIC compensator that compensates
%   %              for the droop in the passband of the CIC decimator.
%   Fs = 96e3;   % Input sampling frequency 
%   Fpass = 4e3; % Frequency band of interest
%   M = 6;       % Decimation factor of CIC      
%   Hcic = design(fdesign.decimator(M,'CIC',1,Fpass,60,Fs),...
%       'SystemObject',true);
%   Hcicgain = dsp.FIRFilter('Numerator',1/gain(Hcic));
%   Hd1 = cascade(Hcicgain,Hcic);
%   d = fdesign.ciccomp(Hcic.DifferentialDelay, Hcic.NumSections,...
%         Hcic.DecimationFactor,Fpass,4.5e3,.1,60,Fs/M);
%   Hd2 = design(d,'SystemObject',true);
%   hfvt = fvtool(Hd1,Hd2,cascade(Hcicgain,Hcic,Hd2),...
%       'Fs',[96e3 96e3/M 96e3], 'ShowReference', 'off');
%   legend(hfvt, 'CIC decimator','CIC compensator','Overall response', ...
%         'Location', 'Northeast');
%
%   % Example #2 - Design a compensator whose stopband decays like (1/f)^2.
%   Hd3 = design(d,'equiripple','StopbandShape','1/f', ...
%       'StopbandDecay',2,'SystemObject',true);
%   hfvt = fvtool(Hd1,Hd3,cascade(Hcicgain,Hcic,Hd3),...
%       'Fs',[96e3 96e3/M 96e3],'ShowReference','off');
%   legend(hfvt, 'CIC decimator','CIC compensator','Overall response', ...
%         'Location', 'Northeast');
%
%   See also FDESIGN, FDESIGN/SETSPECS, FDESIGN/DESIGN.

%   Copyright 2004-2015 The MathWorks, Inc.
    
%fdesign.ciccomp class
%   fdesign.ciccomp extends fdesign.abstracttypewspecs.
%
%    fdesign.ciccomp properties:
%       Response - Property is of type 'ustring' (read only) 
%       Description - Property is of type 'string vector' (read only) 
%       NumberOfSections - Property is of type 'posint user-defined'  
%       DifferentialDelay - Property is of type 'posint user-defined'  
%       CICRateChangeFactor - Property is of type 'posint user-defined'  
%       Specification - Property is of type 'ciccomp_specificationtypes enumeration: {'Fp,Fst,Ap,Ast','N,Fc,Ap,Ast','N,Fp,Ap,Ast','N,Fp,Fst','N,Fst,Ap,Ast'}'  
%
%    fdesign.ciccomp methods:
%       getconstructor -   Get the constructor.
%       getmask -   Get the mask.
%       getmeasureconstructor -   Get the measureconstructor.
%       multiratedefaults -   Setup the ciccomp object for multirate.
%       propstoadd - Return the properties to add to the parent object.
%       set_cicratechangefactor - PreSet function for the 'CICRateChangeFactor' property.
%       set_differentialdelay -   PreSet function for the 'differentialdelay' property.
%       set_numberofsections -   PreSet function for the 'numberofsections' property.
%       set_specification - Pre-Set Function for the 'Specification' property.
%       setspecs - Set the specs.
%       thiscopy - Copy properties specific to the fdesign.ciccomp class.
%       thisloadobj - Load this object.
%       thissaveobj - Save this object.


properties (SetObservable, GetObservable)
  %NUMBEROFSECTIONS Property is of type 'posint user-defined' 
  NumberOfSections = 2;
  %DIFFERENTIALDELAY Property is of type 'posint user-defined' 
  DifferentialDelay = 1;
  %CICRATECHANGEFACTOR Property is of type 'posint user-defined' 
  CICRateChangeFactor = 1;
  %SPECIFICATION Property is of type 'ciccomp_specificationtypes enumeration: {'Fp,Fst,Ap,Ast','N,Fc,Ap,Ast','N,Fp,Ap,Ast','N,Fp,Fst','N,Fst,Ap,Ast'}' 
  Specification 
end


methods  % constructor block
  function this = ciccomp(M, N, varargin)

    % this = fdesign.ciccomp;

    if nargin < 1, M = 1; end
    if nargin < 2, N = 2; end

    this.Response = 'CIC Compensator';

    this.Specification = 'Fp,Fst,Ap,Ast';
    
    this.setspecs(M, N, varargin{:});

    capture(this);


  end  % ciccomp

end  % constructor block

methods 
  function set.NumberOfSections(obj,value)
  % User-defined DataType = 'posint user-defined'
  validateattributes(value,{'numeric'},{'integer','positive','scalar'}...
  ,'','NumberofSections')
  obj.NumberOfSections = set_numberofsections(obj,value);
  end
  %------------------------------------------------------------------------
  function set.DifferentialDelay(obj,value)
  % User-defined DataType = 'posint user-defined'
  validateattributes(value,{'numeric'},{'integer','positive','scalar'}...
  ,'','DifferentialDelay')
  obj.DifferentialDelay = set_differentialdelay(obj,value);
  end
  %------------------------------------------------------------------------
  function set.CICRateChangeFactor(obj,value)
  % User-defined DataType = 'posint user-defined'
  validateattributes(value,{'numeric'},{'integer','positive','scalar'}...
  ,'','CICRateChangeFactor')
  obj.CICRateChangeFactor = set_cicratechangefactor(obj,value);
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
      vals = {'Fp,Fst,Ap,Ast',...
              'N,Fc,Ap,Ast',...
              'N,Fp,Ap,Ast',...
              'N,Fp,Fst',...
              'N,Fst,Ap,Ast'}';
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
    propList = reorderstructure(propList,'Response','Specification','Description','NumberOfSections','DifferentialDelay','CICRateChangeFactor', cpropList{:});
    if propList.NormalizedFrequency 
      propList = rmfield(propList, 'Fs');
    end
    propgrp = matlab.mixin.util.PropertyGroup(propList);
  end
end

methods  % public methods
  c = getconstructor(this,stype)
  [F,A] = getmask(this,fcns,~,specs)
  measureconstructor = getmeasureconstructor(this)
  multiratedefaults(this,maxfactor)
  p = propstoadd(this)
  R = set_cicratechangefactor(this,R)
  M = set_differentialdelay(this,M)
  N = set_numberofsections(this,N)
  specification = set_specification(this,specification)
  setspecs(this,M,N,varargin)
  thiscopy(this,hOldObject)
  thisloadobj(this,s)
  s = thissaveobj(this)
end  % public methods 


methods (Hidden) % possibly private or hidden
  b = haspassbandzoom(this)
end  % possibly private or hidden 

end  % classdef

