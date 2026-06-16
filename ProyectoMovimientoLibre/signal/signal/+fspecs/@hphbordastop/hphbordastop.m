classdef hphbordastop < fspecs.hbordastop
%HPHBORDASTOP   Construct an HPHBORDASTOP object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.hphbordastop class
%   fspecs.hphbordastop extends fspecs.hbordastop.
%
%    fspecs.hphbordastop properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       Astop - Property is of type 'posdouble user-defined'  
%
%    fspecs.hphbordastop methods:
%       getdesignobj -   Get the designobj.
%       thisgetspecs -   Get the specs.



    methods  % constructor block
        function h = hphbordastop
        %HPHBORDASTOP   Construct a HPHBORDASTOP object.
        
        %   Author(s): R. Losada
        
        % h = fspecs.hphbordastop;
        
        h.ResponseType = 'Highpass halfband with filter order and stopband attenuation';
        
        end  % hphbordastop
        
    end  % constructor block

    methods  % public methods
    designobj = getdesignobj(this,str)
    specs = thisgetspecs(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    flag = ishp(h)
    thisstaticresponse(this,hax)
end  % possibly private or hidden 

end  % classdef

