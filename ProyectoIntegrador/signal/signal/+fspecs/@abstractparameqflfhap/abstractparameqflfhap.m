classdef (Abstract) abstractparameqflfhap < fspecs.abstractparameqflfh
%ABSTRACTPARAMEQFLFHAP   Construct an ABSTRACTPARAMEQFLFHAP object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractparameqflfhap class
%   fspecs.abstractparameqflfhap extends fspecs.abstractparameqflfh.
%
%    fspecs.abstractparameqflfhap properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       G0 - Property is of type 'double'  
%       Gref - Property is of type 'double'  
%       GBW - Property is of type 'double'  
%       Flow - Property is of type 'double'  
%       Fhigh - Property is of type 'double'  
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

