classdef octavewordncenterfreq < fspecs.abstractspecwithordnfs
%OCTAVEWORDNCENTERFREQ   Construct an OCTAVEWORDNCENTERFREQ object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.octavewordncenterfreq class
%   fspecs.octavewordncenterfreq extends fspecs.abstractspecwithordnfs.
%
%    fspecs.octavewordncenterfreq properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       F0 - Property is of type 'posdouble user-defined'  
%       privBandsPerOctave - Property is of type 'posint user-defined'  
%
%    fspecs.octavewordncenterfreq methods:
%       describe -   Describe the object.
%       getdesignobj -   Get the design object.
%       getvalidcenterfrequencies -   Get the validcenterfrequencies.
%       props2normalize -   Return the property name to normalize.
%       thisvalidate - VALIDATE   Validate the specs


properties (AbortSet, SetObservable, GetObservable)
    %F0 Property is of type 'posdouble user-defined' 
    F0 = 1/24;
    %PRIVBANDSPEROCTAVE Property is of type 'posint user-defined' 
    privBandsPerOctave = 1;
end


    methods  % constructor block
        function this = octavewordncenterfreq(varargin)
        %OCTAVEWORDNCENTERFREQ   Construct an OCTAVEWORDNCENTERFREQ object.
        
        %   Author(s): V. Pellissier
        
        % this = fspecs.octavewordncenterfreq;
        this.FilterOrder = 6;
        if nargin>0,
            this.FilterOrder = varargin{1};
        end
        if nargin>1,
            this.F0 = varargin{2};
        end
        
        end  % octavewordncenterfreq
        
    end  % constructor block

    methods 
        function set.F0(obj,value)
        % User-defined DataType = 'posdouble user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive'},'','F0');
        value = double(value);
        obj.F0 = value;
        end

        function set.privBandsPerOctave(obj,value)
        % User-defined DataType = 'posint user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive','integer'},'','privBandsPerOctave');    
        obj.privBandsPerOctave = value;
        end

    end   % set and get functions 

    methods  % public methods
    description = describe(this)
    designobj = getdesignobj(this,str)
    validcenterfrequencies = getvalidcenterfrequencies(this)
    p = props2normalize(this)
    [isvalid,errmsg,msgid] = thisvalidate(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    p = propstoadd(this,varargin)
    p = thisprops2add(this,varargin)
end  % possibly private or hidden 

end  % classdef

