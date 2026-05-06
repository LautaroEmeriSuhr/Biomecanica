classdef sbarbmagnphase < fspecs.abstractsbarbmagnphase
%SBARBMAGNPHASE   Construct an SBARBMAGNPHASE object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.sbarbmagnphase class
%   fspecs.sbarbmagnphase extends fspecs.abstractsbarbmagnphase.
%
%    fspecs.sbarbmagnphase properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       Frequencies - Property is of type 'double_vector user-defined'  
%       FreqResponse - Property is of type 'double_vector user-defined'  
%       FilterOrder - Property is of type 'posint user-defined'  
%
%    fspecs.sbarbmagnphase methods:
%       getdesignobj - Get the design object.
%       propstoadd - Return the properties to add to the parent object.
%       validatespecs -   Validate the specs


properties (AbortSet, SetObservable, GetObservable)
    %FILTERORDER Property is of type 'posint user-defined' 
    FilterOrder = 30;
end


    methods  % constructor block
        function this = sbarbmagnphase(varargin)
        %SBARBMAGNPHASE Construct a SBARBMAGNPHASE object.
        
        
        % this = fspecs.sbarbmagnphase;
        
        % Default response
        set_defaultresponse(this)
        
        respstr = 'Single-Band Arbitrary Magnitude and Phase';
        fstart = 1;
        fstop = 1;
        nargsnoFs = 4;
        fsconstructor(this,respstr,fstart,fstop,nargsnoFs,varargin{:});
        
        end  % sbarbmagnphase
        
    end  % constructor block

    methods 
        function set.FilterOrder(obj,value)
        % User-defined DataType = 'posint user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive','integer'},'','FilterOrder');    
        obj.FilterOrder = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(~,str)
    p = propstoadd(~)
    [N,F,A,P,nfpts] = validatespecs(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    description = describe(~)
end  % possibly private or hidden 

end  % classdef

