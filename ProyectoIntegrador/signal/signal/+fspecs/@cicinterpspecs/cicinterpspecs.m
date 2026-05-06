classdef cicinterpspecs < fspecs.abstractcicspecs
%CICINTERPSPECS   Construct an CICINTERPSPECS object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.cicinterpspecs class
%   fspecs.cicinterpspecs extends fspecs.abstractcicspecs.
%
%    fspecs.cicinterpspecs properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       Fpass - Property is of type 'posdouble user-defined'  
%       Astop - Property is of type 'posdouble user-defined'  
%
%    fspecs.cicinterpspecs methods:
%       describe -   Describe the object.
%       getdesignobj -   Get the designobj.
%       magprops -   Return the magnitude properties.
%       props2normalize -   Properties to normalize frequency.



    methods  % constructor block
        function this = cicinterpspecs
        %CICINTERPSPECS   Construct a CICINTERPSPECS object.
        
        %   Author(s): P. Costa
        
        % this = fspecs.cicinterpspecs;
        
        this.ResponseType = 'CIC Interpolator';
        
        % Set the default normalized passband frequency to a small value which will
        % result in a design of N = 2
        this.Fpass = .05;
        
        
        end  % cicinterpspecs
        
    end  % constructor block

    methods  % public methods
    description = describe(this)
    designobj = getdesignobj(this,str)
    [p,s] = magprops(this)
    p = props2normalize(h)
end  % public methods 

end  % classdef

