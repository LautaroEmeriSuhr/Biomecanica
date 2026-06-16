classdef (Abstract) abstractpeaknotchbw < fspecs.abstractpeaknotch
%ABSTRACTPEAKNOTCHBW   Construct an ABSTRACTPEAKNOTCHBW object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractpeaknotchbw class
%   fspecs.abstractpeaknotchbw extends fspecs.abstractpeaknotch.
%
%    fspecs.abstractpeaknotchbw properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       F0 - Property is of type 'double'  
%       BW - Property is of type 'double'  
%
%    fspecs.abstractpeaknotchbw methods:
%       measureinfo -   Return a structure of information for the measurements.
%       props2normalize -   Return the property name to normalize.


properties (AbortSet, SetObservable, GetObservable)
    %BW Property is of type 'double' 
    BW = 0.2;
end


    methods 
        function set.BW(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','BW')
        value = double(value);
        obj.BW = value;
        end

    end   % set and get functions 

    methods  % public methods
    minfo = measureinfo(this)
    p = props2normalize(this)
end  % public methods 

end  % classdef

