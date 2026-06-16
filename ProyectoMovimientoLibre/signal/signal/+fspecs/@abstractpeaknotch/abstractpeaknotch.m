classdef (Abstract) abstractpeaknotch < fspecs.abstractspecwithordnfs
%ABSTRACTPEAKNOTCH   Construct an ABSTRACTPEAKNOTCH object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractpeaknotch class
%   fspecs.abstractpeaknotch extends fspecs.abstractspecwithordnfs.
%
%    fspecs.abstractpeaknotch properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       F0 - Property is of type 'double'  
%
%    fspecs.abstractpeaknotch methods:
%       props2normalize -   Return the property name to normalize.
%       propstoadd -   Return the properties to add to the parent object.
%       setspecs -   Set the specifications


properties (AbortSet, SetObservable, GetObservable)
    %F0 Property is of type 'double' 
    F0 = 0.5;
end


    methods 
        function set.F0(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','F0')
        value = double(value);
        obj.F0 = value;
        end

    end   % set and get functions 

    methods  % public methods
    p = props2normalize(this)
    p = propstoadd(this)
    setspecs(this,varargin)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    [p,s] = magprops(this)
end  % possibly private or hidden 

end  % classdef

