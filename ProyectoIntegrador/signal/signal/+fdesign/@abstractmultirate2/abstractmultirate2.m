classdef (Abstract) abstractmultirate2 < fdesign.abstracttype & matlab.mixin.CustomDisplay
%ABSTRACTMULTIRATE2 Abstract constructor produces an error.

%   Copyright 2004-2015 The MathWorks, Inc.
  
%fdesign.abstractmultirate2 class
%   fdesign.abstractmultirate2 extends fdesign.abstracttype.
%
%    fdesign.abstractmultirate2 properties:
%       MultirateType - Property is of type 'ustring' (read only) 
%       Fs_in - Property is of type 'mxArray' (read only) 
%       Fs_out - Property is of type 'mxArray' (read only) 
%
%    fdesign.abstractmultirate2 methods:
%       copy -   Copy this object.
%       get_response -   PreGet function for the 'Response' property.
%       getconstructor - Get the constructor.
%       getcurrentspecs - Get the currentspecs.
%       getdialogconstructor -   Get the dialogconstructor.
%       getfmethod -   Get the fmethod.
%       getmask -   Get the mask.
%       getmeasureconstructor -   Get the measureconstructor.
%       getmeasurements -   Get the measurements.
%       help -   Proved help for the specified design method.
%       hiddenmethods -   Return the hidden methods.
%       isdesignmethod -   True if the object is designmethod.
%       isequivalent -   True if the object is equivalent.
%       loadobj -   Load this object.
%       measureinfo -   Return a structure of information for the measurements.
%       noiseshape - Noise-shape the FIR filter Hd
%       normalizefreq -   Normalize the sampling frequency and the frequency values.
%       parsestruct -   Parse the inputs for the FilterStructure parameter.
%       saveobj -   Save this object.
%       set_currentfdesign -   PreSet function for the 'currentfdesign' property.
%       set_response -   PreSet function for the 'Response' property.
%       setspecs -   Set the specs.
%       thisdesignmethods -   Return the valid design methods.
%       updatecurrentfdesign -   Update the current FDesign object.
%       validatemultiratesysobjstructs - DESIGN   


properties (Access=protected, AbortSet, SetObservable, GetObservable)
  %PRIVRESPONSE Property is of type 'ustring'
  privResponse
  %CURRENTFDESIGN Property is of type 'fdesign.abstracttypewspecs'
  CurrentFDesign = [];
  %ALLFDESIGN Property is of type 'fdesign.abstracttypewspecs vector'
  AllFDesign = [];
  %SPECIFICATIONTYPELISTENERS Property is of type 'handle.listener vector'
  SpecificationTypeListeners = [];
end

properties (SetAccess=protected, AbortSet, SetObservable, GetObservable)
  %MULTIRATETYPE Property is of type 'ustring' (read only)
  MultirateType
  %FS_IN Property is of type 'mxArray' (read only)
  Fs_in = [];
  %FS_OUT Property is of type 'mxArray' (read only)
  Fs_out = [];
end


methods 
  function set.MultirateType(obj,value)
      % DataType = 'ustring'
  validateattributes(value,{'char'}, {'vector'},'','MultirateType')
  obj.MultirateType = value;
  end
  %------------------------------------------------------------------------
  function set.privResponse(obj,value)
      % DataType = 'ustring'
  validateattributes(value,{'char'}, {'vector'},'','privResponse')
  obj.privResponse = value;
  end
  %------------------------------------------------------------------------
  function set.CurrentFDesign(obj,value)
    % DataType = 'fdesign.abstracttypewspecs'
  if ~isempty(value) && ~(isa(value,'fdesign.abstracttypewspecs') && isscalar(value))
    validateattributes(value,{'fdesign.abstracttypewspecs'}, ... 
      {'scalar'},'','CurrentFDesign')
  end
  obj.CurrentFDesign = set_currentfdesign(obj,value);
  end
  %------------------------------------------------------------------------
  function set.AllFDesign(obj,value)
  if ~(isa(value,'fdesign.abstracttypewspecs') && isvector(value))
    validateattributes(value,{'fdesign.abstracttypewspecs'}, ...
      {'vector'},'','AllFDesign')
  end
  obj.AllFDesign = value;
  end
  %------------------------------------------------------------------------
  function set.SpecificationTypeListeners(obj,value)
  if ~(isa(value,'event.listener') && isvector(value))  
    validateattributes(value,{'event.listener'}, ...
      {'vector'},'','SpecificationTypeListeners')
  end
  obj.SpecificationTypeListeners = value;
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

methods %set/get
  function varargout = set(obj,varargin)
    [varargout{1:nargout}] = signal.internal.signalset(obj,varargin{:});
  end
  %------------------------------------------------------------------------
  function varargout = get(obj,varargin)
    [varargout{1:nargout}] = signal.internal.signalget(obj,varargin{:});
  end
end %set/get

methods  % public methods
  Hcopy = copy(this)
  response = get_response(this,response)
  constructor = getconstructor(this,dtype)
  currentspecs = getcurrentspecs(this)
  dialogconstructor = getdialogconstructor(this)
  hfmethod = getfmethod(this,varargin)
  [F,A] = getmask(this,fcns,rcf,varargin)
  measureconstructor = getmeasureconstructor(this)
  measurements = getmeasurements(this,varargin)
  help(this,varargin)
  m = hiddenmethods(this)
  b = isdesignmethod(this,varargin)
  b = isequivalent(this,htest)
  minfo = measureinfo(this)
  Hns = noiseshape(this,Hd,WL,args)
  normalizefreq(this,varargin)
  [filtstruct,varargin] = parsestruct(this,filtstruct,method,varargin)
  s = saveobj(this)
  newfdesign = set_currentfdesign(this,newfdesign)
  response = set_response(this,response)
  setspecs(this,varargin)
  varargout = thisdesignmethods(this,varargin)
  updatecurrentfdesign(this)
  validatemultiratesysobjstructs(this,method,struct,sysObjFlag)
end  % public methods 


methods (Hidden) % possibly private or hidden
  h = decimdelaynoble(this,Hd,dfactor,delay,h,count)
  Hnew = decimmergedelays(this,Hvec)
  dopts = designoptions(this,dmethod,varargin)
  b = haspassbandzoom(this)
  h = interpdelaynoble(this,Hd,ifactor,delay,h,count)
  Hnew = interpmergedelays(this,Hvec)
  R = mapresponse(~,SR)
  [x,y] = thispassbandzoom(this,fcns,Hd,hfm)
end  % possibly private or hidden 


methods (Static) % static methods
  this = loadobj(s)
end  % static methods 

end  % classdef

