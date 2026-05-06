classdef nyqordntw < fspecs.hbordntw
%NYQORDNTW   Construct an NYQORDNTW object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.nyqordntw class
%   fspecs.nyqordntw extends fspecs.hbordntw.
%
%    fspecs.nyqordntw properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       TransitionWidth - Property is of type 'posdouble user-defined'  
%       Band - Property is of type 'posint user-defined'  
%
%    fspecs.nyqordntw methods:
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
        function this = nyqordntw(varargin)
        %NYQORDNTW   Construct a NYQORDNTW object.
        
        %   Author(s): J. Schickler
        
        % this = fspecs.nyqordntw;
        
        this.ResponseType = 'Nyquist with filter order and transition width';
        
        this.setspecs(varargin{:});
        
        
        end  % nyqordntw
        
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

