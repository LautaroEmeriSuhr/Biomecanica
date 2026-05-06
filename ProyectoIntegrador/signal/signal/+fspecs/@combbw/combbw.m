classdef combbw < fspecs.abstractcombwithord
%COMBBW   Construct an COMBBW object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.combbw class
%   fspecs.combbw extends fspecs.abstractcombwithord.
%
%    fspecs.combbw properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       CombType - Property is of type 'CombTypeType enumeration: {'Peak','Notch'}'  
%       PeakNotchFrequencies - Property is of type 'double_vector user-defined'  
%       BW - Property is of type 'double'  
%
%    fspecs.combbw methods:
%       describe -   Describe the object.
%       getdesignobj -   Get the design object.
%       props2normalize -   Return the property name to normalize.
%       propstoadd -   Return the properties to add to the parent object.


properties (AbortSet, SetObservable, GetObservable)
    %BW Property is of type 'double' 
    BW = 0.0125;
end


    methods  % constructor block
        function this = combbw(varargin)
        %COMBBW   Construct a COMBBW object.
        
        
        % this = fspecs.combbw;
        
        this.ResponseType = 'Comb Filter';
        
        this.setspecs(varargin{:});
        
        
        end  % combbw
        
    end  % constructor block

    methods 
        function set.BW(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','BW')
        value = double(value);
        obj.BW = value;
        end

    end   % set and get functions 

    methods  % public methods
    p = describe(this)
    designobj = getdesignobj(this,str)
    p = props2normalize(this)
    p = propstoadd(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    specs = thisgetspecs(this)
end  % possibly private or hidden 

end  % classdef

