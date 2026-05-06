classdef (Abstract) abstractparameqflfh < fspecs.abstractparameqbwflfh
%ABSTRACTPARAMEQBWFLFH   Construct an ABSTRACTPARAMEQBWFLFH object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractparameqflfh class
%   fspecs.abstractparameqflfh extends fspecs.abstractparameqbwflfh.
%
%    fspecs.abstractparameqflfh properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       G0 - Property is of type 'double'  
%       Gref - Property is of type 'double'  
%       GBW - Property is of type 'double'  
%       Flow - Property is of type 'double'  
%       Fhigh - Property is of type 'double'  
%
%    fspecs.abstractparameqflfh methods:
%       islphpreorder - True filter response is lowpass or highpass
%       measureinfo -   Return a structure of information for the measurements.
%       props2normalize -   Return the property name to normalize.


properties (AbortSet, SetObservable, GetObservable)
    %FLOW Property is of type 'double' 
    Flow = 0.4;
    %FHIGH Property is of type 'double' 
    Fhigh = 0.6;
end


    methods 
        function set.Flow(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Flow')
        value = double(value);
        obj.Flow = value;
        end

        function set.Fhigh(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Fhigh')
        value = double(value);
        obj.Fhigh = value;
        end

    end   % set and get functions 

    methods  % public methods
    b = islphpreorder(this)
    minfo = measureinfo(this)
    p = props2normalize(this)
end  % public methods 

end  % classdef

