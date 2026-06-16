classdef combq < fspecs.abstractcombwithord
%COMBQ   Construct an COMBQ object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.combq class
%   fspecs.combq extends fspecs.abstractcombwithord.
%
%    fspecs.combq properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       CombType - Property is of type 'CombTypeType enumeration: {'Peak','Notch'}'  
%       PeakNotchFrequencies - Property is of type 'double_vector user-defined'  
%       Q - Property is of type 'double'  
%
%    fspecs.combq methods:
%       getdesignobj -   Get the design object.
%       props2normalize -   Return the property name to normalize.
%       propstoadd -   Return the properties to add to the parent object.
%       setspecs -   Set the specifications


properties (AbortSet, SetObservable, GetObservable)
    %Q Property is of type 'double' 
    Q = 16;
end


    methods  % constructor block
        function this = combq(varargin)
        %COMBBW   Construct a COMBQ object.
        
        
        % this = fspecs.combq;
        
        this.ResponseType = 'Comb Filter';
        
        this.setspecs(varargin{:});
        
        
        end  % combq
        
    end  % constructor block

    methods 
        function set.Q(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Q')
        value = double(value);
        obj.Q = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(this,str)
    p = props2normalize(this)
    p = propstoadd(this)
    setspecs(this,varargin)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    specs = thisgetspecs(this)
end  % possibly private or hidden 

end  % classdef

