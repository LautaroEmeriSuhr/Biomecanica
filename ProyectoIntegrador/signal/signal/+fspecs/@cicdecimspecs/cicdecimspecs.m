classdef cicdecimspecs < fspecs.abstractcicspecs
%CICDECIMSPECS   Construct an CICDECIMSPECS object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.cicdecimspecs class
%   fspecs.cicdecimspecs extends fspecs.abstractcicspecs.
%
%    fspecs.cicdecimspecs properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       Fpass - Property is of type 'posdouble user-defined'  
%       Astop - Property is of type 'posdouble user-defined'  
%
%    fspecs.cicdecimspecs methods:
%       describe -   Describe the object.
%       getdesignobj -   Get the designobj.
%       magprops -   Return the magnitude properties.
%       props2normalize -   Properties to normalize frequency.



    methods  % constructor block
        function this = cicdecimspecs
        %CICDECIMSPECS   Construct a CICDECIMSPECS object.
        
        %   Author(s): P. Costa
        
        % this = fspecs.cicdecimspecs;
        
        this.ResponseType = 'CIC Decimator';
        
        % Set the default normalized passband frequency to a small value which will
        % result in a design of N = 2
        this.Fpass = .01;
        
        
        end  % cicdecimspecs
        
    end  % constructor block

    methods  % public methods
    description = describe(this)
    designobj = getdesignobj(this,str)
    [p,s] = magprops(this)
    p = props2normalize(h)
end  % public methods 

end  % classdef

