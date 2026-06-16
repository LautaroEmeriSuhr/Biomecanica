classdef (Abstract) abstractparameqaudioshelf < fspecs.abstractparameqaudio
%ABSTRACTPARAMEQAUDIOSHELF   Construct an ABSTRACTPARAMEQAUDIOSHELF object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractparameqaudioshelf class
%   fspecs.abstractparameqaudioshelf extends fspecs.abstractparameqaudio.
%
%    fspecs.abstractparameqaudioshelf properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       G0 - Property is of type 'double'  
%       F0 - Property is of type 'double'  
%       Fc - Property is of type 'double'  
%
%    fspecs.abstractparameqaudioshelf methods:
%       measureinfo -   Return a structure of information for the measurements.
%       props2normalize -   Return the property name to normalize.
%       propstoadd -   Return the properties to add to the parent object.
%       setspecs -   Set the specifications


properties (AbortSet, SetObservable, GetObservable)
    %FC Property is of type 'double' 
    Fc = .25;
end


    methods 
        function set.Fc(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Fc')
        value = double(value);
        obj.Fc = value;
        end

    end   % set and get functions 

    methods  % public methods
    minfo = measureinfo(this)
    p = props2normalize(this)
    p = propstoadd(this)
    setspecs(this,varargin)
end  % public methods 

end  % classdef

