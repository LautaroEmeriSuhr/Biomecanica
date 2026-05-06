classdef (Abstract) abstractparameqmeas < fdesign.abstractmeas
%ABSTRACTPARAMEQMEAS Abstract constructor produces an error.

%   Copyright 2004-2015 The MathWorks, Inc.
  
%fdesign.abstractparameqmeas class
%   fdesign.abstractparameqmeas extends fdesign.abstractmeas.
%
%    fdesign.abstractparameqmeas properties:
%       NormalizedFrequency - Property is of type 'bool' (read only) 
%       Fs - Property is of type 'mxArray' (read only) 
%       F0 - Property is of type 'mxArray' (read only) 
%       BW - Property is of type 'mxArray' (read only) 
%       BWpass - Property is of type 'mxArray' (read only) 
%       BWstop - Property is of type 'mxArray' (read only) 
%       Flow - Property is of type 'mxArray' (read only) 
%       Fhigh - Property is of type 'mxArray' (read only) 
%       GBW - Property is of type 'mxArray' (read only) 
%       LowTransitionWidth - Property is of type 'mxArray' (read only) 
%       HighTransitionWidth - Property is of type 'mxArray' (read only) 
%
%    fdesign.abstractparameqmeas methods:
%       getprops2norm -   Get the props2norm.
%       setprops2norm -   Set the props2norm.


properties (SetAccess=protected, AbortSet, SetObservable, GetObservable)
  %F0 Property is of type 'mxArray' (read only)
  F0 = [];
  %BW Property is of type 'mxArray' (read only)
  BW = [];
  %BWPASS Property is of type 'mxArray' (read only)
  BWpass = [];
  %BWSTOP Property is of type 'mxArray' (read only)
  BWstop = [];
  %FLOW Property is of type 'mxArray' (read only)
  Flow = [];
  %FHIGH Property is of type 'mxArray' (read only)
  Fhigh = [];
  %GBW Property is of type 'mxArray' (read only)
  GBW = [];
  %LOWTRANSITIONWIDTH Property is of type 'mxArray' (read only)
  LowTransitionWidth = [];
  %HIGHTRANSITIONWIDTH Property is of type 'mxArray' (read only)
  HighTransitionWidth = [];
end


methods 
  function set.F0(obj,value)
  obj.F0 = value;
  end
  %------------------------------------------------------------------------
  function set.BW(obj,value)
  obj.BW = value;
  end
   %------------------------------------------------------------------------
  function set.BWpass(obj,value)
  obj.BWpass = value;
  end
   %------------------------------------------------------------------------
  function set.BWstop(obj,value)
  obj.BWstop = value;
  end
   %------------------------------------------------------------------------
  function set.Flow(obj,value)
  obj.Flow = value;
  end
   %------------------------------------------------------------------------
  function set.Fhigh(obj,value)
  obj.Fhigh = value;
  end
   %------------------------------------------------------------------------
  function set.GBW(obj,value)
  obj.GBW = value;
  end
   %------------------------------------------------------------------------
  function set.LowTransitionWidth(obj,value)
  obj.LowTransitionWidth = value;
  end
   %------------------------------------------------------------------------
  function set.HighTransitionWidth(obj,value)
  obj.HighTransitionWidth = value;
  end

end   % set and get functions 

methods  % public methods
  props2norm = getprops2norm(this)
  setprops2norm(this,props2norm)
end  % public methods 

end  % classdef

