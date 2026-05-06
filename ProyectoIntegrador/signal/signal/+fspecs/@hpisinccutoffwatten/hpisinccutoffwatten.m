classdef hpisinccutoffwatten < fspecs.abstractlpcutoffwatten
%HPISINCCUTOFFWATTEN   Construct an HPISINCCUTOFFWATTEN object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.hpisinccutoffwatten class
%   fspecs.hpisinccutoffwatten extends fspecs.abstractlpcutoffwatten.
%
%    fspecs.hpisinccutoffwatten properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       Fcutoff - Property is of type 'posdouble user-defined'  
%       Apass - Property is of type 'double'  
%       Astop - Property is of type 'double'  
%       FrequencyFactor - Property is of type 'double'  
%       Power - Property is of type 'double'  
%       CICRateChangeFactor - Property is of type 'double'  
%
%    fspecs.hpisinccutoffwatten methods:
%       getdesignobj - Get the design object.
%       magprops - Return the magnitude properties.
%       measureinfo - Return a structure of information for the measurements.
%       propstoadd - Return the properties to add to the parent object.
%       thisgetspecs - Get the specs.


properties (AbortSet, SetObservable, GetObservable)
    %FREQUENCYFACTOR Property is of type 'double' 
    FrequencyFactor
    %POWER Property is of type 'double' 
    Power
    %CICRATECHANGEFACTOR Property is of type 'double' 
    CICRateChangeFactor
end


    methods  % constructor block
        function this = hpisinccutoffwatten(varargin)
        %HPISINCCUTOFFWATTEN Construct a HPISINCCUTOFFWATTEN object.
        
        
        % this = fspecs.hpisinccutoffwatten;
        
        fstart = 2;
        fstop = 2;
        nargsnoFs = 6;
        fsconstructor(this,'Inverse-sinc highpass',fstart,fstop,nargsnoFs,varargin{:});
        
        
        end  % hpisinccutoffwatten
        
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
    [pass,stop] = magprops(~)
    minfo = measureinfo(this)
    p = propstoadd(~)
    specs = thisgetspecs(this)
end  % public methods 

end  % classdef

