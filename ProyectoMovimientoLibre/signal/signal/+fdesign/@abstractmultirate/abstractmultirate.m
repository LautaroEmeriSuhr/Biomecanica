classdef (Abstract) abstractmultirate < fdesign.abstracttypewspecs
%ABSTRACTMULTIRATE Abstract constructor produces an error.

%   Copyright 2004-2015 The MathWorks, Inc.
  
%fdesign.abstractmultirate class
%   fdesign.abstractmultirate extends fdesign.abstracttypewspecs.
%
%    fdesign.abstractmultirate properties:
%       Response - Property is of type 'ustring' (read only) 
%       Description - Property is of type 'string vector' (read only) 
%       Specification - Property is of type 'multirateSpecsTypes enumeration: {'TW,Ast','PL,TW','PL','PL,Ast'}'  


properties (Access=protected, AbortSet, SetObservable, GetObservable)
  %PRIVPOLYPHASELENGTH Property is of type 'posint user-defined'
  privPolyphaseLength = 24;
end

properties (SetObservable, GetObservable)
  %SPECIFICATION Property is of type 'multirateSpecsTypes enumeration: {'TW,Ast','PL,TW','PL','PL,Ast'}' 
  Specification = 'TW,Ast';
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
  function set.privPolyphaseLength(obj,value)
  % User-defined DataType = 'posint user-defined'
  obj.privPolyphaseLength = value;
  end

end   % set and get functions 

methods
  function vals = getAllowedStringValues(obj,prop)
    if strcmp(prop,'Specification')
      vals = {'TW,Ast',...
              'PL,TW',...
              'PL',...
              'PL,Ast'}';
    else
      vals = {};
    end
  end
end

end  % classdef

