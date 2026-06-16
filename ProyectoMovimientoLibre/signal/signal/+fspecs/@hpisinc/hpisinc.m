classdef hpisinc < fspecs.abstractlp
%HPISINC   Construct an HPISINC object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.hpisinc class
%   fspecs.hpisinc extends fspecs.abstractlp.
%
%    fspecs.hpisinc properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       Fpass - Property is of type 'posdouble user-defined'  
%       Fstop - Property is of type 'posdouble user-defined'  
%       FrequencyFactor - Property is of type 'double'  
%       Power - Property is of type 'double'  
%       CICRateChangeFactor - Property is of type 'double'  
%
%    fspecs.hpisinc methods:
%       getdesignobj - Get the design object.
%       measureinfo - Return a structure of information for the measurements.
%       propstoadd - Return the properties to add to the parent object.
%       thisgetspecs - Get the specs.


properties (AbortSet, SetObservable, GetObservable)
    %FREQUENCYFACTOR Property is of type 'double' 
    FrequencyFactor=0.5
    %POWER Property is of type 'double' 
    Power=1;
    %CICRATECHANGEFACTOR Property is of type 'double' 
    CICRateChangeFactor=1;
end


    methods  % constructor block
        function this = hpisinc(varargin)
        %HPISINC Construct a HPISINC object.
        
        
        % this = fspecs.hpisinc;
        
        % Override factory defaults inherited from lowpass
        if nargin < 3
            varargin{3} = .55;
            if nargin < 2
                varargin{2} = .45;
                if nargin < 1
                    varargin{1} = 10;
                end
            end
        end
        
        respstr = 'Inverse-sinc Highpass';
        fstart = 2;
        fstop = 3;
        nargsnoFs = 5;
        fsconstructor(this,respstr,fstart,fstop,nargsnoFs,varargin{:});
        
        
        end  % hpisinc
        
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


    methods (Hidden) % possibly private or hidden
    [isvalid,errmsg,errid] = thisvalidate(h)
end  % possibly private or hidden 

end  % classdef

