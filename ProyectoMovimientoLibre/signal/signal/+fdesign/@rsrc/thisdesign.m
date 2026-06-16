function varargout = thisdesign(this, method, varargin)
%DESIGN   

%   Copyright 2005-2011 The MathWorks, Inc.

validatercf(this);

% Parse the inputs for the filterstructure.
[struct, varargin] = parsestruct(this, 'firsrc', method, varargin{:});

% If SystemObject has been passed as an input, remove it and cache its
% value. We do not want to convert the single rate filter design to a
% System object. We will convert the final mfilt object. Validate that the
% requested structure is supported by System objects.
[varargin sysObjFlag] = parsesysobj(this,'design',varargin{:});
validatemultiratesysobjstructs(this, method, struct, sysObjFlag)

n = nargout;
if n == 0
    n = 1;
end

% Call the DESIGN method of the contained FDesign object.
[varargout{1:n}] = design(this.CurrentFDesign,method, varargin{:});

Hm = varargout{1};

% If the filter is not already in an interpolation object, use one.
if ~isa(Hm, 'mfilt.abstractmultirate')
    
    L = this.InterpolationFactor;
    M = this.DecimationFactor;
    
    % Get the coefficients from the filter.
    b = tf(Hm);  
    
    % Scale the coefficients by the interpolation factor to compensate for
    % the gain of upsampling.
    b = b*L;
    
    % Cache the FMETHOD object handle.
    hfmethod = Hm.getfmethod;
    
    % Set the SystemObject property, if it exists, to the cached sysObjFlag
    % value
    if isprop(hfmethod,'SystemObject')
      hfmethod.SystemObject = sysObjFlag;
    end        

    Hm = feval(['mfilt.' struct], L, M, b);
    Hm.setfmethod(hfmethod);
    
else
  % If it is an mfilt object, then get the fmethod object and add the
  % SystemObject design option property
  fm = getfmethod(Hm);
  if ~isprop(fm,'SystemObject')
    addprop(fm,'SystemObject');
    mp = findprop(fm,'SystemObject');
    mp.AbortSet = false;
    mp.Transient = true;
    mp.NonCopyable = true;
  end
  fm.SystemObject = sysObjFlag; 
end
varargout{1} = Hm;
% [EOF]
