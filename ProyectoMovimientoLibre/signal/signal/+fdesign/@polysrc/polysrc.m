classdef (CaseInsensitiveProperties=true) polysrc < fdesign.abstracttypewspecs & dynamicprops
%POLYSRC Construct a polynomial sample-rate converter (POLYSRC) filter designer.
%   D = FDESIGN.POLYSRC(L,M) constructs a polynomial sample-rate converter
%   filter designer D with an interpolation factor L and a decimation factor
%   M.  If L is not specified, it defaults to 3.  If M is not specified it
%   defaults to 2. Notice that L and M can be arbitrary positive numbers.
%
%   D = FDESIGN.POLYSRC(L,M,'Fractional Delay') initializes the filter
%   designer 'Response' property with 'Fractional Delay'.
%
%   D = FDESIGN.POLYSRC(L,M,'Fractional Delay','Np',Np) initializes the
%   filter designer specification with 'Np'and sets the polynomial order to
%   the value Np. If omitted Np defaults to 3.
%
%   D = FDESIGN.POLYSRC(...,Fs) specifies the sampling frequency (in Hz).
%
%   Example
%      %Design sample-rate converter that uses a 3rd order Lagrange 
%      %interpolation filter to convert from 44.1kHz to 48kHz.
%      [L,M] = rat(48/44.1);
%      f = fdesign.polysrc(L,M,'Fractional Delay','Np',3);
%      Hm = design(f,'lagrange');
%      Fs = 44.1e3;                         % Original sampling frequency
%      n = 0:9407;                          % 9408 samples, 0.213 seconds long
%      x  = sin(2*pi*1e3/Fs*n);             % Original signal, sinusoid at 1kHz
%      y = filter(Hm,x);                    % 10241 samples, still 0.213 seconds
%      stem(n(1:45)/Fs,x(1:45))             % Plot original sampled at 44.1kHz
%      hold on
%      % Plot fractionally interpolated signal (48kHz) in red
%      stem((n(3:51)-2)/(Fs*L/M),y(3:51),'r','filled') 
%      xlabel('Time (sec)');ylabel('Signal value')
%      legend('44.1 kHz sample rate','48 kHz sample rate')
%
%   For more information about Farrow SRCs, see the
%   <a href="matlab:web([matlabroot,'\toolbox\dsp\dspdemos\html\efficientsrcdemo.html'])">Efficient Sample Rate Conversion between Arbitrary Factors</a> demo. 

%   Copyright 2004-2015 The MathWorks, Inc.

%fdesign.polysrc class
%   fdesign.polysrc extends fdesign.abstracttypewspecs.
%
%    fdesign.polysrc properties:
%       Response - Property is of type 'ustring' (read only) 
%       Description - Property is of type 'string vector' (read only) 
%       Specification - Property is of type 'farrowSRCSpecTypes enumeration: {'Np'}'  
%       MultirateType - Property is of type 'ustring' (read only) 
%       InterpolationFactor - Property is of type 'mxArray'  
%       DecimationFactor - Property is of type 'mxArray'  
%       Fs_in - Property is of type 'mxArray' (read only) 
%       Fs_out - Property is of type 'mxArray' (read only) 
%
%    fdesign.polysrc methods:
%       disp -   Display this object.
%       get_decimationfactor -   PreGet function for the 'decimationfactor'
%       get_fs_in -   PreGet function for the 'fs_in' property.
%       get_fs_out -   PreGet function for the 'fs_out' property.
%       get_interpolationfactor -   PreGet function for the 'interpolationfactor' property.
%       getconstructor -   Get the constructor.
%       getmask -   Get the mask.
%       measure -   Measure this object.
%       propstocopy -   Returns the properties to copy.
%       set_decimationfactor -  PreSet function for the 'decimationfactor' property.
%       set_interpolationfactor -   PreSet function for the 'interpolationfactor' property.
%       setratechangefactors -   Set the ratechangefactors.
%       thisloadobj -   Load this object.
%       thissaveobj - Save this object.


properties (AbortSet, SetObservable, GetObservable)
  %INTERPOLATIONFACTOR Property is of type 'mxArray' 
  InterpolationFactor = [];
  %DECIMATIONFACTOR Property is of type 'mxArray' 
  DecimationFactor = [];
end

properties (Access=protected, AbortSet, SetObservable, GetObservable)
  %PRIVINTERPOLATIONFACTOR Property is of type 'posdouble user-defined'
  privInterpolationFactor = 3;
  %PRIVDECIMATIONFACTOR Property is of type 'posdouble user-defined'
  privDecimationFactor = 2;
end

properties (SetAccess=protected, AbortSet, SetObservable, GetObservable)
  %MULTIRATETYPE Property is of type 'ustring' (read only)
  MultirateType
  %FS_IN Property is of type 'mxArray' (read only)
  Fs_in = [];
  %FS_OUT Property is of type 'mxArray' (read only)
  Fs_out = [];
end

properties (SetObservable, GetObservable)
  %SPECIFICATION Property is of type 'farrowSRCSpecTypes enumeration: {'Np'}' 
  Specification 
end


methods  % constructor block
  function this = polysrc(L,M,response,varargin)

    % this = fdesign.polysrc;
    this.MultirateType = 'Polynomial Sample Rate Converter';
    this.Response = 'Fractional Delay';
    this.Specification = 'Np';
    if nargin > 0
        this.InterpolationFactor = L;
        if nargin > 1
            this.DecimationFactor = M;
            if nargin > 2
                if strcmpi(lower(response),'Fractional Delay'),
                    this.Response = 'Fractional Delay';
                else
                    error(message('signal:fdesign:polysrc:polysrc:InvalidResponse', response));
                end
            end
        end
    end
    setspecs(this, varargin{:});



  end  % polysrc

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
  function set.MultirateType(obj,value)
  validateattributes(value,{'char'}, {'vector'},'','MultirateType')
  obj.MultirateType = value;
  end
  %------------------------------------------------------------------------
  function set.privInterpolationFactor(obj,value)
  % User-defined DataType = 'posdouble user-defined'
  obj.privInterpolationFactor = value;
  end
  %------------------------------------------------------------------------
  function set.privDecimationFactor(obj,value)
  % User-defined DataType = 'posdouble user-defined'
  obj.privDecimationFactor = value;
  end
  %------------------------------------------------------------------------
  function value = get.InterpolationFactor(obj)
  value = get_interpolationfactor(obj,obj.InterpolationFactor);
  end
  %------------------------------------------------------------------------
  function set.InterpolationFactor(obj,value)
  obj.InterpolationFactor = set_interpolationfactor(obj,value);
  end
  %------------------------------------------------------------------------
  function value = get.DecimationFactor(obj)
  value = get_decimationfactor(obj,obj.DecimationFactor);
  end
  function set.DecimationFactor(obj,value)
  obj.DecimationFactor = set_decimationfactor(obj,value);
  end
  %------------------------------------------------------------------------
  function value = get.Fs_in(obj)
  value = get_fs_in(obj,obj.Fs_in);
  end
  %------------------------------------------------------------------------  
  function set.Fs_in(obj,value)
  obj.Fs_in = value;
  end
  %------------------------------------------------------------------------
  function value = get.Fs_out(obj)
  value = get_fs_out(obj,obj.Fs_out);
  end
  %------------------------------------------------------------------------
  function set.Fs_out(obj,value)
  obj.Fs_out = value;
  end

end   % set and get functions 

methods
    function vals = getAllowedStringValues(obj,prop)
      if strcmp(prop,'Specification')
        vals = {'Np'};
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
    propList = reorderstructure(propList,'MultirateType','Response','InterpolationFactor','DecimationFactor','Specification','Description', cpropList{:});
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
  cSpecCon = getconstructor(this,stype)
  [F,A] = getmask(this,fcns,rcf,specs)
  hm = measure(this,Hd,varargin)
  p = propstocopy(this)
  decimationfactor = set_decimationfactor(this,decimationfactor)
  interpolationfactor = set_interpolationfactor(this,interpolationfactor)
  setratechangefactors(this,ratechangefactors)
  thisloadobj(this,s)
  s = thissaveobj(this)
end  % public methods 

end  % classdef

