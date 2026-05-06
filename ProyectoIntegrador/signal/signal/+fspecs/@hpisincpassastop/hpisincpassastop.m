classdef hpisincpassastop < fspecs.abstractlppassastop
%HPISINCPASSASTOP   Construct an HPISINCPASSASTOP object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.hpisincpassastop class
%   fspecs.hpisincpassastop extends fspecs.abstractlppassastop.
%
%    fspecs.hpisincpassastop properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       Fpass - Property is of type 'posdouble user-defined'  
%       Apass - Property is of type 'posdouble user-defined'  
%       Astop - Property is of type 'posdouble user-defined'  
%       FrequencyFactor - Property is of type 'double'  
%       Power - Property is of type 'double'  
%       CICRateChangeFactor - Property is of type 'double'  
%
%    fspecs.hpisincpassastop methods:
%       getdesignobj - Get the design object.
%       measureinfo -  Return a structure of information for the measurements.
%       propstoadd - Return the properties to add to the parent object.
%       thisgetspecs - Get the specs.


properties (AbortSet, SetObservable, GetObservable)
    %FREQUENCYFACTOR Property is of type 'double' 
    FrequencyFactor=0.5;  
    %POWER Property is of type 'double' 
    Power=1;
    %CICRATECHANGEFACTOR Property is of type 'double' 
    CICRateChangeFactor=1;
end


    methods  % constructor block
        function this = hpisincpassastop(varargin)
        %HPISINCPASSASTOP Construct a HPISINCPASSASTOP object.
        
        
        % this = fspecs.hpisincpassastop;
        
        fsconstructor(this,'Inverse-sinc highpass',2,2,6,varargin{:});
        
        
        end  % hpisincpassastop
        
    end  % constructor block

    methods 
        function set.FrequencyFactor(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','FrequencyFactor')
        value = double(value);
        obj.FrequencyFactor = value;
        end

        function set.Power(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Power')
        value = double(value);
        obj.Power = value;
        end

        function set.CICRateChangeFactor(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','CICRateChangeFactor')
        value = double(value);
        obj.CICRateChangeFactor = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(~,str)
    minfo = measureinfo(this)
    p = propstoadd(~)
    specs = thisgetspecs(this)
end  % public methods 

end  % classdef

