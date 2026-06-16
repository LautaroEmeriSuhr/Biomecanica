classdef (Abstract) abstractpeaknotchq < fspecs.abstractpeaknotch
%ABSTRACTPEAKNOTCHQ   Construct an ABSTRACTPEAKNOTCHQ object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractpeaknotchq class
%   fspecs.abstractpeaknotchq extends fspecs.abstractpeaknotch.
%
%    fspecs.abstractpeaknotchq properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       F0 - Property is of type 'double'  
%       Q - Property is of type 'double'  
%
%    fspecs.abstractpeaknotchq methods:
%       measureinfo -   Return a structure of information for the measurements.


properties (AbortSet, SetObservable, GetObservable)
    %Q Property is of type 'double' 
    Q = 2.5;
end


    methods 
        function set.Q(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Q')
        value = double(value);
        obj.Q = value;
        end

    end   % set and get functions 

    methods  % public methods
    minfo = measureinfo(this)
end  % public methods 

end  % classdef

