classdef notchqap < fspecs.abstractpeaknotchq
%NOTCHQAP   Construct an NOTCHQAP object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.notchqap class
%   fspecs.notchqap extends fspecs.abstractpeaknotchq.
%
%    fspecs.notchqap properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       F0 - Property is of type 'double'  
%       Q - Property is of type 'double'  
%       Apass - Property is of type 'double'  
%
%    fspecs.notchqap methods:
%       getdesignobj -   Get the design object.


properties (AbortSet, SetObservable, GetObservable)
    %APASS Property is of type 'double' 
    Apass = 1;
end


    methods  % constructor block
        function this = notchqap(varargin)
        %NOTCHQAP   Construct a NOTCHQAP object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.notchqap;
        
        this.ResponseType = 'Notching Filter';
        
        this.setspecs(varargin{:});
        
        
        
        end  % notchqap
        
    end  % constructor block

    methods 
        function set.Apass(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Apass')
        value = double(value);
        obj.Apass = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(this,str)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    [p,s] = magprops(this)
end  % possibly private or hidden 

end  % classdef

