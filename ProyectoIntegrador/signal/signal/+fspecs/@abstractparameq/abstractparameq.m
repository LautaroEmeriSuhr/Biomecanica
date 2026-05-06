classdef (Abstract) abstractparameq < fspecs.abstractspecwithordnfs
%ABSTRACTPARAMEQ   Construct an ABSTRACTPARAMEQ object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractparameq class
%   fspecs.abstractparameq extends fspecs.abstractspecwithordnfs.
%
%    fspecs.abstractparameq properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       G0 - Property is of type 'double'  
%
%    fspecs.abstractparameq methods:
%       setspecs -   Set the specifications


properties (AbortSet, SetObservable, GetObservable)
    %G0 Property is of type 'double' 
    G0 = 0;
end


    methods 
        function set.G0(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','G0')
        value = double(value);
        obj.G0 = value;
        end

    end   % set and get functions 

    methods  % public methods
    setspecs(this,varargin)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    [p,s] = magprops(this)
end  % possibly private or hidden 

end  % classdef

