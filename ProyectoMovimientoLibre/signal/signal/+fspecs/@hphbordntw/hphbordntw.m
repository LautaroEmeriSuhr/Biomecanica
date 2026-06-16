classdef hphbordntw < fspecs.hbordntw
%HPHBORDNTW   Construct an HPHBORDNTW object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.hphbordntw class
%   fspecs.hphbordntw extends fspecs.hbordntw.
%
%    fspecs.hphbordntw properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       TransitionWidth - Property is of type 'posdouble user-defined'  
%
%    fspecs.hphbordntw methods:
%       getdesignobj -   Get the designobj.
%       measureinfo -   Return a structure of information for the measurements.
%       thisgetspecs -   Get the specs.



    methods  % constructor block
        function h = hphbordntw
        %HPHBORDNTW   Construct a HPHBORDNTW object.
        
        %   Author(s): R. Losada
        
        % h = fspecs.hphbordntw;
        
        h.ResponseType = 'Highpass halfband with filter order and transition width';
        
        end  % hphbordntw
        
    end  % constructor block

    methods  % public methods
    designobj = getdesignobj(this,str)
    minfo = measureinfo(this)
    specs = thisgetspecs(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    flag = ishp(h)
    thisstaticresponse(this,hax)
end  % possibly private or hidden 

end  % classdef

