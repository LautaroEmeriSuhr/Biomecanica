classdef notchbwast < fspecs.abstractpeaknotchbw
%NOTCHWAST   Construct an NOTCHWAST object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.notchbwast class
%   fspecs.notchbwast extends fspecs.abstractpeaknotchbw.
%
%    fspecs.notchbwast properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       F0 - Property is of type 'double'  
%       BW - Property is of type 'double'  
%       Astop - Property is of type 'double'  
%
%    fspecs.notchbwast methods:
%       getdesignobj -   Get the design object.


properties (AbortSet, SetObservable, GetObservable)
    %ASTOP Property is of type 'double' 
    Astop = 60;
end


    methods  % constructor block
        function this = notchbwast(varargin)
        %NOTCHBWAST   Construct a NOTCHBWAST object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.notchbwast;
        
        this.ResponseType = 'Notching Filter';
        
        this.setspecs(varargin{:});
        
        
        end  % notchbwast
        
    end  % constructor block

    methods 
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

