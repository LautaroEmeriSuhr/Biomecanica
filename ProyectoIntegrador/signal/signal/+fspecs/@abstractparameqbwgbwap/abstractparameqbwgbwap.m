classdef (Abstract) abstractparameqbwgbwap < fspecs.abstractminparameq
%ABSTRACTPARAMEQBWGBWAP   Construct an ABSTRACTPARAMEQBWGBWAP object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractparameqbwgbwap class
%   fspecs.abstractparameqbwgbwap extends fspecs.abstractminparameq.
%
%    fspecs.abstractparameqbwgbwap properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       Gref - Property is of type 'double'  
%       G0 - Property is of type 'double'  
%       F0 - Property is of type 'double'  
%       BW - Property is of type 'double'  
%       GBW - Property is of type 'double'  
%       Gpass - Property is of type 'double'  
%       BWpass - Property is of type 'double'  
%
%    fspecs.abstractparameqbwgbwap methods:
%       props2normalize -   Return the property name to normalize.


properties (AbortSet, SetObservable, GetObservable)
    %GPASS Property is of type 'double' 
    Gpass = -1;
    %BWPASS Property is of type 'double' 
    BWpass = 0.2;
end


    methods 
        function set.Gpass(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Gpass')
        value = double(value);
        obj.Gpass = value;
        end

        function set.BWpass(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','BWpass')
        value = double(value);
        obj.BWpass = value;
        end

    end   % set and get functions 

    methods  % public methods
    p = props2normalize(this)
end  % public methods 

end  % classdef

