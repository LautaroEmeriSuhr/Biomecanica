classdef hpisincmin < fspecs.lpmin
%HPISINCMIN   Construct an HPISINCMIN object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.hpisincmin class
%   fspecs.hpisincmin extends fspecs.lpmin.
%
%    fspecs.hpisincmin properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       Fpass - Property is of type 'posdouble user-defined'  
%       Fstop - Property is of type 'posdouble user-defined'  
%       Apass - Property is of type 'posdouble user-defined'  
%       Astop - Property is of type 'posdouble user-defined'  
%       FrequencyFactor - Property is of type 'double'  
%       Power - Property is of type 'double'  
%       CICRateChangeFactor - Property is of type 'double'  
%
%    fspecs.hpisincmin methods:
%       getdesignobj - Get the design object.
%       measureinfo - Return a structure of information for the measurements.
%       propstoadd - Return the properties to add to the parent object.
%       thisgetspecs - Get the specs.
%       thisvalidate - Check that this object is valid.


properties (AbortSet, SetObservable, GetObservable)
    %FREQUENCYFACTOR Property is of type 'double' 
    FrequencyFactor=0.5;
    %POWER Property is of type 'double' 
    Power=1;
    %CICRATECHANGEFACTOR Property is of type 'double' 
    CICRateChangeFactor=1;
end


    methods  % constructor block
        function this = hpisincmin(varargin)
        %HPISINCMIN Construct a HPISINCMIN object.
        
        
        % Override factory defaults inherited from lowpass
        if nargin < 1,
            varargin{1} = .45;
        end
        if nargin < 2,
            varargin{2} = .55;
        end
        
        % this = fspecs.hpisincmin;
        
        respstr = 'Inverse-sinc highpass';
        fstart = 1;
        fstop = 2;
        nargsnoFs = 4;
        fsconstructor(this,respstr,fstart,fstop,nargsnoFs,varargin{:});
        
        
        end  % hpisincmin
        
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
    [isvalid,errmsg,errid] = thisvalidate(h)
end  % public methods 

end  % classdef

