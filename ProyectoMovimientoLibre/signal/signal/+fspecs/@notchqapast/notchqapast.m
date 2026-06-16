classdef notchqapast < fspecs.abstractpeaknotchq
%NOTCHQAPAST   Construct an NOTCHQAPAST object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.notchqapast class
%   fspecs.notchqapast extends fspecs.abstractpeaknotchq.
%
%    fspecs.notchqapast properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       F0 - Property is of type 'double'  
%       Q - Property is of type 'double'  
%       Apass - Property is of type 'double'  
%       Astop - Property is of type 'double'  
%
%    fspecs.notchqapast methods:
%       getdesignobj -   Get the design object.


properties (AbortSet, SetObservable, GetObservable)
    %APASS Property is of type 'double' 
    Apass = 1;
    %ASTOP Property is of type 'double' 
    Astop = 60;
end


    methods  % constructor block
        function this = notchqapast(varargin)
        %NOTCHQAPAST   Construct a NOTCHQAPAST object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.notchqapast;
        
        this.ResponseType = 'Notching Filter';
        
        this.setspecs(varargin{:});
        
        
        end  % notchqapast
        
    end  % constructor block

    methods 
        function set.Apass(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Apass')
        value = double(value);
        obj.Apass = value;
        end

        function set.Astop(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Astop')
        value = double(value);
        obj.Astop = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(this,str)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    [p,s] = magprops(this)
end  % possibly private or hidden 

end  % classdef

