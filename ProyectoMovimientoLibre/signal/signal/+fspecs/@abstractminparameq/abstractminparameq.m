classdef (Abstract) abstractminparameq < fspecs.abstractspecwithfs
%ABSTRACTMINPARAMEQ   Construct an ABSTRACTMINPARAMEQ object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractminparameq class
%   fspecs.abstractminparameq extends fspecs.abstractspecwithfs.
%
%    fspecs.abstractminparameq properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       Gref - Property is of type 'double'  
%       G0 - Property is of type 'double'  
%       F0 - Property is of type 'double'  
%       BW - Property is of type 'double'  
%       GBW - Property is of type 'double'  
%
%    fspecs.abstractminparameq methods:
%       islphpreorder - True filter response is lowpass or highpass
%       measureinfo -   Return a structure of information for the measurements.
%       propstoadd -   Return the properties to add to the parent object.
%       setspecs -   Set the specifications


properties (AbortSet, SetObservable, GetObservable)
    %GREF Property is of type 'double' 
    Gref = -10;
    %G0 Property is of type 'double' 
    G0 = 0;
    %F0 Property is of type 'double' 
    F0 = 0.5;
    %BW Property is of type 'double' 
    BW = 0.3;
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

        function set.G0(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','G0')
        value = double(value);
        obj.G0 = value;
        end

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

        function set.GBW(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','GBW')
        value = double(value);
        obj.GBW = value;
        end

    end   % set and get functions 

    methods  % public methods
    b = islphpreorder(this)
    minfo = measureinfo(this)
    p = propstoadd(this)
    setspecs(this,varargin)
end  % public methods 

end  % classdef

