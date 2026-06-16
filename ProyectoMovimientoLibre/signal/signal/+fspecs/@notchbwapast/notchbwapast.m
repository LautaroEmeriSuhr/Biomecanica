classdef notchbwapast < fspecs.abstractpeaknotchbw
%NOTCHBWAPAST   Construct an NOTCHBWAPST object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.notchbwapast class
%   fspecs.notchbwapast extends fspecs.abstractpeaknotchbw.
%
%    fspecs.notchbwapast properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       F0 - Property is of type 'double'  
%       BW - Property is of type 'double'  
%       Apass - Property is of type 'double'  
%       Astop - Property is of type 'double'  
%
%    fspecs.notchbwapast methods:
%       getdesignobj -   Get the design object.


properties (AbortSet, SetObservable, GetObservable)
    %APASS Property is of type 'double' 
    Apass = 1;
    %ASTOP Property is of type 'double' 
    Astop = 60;
end


    methods  % constructor block
        function this = notchbwapast(varargin)
        %NOTCHBWAPAST   Construct a NOTCHBWAPAST object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.notchbwapast;
        
        this.ResponseType = 'Notching Filter';
        
        this.setspecs(varargin{:});
        
        
        
        end  % notchbwapast
        
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

