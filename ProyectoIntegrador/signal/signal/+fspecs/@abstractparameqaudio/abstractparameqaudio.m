classdef (Abstract) abstractparameqaudio < fspecs.abstractparameq
%ABSTRACTPARAMEQAUDIO  Construct an ABSTRACTPARAMEQAUDIO object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractparameqaudio class
%   fspecs.abstractparameqaudio extends fspecs.abstractparameq.
%
%    fspecs.abstractparameqaudio properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       G0 - Property is of type 'double'  
%       F0 - Property is of type 'double'  
%
%    fspecs.abstractparameqaudio methods:
%       islphpreorder - True filter response is lowpass or highpass
%       props2normalize -   Return the property name to normalize.
%       set_F0 - PreSet function for the 'F0' property


properties (AbortSet, SetObservable, GetObservable)
    %F0 Property is of type 'double' 
    F0
end


    methods 
        function set.F0(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','F0')
        value = double(value);
        obj.F0 = set_F0(obj,value);
        end

    end   % set and get functions 

    methods  % public methods
    b = islphpreorder(this)
    p = props2normalize(this)
    F0 = set_F0(this,F0)
end  % public methods 

end  % classdef

