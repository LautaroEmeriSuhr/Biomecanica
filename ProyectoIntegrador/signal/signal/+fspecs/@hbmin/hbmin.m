classdef hbmin < fspecs.abstractspecwithfs
%HBMIN   Construct an HBMIN object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.hbmin class
%   fspecs.hbmin extends fspecs.abstractspecwithfs.
%
%    fspecs.hbmin properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       TransitionWidth - Property is of type 'posdouble user-defined'  
%       Astop - Property is of type 'posdouble user-defined'  
%
%    fspecs.hbmin methods:
%       butter -   Butterworth digital filter design.
%       ellip - Elliptic digital filter design.
%       equiripple -   Design an equiripple filter.
%       firmultirate -   Design a multirate conforming to the 2L polyphase rule.
%       getband -   Return "Nyquist band".
%       getdesignobj -   Get the designobj.
%       iirlinphase -   IIR quasi linear phase digital filter design.
%       isdeltaalphavalid - True if the object is deltaalphavalid
%       isspecmet - True if the object spec is met
%       kaiserwin -  Design an FIR filter using the Kaiser window.
%       magprops -   Return the magnitude properties.
%       measureinfo -   Return a structure of information for the measurements.


properties (AbortSet, SetObservable, GetObservable)
    %TRANSITIONWIDTH Property is of type 'posdouble user-defined' 
    TransitionWidth = .1;
    %ASTOP Property is of type 'posdouble user-defined' 
    Astop = 80;
end


    methods  % constructor block
        function this = hbmin(varargin)
        %HBMIN   Construct a HBMIN object.
        
        %   Author(s): J. Schickler
        
        % this = fspecs.hbmin;
        
        this.ResponseType = 'Minimum-order halfband';
        
        this.setspecs(varargin{:});
        
        
        end  % hbmin
        
    end  % constructor block

    methods 
        function set.TransitionWidth(obj,value)
        % User-defined DataType = 'posdouble user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive'},'','TransitionWidth');
        value = double(value);
        obj.TransitionWidth = value;
        end

        function set.Astop(obj,value)
        % User-defined DataType = 'posdouble user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive'},'','Astop');
        value = double(value);
        obj.Astop = value;
        end

    end   % set and get functions 

    methods  % public methods
    Hd = butter(this,varargin)
    Hd = ellip(this,varargin)
    Hd = equiripple(this,varargin)
    varargout = firmultirate(this,method,varargin)
    band = getband(this)
    designobj = getdesignobj(this,str)
    Hd = iirlinphase(this,varargin)
    alphaflag = isdeltaalphavalid(this,originalalpha,newalpha)
    SpecMetFlag = isspecmet(this,b)
    Hd = kaiserwin(this,varargin)
    [p,s] = magprops(this)
    minfo = measureinfo(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    flag = ishp(h)
    p = props2normalize(this)
    specs = thisgetspecs(this)
    thisstaticresponse(this,hax)
end  % possibly private or hidden 

end  % classdef

