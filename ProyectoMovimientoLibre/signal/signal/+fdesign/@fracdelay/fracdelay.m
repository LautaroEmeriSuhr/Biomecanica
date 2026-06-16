classdef (CaseInsensitiveProperties=true, TruncatedProperties=true) fracdelay < fdesign.abstracttypewspecs & dynamicprops
%FRACDELAY   Construct a fractional delay filter designer.
%   D = FDESIGN.FRACDELAY(DELTA) constructs a fractional delay filter
%   designer D with a delay of DELTA samples. The fractional delay DELTA
%   must be between 0 and 1.
%
%   D = FDESIGN.FRACDELAY(DELTA,'N') initializes the filter designer
%   'Specification' property to 'N' where the filter order N defaults to 3.
%
%   D = FDESIGN.FRACDELAY(DELTA,'N',N) initializes the filter designer
%   specifications with 'N' and sets the filter order to the value N. 
%
%   D = FDESIGN.FRACDELAY(DELTA,N) uses the default specification ('N') and
%   sets the filter order to the value N.
%
%   D = FDESIGN.FRACDELAY(...,Fs) specifies the sampling frequency (in Hz).
%   In this case, the fractional delay DELTA is expressed in seconds. The
%   fractional delay DELTA must be between 0 and 1/Fs.
%
%   % Example #1 
%        %Design a second order fractional delay filter of 0.2 samples using 
%        %the Lagrange method. Implement the filter using a Farrow FD structure.
%        d = fdesign.fracdelay(0.2,'N',2);
%        Hd = design(d, 'lagrange', 'FilterStructure', 'farrowfd'); 
%        fvtool(Hd, 'Analysis', 'grpdelay')
%
%   % Example #2
%        %Design a cubic fractional delay filter with a sampling frequency 
%        %of 8 kHz and a fractional delay of 50 microseconds using the 
%        %Lagrange method.
%        d = fdesign.fracdelay(50e-6,'N',3,8000);
%        Hd = design(d, 'lagrange', 'FilterStructure', 'farrowfd');
%        fvtool(Hd)
%
%   For more information about fractional delay filter implementations, see
%   the <a href="matlab:web([matlabroot,'\toolbox\dsp\dspdemos\html\farrowdemo.html'])">Fractional Delay Filters Using Farrow Structures</a> demo. 
%
%   See also FDESIGN, FDESIGN/SETSPECS, FDESIGN/DESIGN.

%   Copyright 2004-2015 The MathWorks, Inc.    
    
%fdesign.fracdelay class
%   fdesign.fracdelay extends fdesign.abstracttypewspecs.
%
%    fdesign.fracdelay properties:
%       Response - Property is of type 'ustring' (read only) 
%       Description - Property is of type 'string vector' (read only) 
%       Specification - Property is of type 'fracdelaySpecTypes enumeration: {'N'}'  
%       FracDelay - Property is of type 'double'  
%
%    fdesign.fracdelay methods:
%       getconstructor -   Get the constructor.
%       getdefaultmethod -   Get the defaultmethod.
%       getmask -   Get the mask.
%       getmeasureconstructor -   Get the measureconstructor.
%       isspecmet -   True if the object is specmet.
%       normalizefreq -  Normalize frequency specifications. 
%       propstocopy -   Returns the properties to copy.
%       set_delay -   PreSet function for the 'delay' property.
%       thisloadobj -   Load this object.
%       thissaveobj -   Save this object.


properties (SetObservable, GetObservable)
  %SPECIFICATION Property is of type 'fracdelaySpecTypes enumeration: {'N'}' 
  Specification 
  %FRACDELAY Property is of type 'double' 
  FracDelay = 0;
end


methods  % constructor block
  function this = fracdelay(varargin)

    % this = fdesign.fracdelay;

    this.Response = 'Fractional Delay';
    fd = 0.5;
    if nargin>0,
        fd = varargin{1};
        varargin(1) = [];
    end
    this.Specification = 'N';
    setspecs(this, varargin{:});
    this.FracDelay = fd;


  end  % fracdelay

end  % constructor block

methods 
  function value = get.Specification(obj)
  value = get_specification(obj,obj.Specification);
  end
  %------------------------------------------------------------------------
  function set.Specification(obj,value)
  % Enumerated DataType = 'fracdelaySpecTypes enumeration: {'N'}'
  value = validatestring(value,getAllowedStringValues(obj,'Specification'),'','Specification');
  obj.Specification = set_specification(obj,value);
  end
  %------------------------------------------------------------------------
  function set.FracDelay(obj,value)
      % DataType = 'double'
  validateattributes(value,{'numeric'}, {'scalar'},'','FracDelay')
  value = double(value);
  obj.FracDelay = set_delay(obj,value);
  end

end   % set and get functions 

methods
    function vals = getAllowedStringValues(obj,prop)
      if strcmp(prop,'Specification')
        vals = {'N'};
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
    propList = reorderstructure(propList,'Response','Specification','Description','FracDelay', cpropList{:});
    if propList.NormalizedFrequency 
      propList = rmfield(propList, 'Fs');
    end
    propgrp = matlab.mixin.util.PropertyGroup(propList);
  end
end

methods  % public methods
  cSpecCon = getconstructor(this,stype)
  defaultmethod = getdefaultmethod(this)
  [F,A,Gd] = getmask(this,fcns,rcf,specs)
  measureconstructor = getmeasureconstructor(this)
  b = isspecmet(this,Hd)
  normalizefreq(this,varargin)
  p = propstocopy(this)
  delay = set_delay(this,delay)
  thisloadobj(this,s)
  s = thissaveobj(this)
end  % public methods 


methods (Hidden) % possibly private or hidden
  b = haspassbandzoom(this)
end  % possibly private or hidden 

end  % classdef

