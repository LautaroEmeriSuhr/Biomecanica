classdef hbordastop < fspecs.hbord
%HBORDASTOP   Construct an HBORDASTOP object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.hbordastop class
%   fspecs.hbordastop extends fspecs.hbord.
%
%    fspecs.hbordastop properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       Astop - Property is of type 'posdouble user-defined'  
%
%    fspecs.hbordastop methods:
%       getdesignobj -   Get the designobj.
%       isdeltaalphavalid - True if the object is deltaalphavalid
%       isspecmet - True if the object spec is met
%       magprops -   Return the magnitude properties.
%       measureinfo -   Return a structure of information for the measurements.
%       thisgetspecs -   Get the specs.


properties (AbortSet, SetObservable, GetObservable)
    %ASTOP Property is of type 'posdouble user-defined' 
    Astop = 80;
end


    methods  % constructor block
        function this = hbordastop(varargin)
        %HBORDASTOP   Construct a HBORDASTOP object.
        
        %   Author(s): J. Schickler
        
        % this = fspecs.hbordastop;
        
        this.ResponseType = 'Halfband with filter order and stopband attenuation';
        
        this.setspecs(varargin{:});
        
        
        end  % hbordastop
        
    end  % constructor block

    methods 
        function set.Astop(obj,value)
        % User-defined DataType = 'posdouble user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive'},'','Astop');
        value = double(value);
        obj.Astop = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(this,str)
    alphaflag = isdeltaalphavalid(this,originalalpha,newalpha)
    SpecMetFlag = isspecmet(this,b)
    [p,s] = magprops(this)
    minfo = measureinfo(this)
    specs = thisgetspecs(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    p = props2normalize(this)
    thisstaticresponse(this,hax)
end  % possibly private or hidden 

end  % classdef

