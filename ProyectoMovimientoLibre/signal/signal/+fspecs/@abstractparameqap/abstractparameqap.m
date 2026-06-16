classdef (Abstract) abstractparameqap < fspecs.abstractparameqbw
%ABSTRACTPARAMEQAP   Construct an ABSTRACTPARAMEQAPS object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractparameqap class
%   fspecs.abstractparameqap extends fspecs.abstractparameqbw.
%
%    fspecs.abstractparameqap properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       G0 - Property is of type 'double'  
%       Gref - Property is of type 'double'  
%       GBW - Property is of type 'double'  
%       F0 - Property is of type 'double'  
%       BW - Property is of type 'double'  
%       Gpass - Property is of type 'double'  


properties (AbortSet, SetObservable, GetObservable)
    %GPASS Property is of type 'double' 
    Gpass = -1;
end


    methods 
        function set.Gpass(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Gpass')
        value = double(value);
        obj.Gpass = value;
        end

    end   % set and get functions 
end  % classdef

