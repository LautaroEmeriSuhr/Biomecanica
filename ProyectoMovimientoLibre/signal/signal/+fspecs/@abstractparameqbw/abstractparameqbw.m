classdef (Abstract) abstractparameqbw < fspecs.abstractparameqbwflfh
%ABSTRACTPARAMEQBW   Construct an ABSTRACTPARAMEQBW object.

%   Copyright 1999-2015 The MathWorks, Inc.  

%fspecs.abstractparameqbw class
%   fspecs.abstractparameqbw extends fspecs.abstractparameqbwflfh.
%
%    fspecs.abstractparameqbw properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       G0 - Property is of type 'double'  
%       Gref - Property is of type 'double'  
%       GBW - Property is of type 'double'  
%       F0 - Property is of type 'double'  
%       BW - Property is of type 'double'  
%
%    fspecs.abstractparameqbw methods:
%       islphpreorder - True filter response is lowpass or highpass
%       measureinfo -   Return a structure of information for the measurements.
%       props2normalize -   Return the property name to normalize.


properties (AbortSet, SetObservable, GetObservable)
    %F0 Property is of type 'double' 
    F0 = 0.5;
    %BW Property is of type 'double' 
    BW = 0.2;
end


    methods 
        function set.F0(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','F0')
        value = double(value);
        obj.F0 = value;
        end

        function set.BW(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','BW')
        value = double(value);
        obj.BW = value;
        end

    end   % set and get functions 

    methods  % public methods
    b = islphpreorder(this)
    minfo = measureinfo(this)
    p = props2normalize(this)
end  % public methods 

end  % classdef

