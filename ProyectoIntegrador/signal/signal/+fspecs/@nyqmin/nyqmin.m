classdef nyqmin < fspecs.hbmin
%NYQMIN   Construct an NYQMIN object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.nyqmin class
%   fspecs.nyqmin extends fspecs.hbmin.
%
%    fspecs.nyqmin properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       TransitionWidth - Property is of type 'posdouble user-defined'  
%       Astop - Property is of type 'posdouble user-defined'  
%       Band - Property is of type 'posint user-defined'  
%
%    fspecs.nyqmin methods:
%       firmultirate -   Design a multirate conforming to the 2L polyphase rule.
%       getband -   Return "Nyquist band".
%       getdesignobj -   Get the designobj.
%       measureinfo -   Return a structure of information for the measurements.
%       propstoadd -   Properties to be added to containers.
%       thisgetspecs -   Get the specs.


properties (AbortSet, SetObservable, GetObservable)
    %BAND Property is of type 'posint user-defined' 
    Band = 4;
end


    methods  % constructor block
        function this = nyqmin(varargin)
        %NYQMIN   Construct a NYQMIN object.
        
        %   Author(s): J. Schickler
        
        % this = fspecs.nyqmin;
        
        this.ResponseType = 'Minimum-order nyquist';
        
        this.setspecs(varargin{:});
        
        
        end  % nyqmin
        
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
    varargout = firmultirate(this,method,varargin)
    band = getband(this)
    designobj = getdesignobj(this,str)
    minfo = measureinfo(this)
    p = propstoadd(this)
    specs = thisgetspecs(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    thisstaticresponse(this,hax)
end  % possibly private or hidden 

end  % classdef

