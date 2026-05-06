classdef audioweightingwtclass < fspecs.abstractaudioweighting
%AUDIOWEIGHTINGWTCLASS   Construct an AUDIOWEIGHTINGWTCLASS object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.audioweightingwtclass class
%   fspecs.audioweightingwtclass extends fspecs.abstractaudioweighting.
%
%    fspecs.audioweightingwtclass properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       WeightingType - Property is of type 'WTTypesANSI enumeration: {'A','C'}'  
%       Class - Property is of type 'mxArray'  
%
%    fspecs.audioweightingwtclass methods:
%       describe -   Describe the object.
%       getacmasklimits - GETACMASKUPPERLOWERLIMITS   Get the mask upper and lower limits for A and C
%       getdesignobj -   Get the design object.
%       set_class - PreSet function for the 'Class' property
%       setaweightingmask -   Set the mask for A-Weighting.
%       setcweightingmask -   Set the mask for C-Weighting.
%       setmaskspecs -   Set mask specs.


properties (AbortSet, SetObservable, GetObservable)
    %WEIGHTINGTYPE Property is of type 'WTTypesANSI enumeration: {'A','C'}' 
    WeightingType = 'A';
    %CLASS Property is of type 'mxArray' 
    Class = 1;
end


    methods  % constructor block
        function this = audioweightingwtclass(varargin) 
        %AUDIOWEIGHTINGWTCLASS  Construct an AUDIOWEIGHTINGWTCLASS object.
        
        
        % this = fspecs.audioweightingwtclass;
        
        this.ResponseType = 'Audio Weighting Filter';
        
        end  % audioweightingwtclass
        
    end  % constructor block

    methods 
        function set.WeightingType(obj,value)
        % Enumerated DataType = 'WTTypesANSI enumeration: {'A','C'}'
        value = validatestring(value,{'A','C'},'','WeightingType');
        obj.WeightingType = value;
        end

        function set.Class(obj,value)
        obj.Class = set_class(obj,value);
        end

    end   % set and get functions 

    methods  % public methods
    description = describe(this)
    [upperClass1,lowerClass1,upperClass2,lowerClass2] = getacmasklimits(~)
    designobj = getdesignobj(this,str)
    class = set_class(this,class)
    setaweightingmask(this)
    setcweightingmask(this)
    setmaskspecs(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    specs = thisgetspecs(this)
    p = thisprops2add(this,varargin)
end  % possibly private or hidden 

end  % classdef

