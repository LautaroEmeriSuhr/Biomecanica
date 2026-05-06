classdef audioweightingwt < fspecs.abstractaudioweighting
%AUDIOWEIGHTINGWT   Construct an AUDIOWEIGHTINGWWT object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.audioweightingwt class
%   fspecs.audioweightingwt extends fspecs.abstractaudioweighting.
%
%    fspecs.audioweightingwt properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       WeightingType - Property is of type 'WTTypesIT enumeration: {'Cmessage','ITUT041','ITUR4684'}'  
%
%    fspecs.audioweightingwt methods:
%       describe -   Describe the object.
%       getdesignobj -   Get the design object.
%       interpfreqpoints -  Perform linear or log-linear interpolation between two
%       set_weightingtype - PreSet function for the 'WeightingType' property
%       setcmessageweightingmask -   Set the mask for C-Message Weighting.
%       setitur4684weightingmask -   Set the mask for ITU-R 468-4 Weighting.
%       setitut041weightingmask -   Set the mask for ITU-T 0.41 Weighting.
%       setmaskspecs -   Set mask specs.


properties (AbortSet, SetObservable, GetObservable)
    %WEIGHTINGTYPE Property is of type 'WTTypesIT enumeration: {'Cmessage','ITUT041','ITUR4684'}' 
    WeightingType = 'Cmessage';
end


    methods  % constructor block
        function this = audioweightingwt(varargin) 
        %AUDIOWEIGHTINGWT  Construct an AUDIOWEIGHTINGWT object.
        
        
        % this = fspecs.audioweightingwt;
        
        this.ResponseType = 'Audio Weighting Filter';
        
        end  % audioweightingwt
        
    end  % constructor block

methods 
    function set.WeightingType(obj,value)
    % Enumerated DataType = 'WTTypesIT enumeration: {'Cmessage','ITUT041','ITUR4684'}'
    value = validatestring(value,{'Cmessage','ITUT041','ITUR4684'},'','WeightingType');
    obj.WeightingType = set_weightingtype(obj,value);
    end

end   % set and get functions 

methods  % public methods
  description = describe(this)
  designobj = getdesignobj(this,str)
  [Fv,Av] = interpfreqpoints(this,Flimits,Alimits,interpFactor,type,varargin)
  wt = set_weightingtype(this,wt)
  setcmessageweightingmask(this)
  setitur4684weightingmask(this)
  setitut041weightingmask(this)
  setmaskspecs(this)
end  % public methods 

methods (Hidden) % possibly private or hidden
  specs = thisgetspecs(this)
  p = thisprops2add(this,varargin)
end  % possibly private or hidden 

end  % classdef

