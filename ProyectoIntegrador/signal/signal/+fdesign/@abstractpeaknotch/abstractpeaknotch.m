classdef (Abstract) abstractpeaknotch < fdesign.abstracttypewspecs
%ABSTRACTPEAKNOTCH Abstract constructor produces an error.

%   Copyright 2004-2015 The MathWorks, Inc.
  
%fdesign.abstractpeaknotch class
%   fdesign.abstractpeaknotch extends fdesign.abstracttypewspecs.
%
%    fdesign.abstractpeaknotch properties:
%       Response - Property is of type 'ustring' (read only) 
%       Description - Property is of type 'string vector' (read only) 
%       Specification - Property is of type 'notchSpecTypes enumeration: {'N,F0,Q','N,F0,Q,Ap','N,F0,Q,Ast','N,F0,Q,Ap,Ast','N,F0,BW','N,F0,BW,Ap','N,F0,BW,Ast','N,F0,BW,Ap,Ast'}'  
%
%    fdesign.abstractpeaknotch methods:
%       getmask -   Get the mask.
%       getmeasureconstructor -   Get the measureconstructor.
%       getmeasurementfields -   Get the measurementfields.


properties (SetObservable, GetObservable)
    %SPECIFICATION Property is of type 'notchSpecTypes enumeration: {'N,F0,Q','N,F0,Q,Ap','N,F0,Q,Ast','N,F0,Q,Ap,Ast','N,F0,BW','N,F0,BW,Ap','N,F0,BW,Ast','N,F0,BW,Ap,Ast'}' 
  Specification 
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

end   % set and get functions 

methods
    function vals = getAllowedStringValues(obj,prop)
      if strcmp(prop,'Specification')
        vals = {'N,F0,Q',...
                'N,F0,Q,Ap',...
                'N,F0,Q,Ast',...
                'N,F0,Q,Ap,Ast',...
                'N,F0,BW',...
                'N,F0,BW,Ap',...
                'N,F0,BW,Ast',...
                'N,F0,BW,Ap,Ast'}';
      else
        vals = {};
      end
    end
end
    
methods  % public methods
  [f,a] = getmask(this,varargin)
  measureconstructor = getmeasureconstructor(this)
  measurementfields = getmeasurementfields(this)
end  % public methods 

end  % classdef

% [EOF]
