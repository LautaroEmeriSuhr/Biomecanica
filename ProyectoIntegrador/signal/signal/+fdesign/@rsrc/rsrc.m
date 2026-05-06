classdef (CaseInsensitiveProperties=true) rsrc < fdesign.abstractmultirate2 & dynamicprops 
%RSRC Construct a rational sample-rate converter (rsrc) filter designer.
%   D = FDESIGN.RSRC(L, M) constructs an rsrc filter designer D with
%   an 'InterpolationFactor' of L and a 'DecimationFactor' of M.  If L is
%   not specified, it defaults to 3.  If M is not specified it defaults to
%   2.
%
%   D = FDESIGN.RSRC(L, M, , RESPONSE) initializes the filter designer
%   'Response' property with RESPONSE.  RESPONSE is one of the following
%   strings and is not case sensitive:
%       'Nyquist' (default)
%       'Halfband'
%       'Lowpass'
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
%   D = FDESIGN.RSRC(L, M, RESPONSE, SPEC) initializes the filter
%   designer 'Specification' property with SPEC.  Use SET(D, 'SPECIFICATION')
%   to get all available specifications for the response RESPONSE.
%
%   Different design and specification types will have different design
%   methods available. Use DESIGNMETHODS(D) to get a list of design
%   methods available for a given SPEC.
%
%   D = FDESIGN.RSRC(L, M, RESPONSE, SPEC, SPEC1, SPEC2, ...) initializes
%   the filter designer specifications with SPEC1, SPEC2, etc.
%   Use GET(D, 'DESCRIPTION') for a description of SPEC1, SPEC2, etc.
%
%   D = FDESIGN.RSRC(...,Fs) specifies the sampling frequency (in Hz). In
%   this case, all frequency properties are also in Hz.
%
%   D = FDESIGN.RSRC(...,MAGUNITS) specifies the units for any magnitude
%   specification given in the constructor. MAGUNITS can be one of the
%   following: 'linear', 'dB', or 'squared'. If this argument is omitted,
%   'dB' is assumed. Note that the magnitude specifications are always
%   converted and stored in dB regardless of how they were specified.
%
%   Some responses have additional constructor inputs. The syntaxes for
%   these special cases are listed below:
%
%   D = FDESIGN.RSRC(L, M, 'CIC compensator', DD, N, R, SPEC, ...) creates
%   a CIC compensator rational sample-rate converter filter designer with
%   the 'InterpolationFactor' property set to L, the 'DecimationFactor'
%   property set to M, the 'DifferentialDelay' property set to DD, the
%   'NumberOfSections' property set to N, and the 'CICRateChangeFactor'
%   property set to R. In general, the design method implements a filter
%   with a passband response equal to an inverse Dirichlet sinc that
%   matches exactly the inverse passband response of a CIC filter with a
%   differential delay equal to DD, number of sections equal to N, and rate
%   change factor equal to R. When R is not specified or is set to 1, the
%   design method implements a filter with a passband response equal to an
%   inverse sinc that is an approximation to the true inverse passband
%   response of the CIC filter.
%
%   D = FDESIGN.RSRC(L, M, PULSESHAPERESP, SPS, SPEC, ...) where
%   PULSESHAPERESP equals 'Raised Cosine', 'Square Root Raised Cosine', or
%   'Gaussian', creates a pulse shaping rational sample-rate converter
%   filter designer with the 'InterpolationFactor' property set to L, the
%   'DecimationFactor' property set to M, and the 'SamplesPerSymbol'
%   property set to SPS.
%
%   % Example #1 - Design a minimum order Nyquist sample-rate converter.
%   d = fdesign.rsrc(5, 3, 'Nyquist',5,0.05, 40);
%   designmethods(d)
%   hm = design(d,'kaiserwin','SystemObject',true);
%
%   % Example #2 - Design a 30th order Nyquist sample-rate converter.
%   d = fdesign.rsrc(5, 3, 'Nyquist', 5, 'N,TW', 30)
%   design(d,'SystemObject',true);
%
%   % Example #3 - Specify frequencies in Hz.
%   d = fdesign.rsrc(5, 3, 'Nyquist', 5, 'N,TW', 12, 0.1, 5)
%   designmethods(d);
%   design(d,'equiripple','SystemObject',true);
%
%   % Example #4 - Specify a stopband ripple in linear units
%   d = fdesign.rsrc(4,7,'Nyquist',7,'TW,Ast',.1,1e-3,5,'linear') % 1e-3 = 60dB
%   design(d,'SystemObject',true);
%
%   See also FDESIGN, FDESIGN/SETSPECS, FDESIGN/DESIGN.

%   Copyright 2004-2015 The MathWorks, Inc.
    
%fdesign.rsrc class
%   fdesign.rsrc extends fdesign.abstractmultirate2.
%
%    fdesign.rsrc properties:
%       MultirateType - Property is of type 'ustring' (read only) 
%       Fs_in - Property is of type 'mxArray' (read only) 
%       Fs_out - Property is of type 'mxArray' (read only) 
%       Response - Property is of type 'rsrc_responses enumeration: {'Nyquist','Halfband','Lowpass','CIC Compensator','Inverse-sinc Lowpass','Highpass','Hilbert','Differentiator','Bandpass','Bandstop','Arbitrary Magnitude','Arbitrary Magnitude and Phase','Raised Cosine','Square Root Raised Cosine','Gaussian','Inverse-sinc Highpass'}'  
%       InterpolationFactor - Property is of type 'posint user-defined'  
%       DecimationFactor - Property is of type 'posint user-defined'  
%
%    fdesign.rsrc methods:
%       disp -   Display this object.
%       get_decimationfactor -   PreGet function for the 'decimationfactor'
%       get_fs_in -   PreGet function for the 'fs_in' property.
%       get_fs_out -   PreGet function for the 'fs_out' property.
%       get_interpolationfactor -   PreGet function for the 'interpolationfactor' property.
%       getdefaultmethod -   Get the defaultmethod.
%       getratechangefactors -   Get the ratechangefactors.
%       ifir -   Design an interpolated FIR filter.
%       nominalgain -   Return the nominal gain.
%       set_decimationfactor -  PreSet function for the 'decimationfactor' property.
%       set_interpolationfactor -   PreSet function for the 'interpolationfactor' property.
%       setratechangefactors -   Set the ratechangefactors.
%       thisdesign - DESIGN   
%       thisdesignmethods -   Return the valid design methods.
%       updatefdesignfactors -   Update the CurrentFDesign rate change factors.
%       validatercf -   Validate the rcf
%       validstructures - Return the valid structure for the design method.


properties (AbortSet, SetObservable, GetObservable)
  %INTERPOLATIONFACTOR Property is of type 'posint user-defined' 
  InterpolationFactor = [];
  %DECIMATIONFACTOR Property is of type 'posint user-defined' 
  DecimationFactor = [];
end

properties (Access=protected, AbortSet, SetObservable, GetObservable)
  %PRIVINTERPOLATIONFACTOR Property is of type 'posint user-defined'
  privInterpolationFactor = 3;
  %PRIVDECIMATIONFACTOR Property is of type 'posint user-defined'
  privDecimationFactor = 2;
end

properties (SetObservable, GetObservable)
  %RESPONSE Property is of type 'rsrc_responses enumeration: {'Nyquist','Halfband','Lowpass','CIC Compensator','Inverse-sinc Lowpass','Highpass','Hilbert','Differentiator','Bandpass','Bandstop','Arbitrary Magnitude','Arbitrary Magnitude and Phase','Raised Cosine','Square Root Raised Cosine','Gaussian','Inverse-sinc Highpass'}' 
  Response 
end


methods  % constructor block
  function this = rsrc(L, M, DT, varargin)

    % this = fdesign.rsrc;

    this.MultirateType = 'Rational Sample Rate Converter';
    
    this.Response = 'Nyquist';

    needsDefaults = true;

    if nargin > 0
        this.InterpolationFactor = L;
        if nargin > 1
            this.DecimationFactor = M;
            if nargin > 2
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
    end

    if needsDefaults
        multiratedefaults(this.CurrentFDesign, max(getratechangefactors(this)));
    end

    setspecs(this, varargin{:});


  end  % rsrc

end  % constructor block

methods 
  function set.privInterpolationFactor(obj,value)
  % User-defined DataType = 'posint user-defined'
  obj.privInterpolationFactor = value;
  end
  %------------------------------------------------------------------------
  function set.privDecimationFactor(obj,value)
  % User-defined DataType = 'posint user-defined'
  obj.privDecimationFactor = value;
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
  function set.InterpolationFactor(obj,value)
  % User-defined DataType = 'posint user-defined'
  validateattributes(value,{'numeric'},{'integer','positive','scalar'}...
  ,'','InterpolationFactor')
  obj.InterpolationFactor = set_interpolationfactor(obj,value);
  end
  %------------------------------------------------------------------------
  function value = get.DecimationFactor(obj)
  value = get_decimationfactor(obj,obj.DecimationFactor);
  end
  %------------------------------------------------------------------------
  function set.DecimationFactor(obj,value)
  % User-defined DataType = 'posint user-defined'
  validateattributes(value,{'numeric'},{'integer','positive','scalar'}...
  ,'','DecimationFactor')
  obj.DecimationFactor = set_decimationfactor(obj,value);
  end

end   % set and get functions 

methods
  function vals = getAllowedStringValues(obj,prop)
    if strcmp(prop,'Response')
      vals = {'Nyquist',...
              'Halfband',...
              'Lowpass',...
              'CIC Compensator', ...
              'Inverse-sinc Lowpass',...
              'Highpass',...
              'Hilbert',...
              'Differentiator', ...
              'Bandpass',...
              'Bandstop',...
              'Arbitrary Magnitude', ...
              'Arbitrary Magnitude and Phase',...
              'Raised Cosine', ...
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
          'InterpolationFactor', 'DecimationFactor', 'SamplesPerSymbol', ...
          'Specification', cpropList{1:fs_indx-1},'Fs','Fs_in', ...
          'Fs_out',cpropList{fs_indx:end});
    else
       propList = reorderstructure(propList, 'MultirateType','Response', ...
         'InterpolationFactor','DecimationFactor','Specification', ....
         cpropList{1:fs_indx-1}, 'Fs','Fs_in','Fs_out',cpropList{fs_indx:end});
    end
    
    if propList.NormalizedFrequency
      propList = rmfield(propList, {'Fs', 'Fs_in', 'Fs_out'});
    end
    
    propgrp = matlab.mixin.util.PropertyGroup(propList);
  end
end

methods  % public methods
  decimationfactor = get_decimationfactor(this,decimationfactor)
  fs_in = get_fs_in(this,fs_in)
  fs_out = get_fs_out(this,fs_out)
  interpolationfactor = get_interpolationfactor(this,interpolationfactor)
  defaultmethod = getdefaultmethod(this)
  ratechangefactors = getratechangefactors(this)
  varargout = ifir(this,varargin)
  g = nominalgain(this)
  decimationfactor = set_decimationfactor(this,decimationfactor)
  interpolationfactor = set_interpolationfactor(this,interpolationfactor)
  setratechangefactors(this,ratechangefactors)
  varargout = thisdesign(this,method,varargin)
  varargout = thisdesignmethods(this,varargin)
  updatefdesignfactors(this)
  validatercf(this,ifactor,dfactor)
  vs = validstructures(this,varargin)
end  % public methods 


methods (Hidden) % possibly private or hidden
  d = designopts(this,varargin)
  Hd = multistage(this,varargin)
end  % possibly private or hidden 

end  % classdef

