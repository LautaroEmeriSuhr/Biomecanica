classdef (Abstract) abstractcic < fdesign.abstracttypewspecs
%ABSTRACTCIC Abstract constructor produces an error.

%   Copyright 2004-2015 The MathWorks, Inc.
  
%fdesign.abstractcic class
%   fdesign.abstractcic extends fdesign.abstracttypewspecs.
%
%    fdesign.abstractcic properties:
%       Response - Property is of type 'ustring' (read only) 
%       Description - Property is of type 'string vector' (read only) 
%       Specification - Property is of type 'cicSpecTypes enumeration: {'Fp,Ast'}'  
%       DifferentialDelay - Property is of type 'posint user-defined'  
%
%    fdesign.abstractcic methods:
%       get_differentialdelay -   PreGet function for the 'differentialdelay'
%       getmeasureconstructor -   Get the measureconstructor.
%       multisection - DESIGN   Design the CIC filter.
%       propstoadd -   Return the properties to add to the parent object.
%       set_differentialdelay -   PreSet function for the 'differentialdelay' property.
%       setspecs -   Set the specs.
%       thisloadobj -   Load this object.
%       thissaveobj -   Save this object.


properties (Access=protected, AbortSet, SetObservable, GetObservable)
  %PRIVDIFFERENTIALDELAY Property is of type 'posint user-defined'
  privDifferentialDelay = 1;
end

properties (SetObservable, GetObservable)
  %SPECIFICATION Property is of type 'cicSpecTypes enumeration: {'Fp,Ast'}' 
  Specification = 'Fp,Ast';
  %DIFFERENTIALDELAY Property is of type 'posint user-defined' 
  DifferentialDelay = [];
end


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
  function set.privDifferentialDelay(obj,value)
  % User-defined DataType = 'posint user-defined'
  obj.privDifferentialDelay = value;
  end
  %------------------------------------------------------------------------
  function value = get.DifferentialDelay(obj)
  value = get_differentialdelay(obj,obj.DifferentialDelay);
  end
  %------------------------------------------------------------------------
  function set.DifferentialDelay(obj,value)
  % User-defined DataType = 'posint user-defined'
    validateattributes(value,{'numeric'},{'integer','positive','scalar'}...
    ,'','')
  obj.DifferentialDelay = set_differentialdelay(obj,value);
  end

end   % set and get functions 

methods  % public methods
  diffd = get_differentialdelay(this,diffd)
  measureconstructor = getmeasureconstructor(this)
  varargout = multisection(this,varargin)
  p = propstoadd(this)
  diffd = set_differentialdelay(this,diffd)
  setspecs(this,M,varargin)
  thisloadobj(this,s)
  s = thissaveobj(this)
end  % public methods 

methods
    function vals = getAllowedStringValues(obj,prop)
      if strcmp(prop,'Specification')
          vals = {'Fp,Ast'}';
      else
        vals = {};
      end
    end
end

methods (Hidden) % possibly private or hidden
  [F,A] = abstract_cicmask(this,fcns,R,M,N,fp,Aa)
  b = haspassbandzoom(this)
end  % possibly private or hidden 

end  % classdef

