classdef hbordntw < fspecs.hbord
%HBORDNTW   Construct an HBORDNTW object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.hbordntw class
%   fspecs.hbordntw extends fspecs.hbord.
%
%    fspecs.hbordntw properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       TransitionWidth - Property is of type 'posdouble user-defined'  
%
%    fspecs.hbordntw methods:
%       firls -   Design a least-squares FIR filter.
%       getdesignobj -   Get the designobj.
%       measureinfo -   Return a structure of information for the measurements.
%       thisgetspecs -   Get the specs.


properties (AbortSet, SetObservable, GetObservable)
    %TRANSITIONWIDTH Property is of type 'posdouble user-defined' 
    TransitionWidth = .05;
end


    methods  % constructor block
        function this = hbordntw(varargin)
        %HBORDNTW   Construct a HBORDNTW object.
        
        %   Author(s): J. Schickler
        
        % this = fspecs.hbordntw;
        
        this.ResponseType = 'Halfband with filter order and transition width';
        
        this.setspecs(varargin{:});
        
        
        end  % hbordntw
        
    end  % constructor block

    methods 
        function set.TransitionWidth(obj,value)
        % User-defined DataType = 'posdouble user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive'},'','TransitionWidth');
        value = double(value);
        obj.TransitionWidth = value;
        end

    end   % set and get functions 

    methods  % public methods
    Hd = firls(this,varargin)
    designobj = getdesignobj(this,str)
    minfo = measureinfo(this)
    specs = thisgetspecs(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    p = props2normalize(h)
    thisstaticresponse(this,hax)
end  % possibly private or hidden 

end  % classdef

