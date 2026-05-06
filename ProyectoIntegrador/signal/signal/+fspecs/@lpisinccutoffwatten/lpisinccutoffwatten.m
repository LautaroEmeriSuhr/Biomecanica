classdef lpisinccutoffwatten < fspecs.abstractlpcutoffwatten
%LPISINCCUTOFFWATTEN   Construct an LPISINCCUTOFFWATTEN object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.lpisinccutoffwatten class
%   fspecs.lpisinccutoffwatten extends fspecs.abstractlpcutoffwatten.
%
%    fspecs.lpisinccutoffwatten properties:
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
%    fspecs.lpisinccutoffwatten methods:
%       getdesignobj - Get the design object.
%       magprops - Return the magnitude properties.
%       measureinfo - Return a structure of information for the measurements.
%       propstoadd - Return the properties to add to the parent object.
%       setinvsincparamstunableflag - ISINVSINCPARAMSTUNABLE Return true if inv sinc parameters are tunable
%       thisgetspecs - Get the specs.


properties (AbortSet, SetObservable, GetObservable)
    %FREQUENCYFACTOR Property is of type 'double' 
    FrequencyFactor=0.5;
    %POWER Property is of type 'double' 
    Power=1;
    %CICRATECHANGEFACTOR Property is of type 'double' 
    CICRateChangeFactor=1;
end

properties (Access=protected, AbortSet, SetObservable, GetObservable, Hidden)
    %PRIVINVSINCPARAMSTUNABLEFLAG Property is of type 'bool' (hidden)
    privInvSincParamsTunableFlag = true;
end


    methods  % constructor block
        function this = lpisinccutoffwatten(varargin)
        %LPISINCCUTOFFWATTEN   Construct a LPISINCCUTOFFWATTEN object.
        
        %   Author(s): J. Schickler
        
        % this = fspecs.lpisinccutoffwatten;
        
        fstart = 2;
        fstop = 2;
        nargsnoFs = 6;
        fsconstructor(this,'Inverse-sinc lowpass',fstart,fstop,nargsnoFs,varargin{:});
        
        
        end  % lpisinccutoffwatten
        
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

        function set.privInvSincParamsTunableFlag(obj,value)
            % DataType = 'bool'
        validateattributes(value,{'logical','numeric'}, ...
          {'scalar','nonnan'},'','privInvSincParamsTunableFlag')
        value = logical(value); 
        obj.privInvSincParamsTunableFlag = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(this,str)
    [pass,stop] = magprops(~)
    minfo = measureinfo(this)
    p = propstoadd(~)
    setinvsincparamstunableflag(this,value)
    specs = thisgetspecs(this)
end  % public methods 

end  % classdef

