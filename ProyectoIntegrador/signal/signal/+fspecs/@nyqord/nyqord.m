classdef nyqord < fspecs.hbord
%NYQORD   Construct an NYQORD object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.nyqord class
%   fspecs.nyqord extends fspecs.hbord.
%
%    fspecs.nyqord properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       Band - Property is of type 'posint user-defined'  
%
%    fspecs.nyqord methods:
%       determineband -   Determine the band.
%       getband -   Return "Nyquist band".
%       getdesignobj -   Get the designobj.
%       measureinfo -   Return a structure of information for the measurements.
%       thisgetspecs -   Get the specs.


properties (AbortSet, SetObservable, GetObservable)
    %BAND Property is of type 'posint user-defined' 
    Band = 4;
end


    methods  % constructor block
        function this = nyqord(varargin)
        %NYQORD   Construct a NYQORD object.
        
        %   Author(s): J. Schickler
        
        % this = fspecs.nyqord;
        
        this.ResponseType = 'Nyquist with filter order';
        
        this.setspecs(varargin{:});
        
        
        end  % nyqord
        
    end  % constructor block

    methods 
        function set.Band(obj,value)
        % User-defined DataType = 'posint user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive','integer'},'','Band');    
        obj.Band = value;
        end

    end   % set and get functions 

    methods  % public methods
    L = determineband(this)
    band = getband(this)
    designobj = getdesignobj(this,str)
    minfo = measureinfo(this)
    specs = thisgetspecs(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    p = propstoadd(this)
    thisstaticresponse(this,hax)
end  % possibly private or hidden 

end  % classdef

