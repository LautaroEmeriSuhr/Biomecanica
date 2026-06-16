classdef (CaseInsensitiveProperties=true) interpolator < fdesign.abstractmultirate2 & dynamicprops 
%INTERPOLATOR   Construct an interpolator filter designer.
%   D = FDESIGN.INTERPOLATOR(L) constructs an interpolator filter designer
%   D with an 'InterpolationFactor' of L. If L is not specified, it
%   defaults to 2.
%
%   D = FDESIGN.INTERPOLATOR(L, RESPONSE) initializes the filter designer
%   'Response' property with RESPONSE.  RESPONSE is one of the following
%   strings and is not case sensitive: 
%       'Nyquist' (default)
%       'Halfband'
%       'Lowpass'
%       'CIC'
%       'CIC Compensator'
%       'Inverse-sinc Lowpass'
%       'Inverse-sinc Highpass'
%       'Highpass'
%       'Hilbert'
%       'Bandpass'
%       'Bandstop'
%       'Differentiator'
%       'Arbitrary Magnitude'
%       'Arbitrary Magnitude and Phase'
%       'Raised Cosine'
%       'Square Root Raised Cosine'
%       'Gaussian'
%
%   D = FDESIGN.INTERPOLATOR(L, RESPONSE, SPEC) initializes the filter
%   designer 'Specification' property with SPEC.  Use SET(D, 'SPECIFICATION')
%   to get all available specifications for the response RESPONSE. 
%
%   Different design and specification types will have different design
%   methods available. Use DESIGNMETHODS(D) to get a list of design
%   methods available for a given SPEC.
%
%   D = FDESIGN.INTERPOLATOR(L, RESPONSE, SPEC, SPEC1, SPEC2, ...)
%   initializes the filter designer specifications with SPEC1, SPEC2, etc.
%   Use GET(D, 'DESCRIPTION') for a description of SPEC1, SPEC2, etc.
%
%   D = FDESIGN.INTERPOLATOR(...,Fs) specifies the sampling frequency (in
%   Hz). In this case, all frequency properties are also in Hz.
%
%   D = FDESIGN.INTERPOLATOR(...,MAGUNITS) specifies the units for any
%   magnitude specification given in the constructor. MAGUNITS can be one
%   of the following: 'linear', 'dB', or 'squared'. If this argument is
%   omitted, 'dB' is assumed. Note that the magnitude specifications are
%   always converted and stored in dB regardless of how they were
%   specified.
%
%   Some responses have additional constructor inputs. The syntaxes for
%   these special cases are listed below:
%
%   D = FDESIGN.INTERPOLATOR(L, 'CIC', DD, SPEC, ...) creates a CIC
%   interpolator filter designer with the 'InterpolationFactor' property
%   set to L, and the 'DifferentialDelay' property set to DD.
%
%   D = FDESIGN.INTERPOLATOR(L, 'CIC compensator', DD, N, R, SPEC, ...)
%   creates a CIC compensator interpolator filter designer with the
%   'InterpolationFactor' property set to L, the 'DifferentialDelay'
%   property set to DD, the 'NumberOfSections' property set to N, and the
%   'CICRateChangeFactor' property set to R. In general, the design method
%   implements a filter with a passband response equal to an inverse
%   Dirichlet sinc that matches exactly the inverse passband response of a
%   CIC filter with a differential delay equal to DD, number of sections
%   equal to N, and rate change factor equal to R. When R is not specified
%   or is set to 1, the design method implements a filter with a passband
%   response equal to an inverse sinc that is an approximation to the true
%   inverse passband response of the CIC filter.
%
%   D = FDESIGN.INTERPOLATOR(L, PULSESHAPERESP, SPS, SPEC, ...) where
%   PULSESHAPERESP equals 'Raised Cosine', 'Square Root Raised Cosine', or
%   'Gaussian', creates a pulse shaping interpolator filter designer with
%   the 'InterpolationFactor' property set to L, and the 'SamplesPerSymbol'
%   property set to SPS.
%
%   % Example #1 - Design a CIC interpolator for a signal sampled at 19200 Hz
%   % with a differential delay of two and that attenuates images beyond 50 Hz
%   % by at least 80 dB.
%   DD  = 2;     % Differential delay
%   Fp  = 50;    % Passband of interest
%   Ast = 80;    % Minimum attenuation of alias components in passband
%   Fs  = 600;   % Sampling frequency for input signal
%   L   = 32;    % Interpolation factor
%   d   = fdesign.interpolator(L,'cic',DD,'Fp,Ast',Fp,Ast,L*Fs);
%   hm  = design(d,'SystemObject',true);
%
%   % Example #2 - Design a minimum-order CIC compensator that interpolates by
%   % 4 and pre-compensates for the droop in the passband for the CIC from the
%   % previous example. 
%   Nsecs = hm.NumSections;
%   R     = hm.InterpolationFactor;
%   d     = fdesign.interpolator(4,'ciccomp',DD,Nsecs,R,'Fp,Fst,Ap,Ast',50,100,0.1,80,Fs);
%   hmc   = design(d,'equiripple','SystemObject',true);
%   % Analyze filters individually plus compound response
%   hfvt = fvtool(hmc,hm,cascade(hmc,hm),'Fs',[Fs,L*Fs,L*Fs],'ShowReference','off');
%   legend(hfvt,'CIC pre-compensator','CIC interpolator','Overall response');
%
%   % Example #3 - Design a minimum-order Nyquist interpolator using a Kaiser
%   % window. Compare to a multistage design. 
%   L   = 15;   % Interpolation factor. Also the Nyquist band.
%   TW  = 0.05; % Normalized transition width
%   Ast = 40;   % Minimum stopband attenuation in dB
%   d = fdesign.interpolator(L,'nyquist',L,TW,Ast);
%   hm  = design(d,'kaiserwin','SystemObject',true);  
%   hm2 = design(d,'multistage','SystemObject',true);
%   hfvt = fvtool(hm,hm2); legend(hfvt,'Kaiser window','Multistage');
%
%   % Example #4 - Design a lowpass interpolator for an interpolation factor of 8.
%   % Compare a single-stage equiripple design with multistage designs.
%   L = 8; % Interpolation factor;
%   d = fdesign.interpolator(L,'lowpass');
%   hm1 = design(d,'equiripple','SystemObject',true);
%   % Use halfband filters whenever possible
%   hm2 = design(d,'multistage','Usehalfbands',true,'SystemObject',true);
%   % Use quasi linear-phase IIR halfbands
%   hm3 = design(d,'multistage','Usehalfbands',true,'HalfbandDesignMethod','iirlinphase'); 
%   hfvt = fvtool(hm1,hm2,hm3);
%   legend(hfvt,'Single-stage equiripple','Multistage','Multistage with IIR halfbands')
%
%   See also FDESIGN, FDESIGN/SETSPECS, FDESIGN/DESIGN.

%   Copyright 2004-2015 The MathWorks, Inc.

%fdesign.interpolator class
%   fdesign.interpolator extends fdesign.abstractmultirate2.
%
%    fdesign.interpolator properties:
%       MultirateType - Property is of type 'ustring' (read only) 
%       Fs_in - Property is of type 'mxArray' (read only) 
%       Fs_out - Property is of type 'mxArray' (read only) 
%       Response - Property is of type 'interpolator_responses enumeration: {'Nyquist','Halfband','Lowpass','CIC','CIC Compensator','Inverse-sinc Lowpass','Highpass','Hilbert','Differentiator','Bandpass','Bandstop','Arbitrary Magnitude','Arbitrary Magnitude and Phase','Raised Cosine','Square Root Raised Cosine','Gaussian','Inverse-sinc Highpass'}'  
%       InterpolationFactor - Property is of type 'posint user-defined'  
%
%    fdesign.interpolator methods:
%       butter -   Butterworth IIR digital filter design.
%       disp -   Display this object.
%       ellip -   Elliptic or Cauer digital filter design.
%       get_fs_in -   PreGet function for the 'fs_in' property.
%       get_fs_out -   PreGet function for the 'fs_out' property.
%       get_interpolationfactor -   PreGet function for the 'interpolationfactor' property.
%       getcicconstructor -   Get the cicconstructor.
%       getdefaultmethod -   Get the defaultmethod.
%       getratechangefactors -   Get the ratechangefactors.
%       ifir -   Design an interpolated FIR filter.
%       multistage -   Design a multistage equiripple interpolator.
%       nominalgain -   Return the nominal gain.
%       passbandspecmet - Check whether passband response is within spec.
%       set_interpolationfactor -   PreSet function for the 'interpolationfactor' property.
%       setratechangefactors -   Set the ratechangefactors.
%       thisdesign - DESIGN   
%       updatefdesignfactors -   Update the current FDesign rate change factors.
%       validstructures - Return the valid structures for the design method.


properties (AbortSet, SetObservable, GetObservable)
  %INTERPOLATIONFACTOR Property is of type 'posint user-defined' 
  InterpolationFactor = [];
end

properties (Access=protected, AbortSet, SetObservable, GetObservable)
  %PRIVINTERPOLATIONFACTOR Property is of type 'posint user-defined'
  privInterpolationFactor = 2;
end

properties (SetObservable, GetObservable)
  %RESPONSE Property is of type 'interpolator_responses enumeration: {'Nyquist','Halfband','Lowpass','CIC','CIC Compensator','Inverse-sinc Lowpass','Highpass','Hilbert','Differentiator','Bandpass','Bandstop','Arbitrary Magnitude','Arbitrary Magnitude and Phase','Raised Cosine','Square Root Raised Cosine','Gaussian','Inverse-sinc Highpass'}' 
  Response 
end


methods  % constructor block
  function this = interpolator(L, DT, varargin)

  % this = fdesign.interpolator;

  this.MultirateType = 'Interpolator';

  this.Response = 'Nyquist';
  
  needsDefaults = true;

  if nargin > 0
      this.InterpolationFactor = L;
      if nargin > 1
          if isa(DT, 'fdesign.pulseshaping')
              error(message('signal:fdesign:interpolator:interpolator:unsupportedResponse', class( DT )));
          end
          if isa(DT, 'fdesign.abstracttypewspecs')
              this.AllFDesign = copy(DT);
              this.CurrentFDesign = [];
              [~, DT] = strtok(class(DT), '.');
              DT(1) = [];
              needsDefaults = false;
          end
          newresp = mapresponse(this, DT);
          if strcmpi(newresp, this.Response)
              updatecurrentfdesign(this);
          else
              this.Response = newresp;
          end
      end
  end

  if needsDefaults
      multiratedefaults(this.CurrentFDesign, this.InterpolationFactor);
  end

  setspecs(this, varargin{:});


  end  % interpolator

end  % constructor block

methods 
  function set.privInterpolationFactor(obj,value)
  % User-defined DataType = 'posint user-defined'
  obj.privInterpolationFactor = value;
  end
  %------------------------------------------------------------------------
  function value = get.Response(obj)
  value = get_response(obj,obj.Response);
  end
  %------------------------------------------------------------------------
  function set.Response(obj,value)
  value = validatestring(value,getAllowedStringValues(obj,'Response'),'','Response');
  obj.Response = set_response(obj,value);
  end
  %------------------------------------------------------------------------
  function value = get.InterpolationFactor(obj)
  value = get_interpolationfactor(obj,obj.InterpolationFactor);
  end
  %------------------------------------------------------------------------
  function set.InterpolationFactor(obj,value)
  % User-defined DataType = 'posint user-defined'
  validateattributes(value,{'numeric'},{'integer','positive','scalar'}...
  ,'','InterpolationFactor')
  obj.InterpolationFactor = set_interpolationfactor(obj,value);
  end

end   % set and get functions 

methods
  function vals = getAllowedStringValues(obj,prop)
    if strcmp(prop,'Response')
      vals = {'Nyquist',...
        'Halfband',...
        'Lowpass',...
        'CIC',...
        'CIC Compensator',...
        'Inverse-sinc Lowpass',...
        'Highpass',...
        'Hilbert',...
        'Differentiator',...
        'Bandpass',...
        'Bandstop',...
        'Arbitrary Magnitude',...
        'Arbitrary Magnitude and Phase',...
        'Raised Cosine',...
        'Square Root Raised Cosine',...
        'Gaussian',...
        'Inverse-sinc Highpass'}';
    elseif strcmp(prop,'Specification')
      vals = fdesign.interpolator.getspeclist(obj.Response)';
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
    cpropList = propstoadd(obj.CurrentFDesign);
    fs_indx = find(strcmpi('Fs',cpropList));

    if isfield(propList, 'SamplesPerSymbol')
        propList = reorderstructure(propList, 'MultirateType','Response', ...
          'InterpolationFactor', 'SamplesPerSymbol','Specification', ...
          cpropList{1:fs_indx-1},'Fs','Fs_in','Fs_out',cpropList{fs_indx:end});
    else
       propList = reorderstructure(propList, 'MultirateType','Response', ...
         'InterpolationFactor', 'Specification', cpropList{1:fs_indx-1}, ...
         'Fs','Fs_in','Fs_out',cpropList{fs_indx:end});
    end
    
    if propList.NormalizedFrequency
      propList = rmfield(propList, {'Fs', 'Fs_in', 'Fs_out'});
    end
    
    propgrp = matlab.mixin.util.PropertyGroup(propList);
  end
end

methods  % public methods
  varargout = butter(this,varargin)
  varargout = ellip(this,varargin)
  fs_in = get_fs_in(this,fs_in)
  fs_out = get_fs_out(this,fs_out)
  interpolationfactor = get_interpolationfactor(this,interpolationfactor)
  cicconstructor = getcicconstructor(this)
  defaultmethod = getdefaultmethod(this)
  ratechangefactors = getratechangefactors(this)
  varargout = ifir(this,varargin)
  varargout = multistage(this,varargin)
  g = nominalgain(this)
  flag = passbandspecmet(Hf,Hd,ng)
  interpolationfactor = set_interpolationfactor(this,interpolationfactor)
  setratechangefactors(this,ratechangefactors)
  varargout = thisdesign(this,method,varargin)
  updatefdesignfactors(this)
  vs = validstructures(this,varargin)
end  % public methods 


methods (Hidden) % possibly private or hidden
  d = designopts(this,varargin)
  varargout = iirlinphase(this,varargin)
  validate_iir_designmethod(this,designMethod)
end  % possibly private or hidden 

methods (Static) % static methods
  [specList] = getspeclist(response)
end  % static methods 

end  % classdef

