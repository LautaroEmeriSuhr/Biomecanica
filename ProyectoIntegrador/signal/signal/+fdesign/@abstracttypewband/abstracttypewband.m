classdef (Abstract) abstracttypewband < fdesign.abstracttypewspecs
%ABSTRACTTYPEWBAND Abstract constructor produces an error.

%   Copyright 2004-2015 The MathWorks, Inc.  
  
%fdesign.abstracttypewband class
%   fdesign.abstracttypewband extends fdesign.abstracttypewspecs.
%
%    fdesign.abstracttypewband properties:
%       Response - Property is of type 'ustring' (read only) 
%       Description - Property is of type 'string vector' (read only) 
%       Band - Property is of type 'posint user-defined'  
%
%    fdesign.abstracttypewband methods:
%       get_band -   PreGet function for the 'band' property.
%       propstocopy -   Returns the properties to copy.
%       set_band -   PreSet function for the 'band' property.
%       thisloadobj -   Load this object.
%       thissaveobj -   Save this object.


properties (AbortSet, SetObservable, GetObservable)
  %BAND Property is of type 'posint user-defined' 
  Band = [];
end

properties (Access=protected, AbortSet, SetObservable, GetObservable)
  %PRIVBAND Property is of type 'posint user-defined'
  privBand = 2;
end


methods 
  function set.privBand(obj,value)
  % User-defined DataType = 'posint user-defined'
  obj.privBand = value;
  end
  %------------------------------------------------------------------------
  function value = get.Band(obj)
    value = get_band(obj,obj.Band); 
  end
  %------------------------------------------------------------------------
  function set.Band(obj,value)
  % User-defined DataType = 'posint user-defined'
    validateattributes(value,{'numeric'},{'integer','positive','scalar'}...
  ,'','Band')
    obj.Band = set_band(obj,value);
  end
end   % set and get functions 

methods  % public methods
  band = get_band(this,band)
  p = propstocopy(this)
  band = set_band(this,band)
  thisloadobj(this,s)
  s = thissaveobj(this)
end  % public methods 

end  % classdef

