classdef hbord < fspecs.abstractspecwithordnfs
%HBORD   Construct an HBORD object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.hbord class
%   fspecs.hbord extends fspecs.abstractspecwithordnfs.
%
%    fspecs.hbord properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%
%    fspecs.hbord methods:
%       butter -   Butterworth digital filter design.
%       ellip - Elliptic digital filter design.
%       equiripple -   Design an equiripple filter.
%       getband -   Return "Nyquist band".
%       getdesignobj -   Get the designobj.
%       iirlinphase -   IIR quasi linear phase digital filter design.
%       kaiserwin -   Design an FIR filter using the Kaiser window.
%       measureinfo -   Return a structure of information for the measurements.
%       thisgetspecs -   Get the specs.
%       window - Design a window filter.



    methods  % constructor block
        function this = hbord(varargin)
        %HBORD   Construct a HBORD object.
        
        %   Author(s): J. Schickler
        
        % this = fspecs.hbord;
        
        this.ResponseType = 'Halfband with filter order';
        
        this.setspecs(varargin{:});
        
        
        end  % hbord
        
    end  % constructor block

    methods  % public methods
    Hd = butter(this,varargin)
    Hd = ellip(this,varargin)
    Hd = equiripple(this,varargin)
    band = getband(this)
    designobj = getdesignobj(this,str)
    Hd = iirlinphase(this,varargin)
    Hd = kaiserwin(this,varargin)
    minfo = measureinfo(this)
    specs = thisgetspecs(this)
    Hd = window(this,win,varargin)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    flag = ishp(h)
    p = props2normalize(this)
    thisstaticresponse(this,hax)
end  % possibly private or hidden 

end  % classdef

