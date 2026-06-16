classdef peakqap < fspecs.abstractpeaknotchq
%PEAKQAP   Construct an PEAKQAP object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.peakqap class
%   fspecs.peakqap extends fspecs.abstractpeaknotchq.
%
%    fspecs.peakqap properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       F0 - Property is of type 'double'  
%       Q - Property is of type 'double'  
%       Apass - Property is of type 'double'  
%
%    fspecs.peakqap methods:
%       getdesignobj -   Get the design object.


properties (AbortSet, SetObservable, GetObservable)
    %APASS Property is of type 'double' 
    Apass = 1;
end


    methods  % constructor block
        function this = peakqap(varargin)
        %PEAKQAP   Construct a PEAKQAP object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.peakqap;
        
        this.ResponseType = 'Peaking Filter';
        
        this.setspecs(varargin{:});
        
        end  % peakqap
        
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

