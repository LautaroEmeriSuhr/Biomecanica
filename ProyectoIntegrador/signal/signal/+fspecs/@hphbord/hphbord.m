classdef hphbord < fspecs.hbord
%HPHBORD   Construct an HPHBORD object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.hphbord class
%   fspecs.hphbord extends fspecs.hbord.
%
%    fspecs.hphbord properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%
%    fspecs.hphbord methods:
%       getdesignobj -   Get the designobj.
%       measureinfo -   Return a structure of information for the measurements.
%       thisgetspecs -   Get the specs.
%       thisstaticresponse - <short description>



    methods  % constructor block
        function h = hphbord
        %HPHBORD   Construct a HPHBORD object.
        
        %   Author(s): R. Losada
        
        % h = fspecs.hphbord;
        
        h.ResponseType = 'Highpass halfband with filter order';
        
        end  % hphbord
        
    end  % constructor block

    methods  % public methods
    designobj = getdesignobj(this,str)
    minfo = measureinfo(this)
    specs = thisgetspecs(this)
    thisstaticresponse(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    flag = ishp(h)
end  % possibly private or hidden 

end  % classdef

