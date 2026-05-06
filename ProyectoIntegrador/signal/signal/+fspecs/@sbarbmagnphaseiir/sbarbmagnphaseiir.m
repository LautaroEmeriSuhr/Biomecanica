classdef sbarbmagnphaseiir < fspecs.abstractsbarbmagnphase
%SBARBMAGNPHASEIIR   Construct an SBARBMAGNPHASEIIR object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.sbarbmagnphaseiir class
%   fspecs.sbarbmagnphaseiir extends fspecs.abstractsbarbmagnphase.
%
%    fspecs.sbarbmagnphaseiir properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       Frequencies - Property is of type 'double_vector user-defined'  
%       FreqResponse - Property is of type 'double_vector user-defined'  
%       NumOrder - Property is of type 'posint user-defined'  
%       DenOrder - Property is of type 'posint user-defined'  
%
%    fspecs.sbarbmagnphaseiir methods:
%       getdesignobj -   Get the design object.
%       propstoadd -   Return the properties to add to the parent object.
%       validatespecs - Validate the specs


properties (AbortSet, SetObservable, GetObservable)
    %NUMORDER Property is of type 'posint user-defined' 
    NumOrder = 8;
    %DENORDER Property is of type 'posint user-defined' 
    DenOrder = 8;
end


    methods  % constructor block
        function this = sbarbmagnphaseiir(varargin)
        %SBARBMAGNPHASEIIR Construct a SBARBMAGNPHASEIIR object.
        
        
        % this = fspecs.sbarbmagnphaseiir;
        
        % Default response
        set_defaultresponse(this)
        
        respstr = 'Single-Band Arbitrary Magnitude and Phase IIR';
        fstart = 1;
        fstop = 1;
        nargsnoFs = 4;
        fsconstructor(this,respstr,fstart,fstop,nargsnoFs,varargin{:});
        
        
        end  % sbarbmagnphaseiir
        
    end  % constructor block

    methods 
        function set.NumOrder(obj,value)
        % User-defined DataType = 'posint user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive','integer'},'','NumOrder');    
        obj.NumOrder = value;
        end

        function set.DenOrder(obj,value)
        % User-defined DataType = 'posint user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive','integer'},'','DenOrder');    
        obj.DenOrder = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(~,str)
    p = propstoadd(~)
    [Nb,Na,F,A,P,nfpts] = validatespecs(this,~)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    description = describe(~)
end  % possibly private or hidden 

end  % classdef

