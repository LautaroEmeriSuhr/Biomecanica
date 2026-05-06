classdef peakbwast < fspecs.abstractpeaknotchbw
%PEAKBWAST   Construct an PEAKBWAST object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.peakbwast class
%   fspecs.peakbwast extends fspecs.abstractpeaknotchbw.
%
%    fspecs.peakbwast properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       F0 - Property is of type 'double'  
%       BW - Property is of type 'double'  
%       Astop - Property is of type 'double'  
%
%    fspecs.peakbwast methods:
%       getdesignobj -   Get the design object.


properties (AbortSet, SetObservable, GetObservable)
    %ASTOP Property is of type 'double' 
    Astop = 60;
end


    methods  % constructor block
        function this = peakbwast(varargin)
        %PEAKBWAST   Construct a PEAKBWAST object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.peakbwast;
        
        this.ResponseType = 'Peaking Filter';
        
        this.setspecs(varargin{:});
        
        
        end  % peakbwast
        
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

