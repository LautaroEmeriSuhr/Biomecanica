classdef (Abstract) abstractparameqbwflfh < fspecs.abstractparameq
%ABSTRACTPARAMEQBWFLFH   Construct an ABSTRACTPARAMEQBWFLFH object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractparameqbwflfh class
%   fspecs.abstractparameqbwflfh extends fspecs.abstractparameq.
%
%    fspecs.abstractparameqbwflfh properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       G0 - Property is of type 'double'  
%       Gref - Property is of type 'double'  
%       GBW - Property is of type 'double'  
%
%    fspecs.abstractparameqbwflfh methods:
%       propstoadd -   Return the properties to add to the parent object.


properties (AbortSet, SetObservable, GetObservable)
    %GREF Property is of type 'double' 
    Gref = -10;
    %GBW Property is of type 'double' 
    GBW = 10*log10( .5 );
end


    methods 
        function set.Gref(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Gref')
        value = double(value);
        obj.Gref = value;
        end

        function set.GBW(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','GBW')
        value = double(value);
        obj.GBW = value;
        end

    end   % set and get functions 

    methods  % public methods
    p = propstoadd(this)
end  % public methods 

end  % classdef

