classdef hphbmin < fspecs.hbmin
%HPHBMIN   Construct an HPHBMIN object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.hphbmin class
%   fspecs.hphbmin extends fspecs.hbmin.
%
%    fspecs.hphbmin properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       TransitionWidth - Property is of type 'posdouble user-defined'  
%       Astop - Property is of type 'posdouble user-defined'  
%
%    fspecs.hphbmin methods:
%       convert2specword - Convert minimum order spec to spec with order for
%       getdesignobj -   Get the designobj.
%       measureinfo -   Return a structure of information for the measurements.
%       thisgetspecs -   Get the specs.



    methods  % constructor block
        function h = hphbmin
        %HPHBMIN   Construct a HPHBMIN object.
        
        %   Author(s): R. Losada
        
        % h = fspecs.hphbmin;
        
        h.ResponseType = 'Minimum-order highpass halfband';
        
        end  % hphbmin
        
    end  % constructor block

    methods  % public methods
    [fspecsword,dm,dopts,Nstep] = convert2specword(this,cfmethod,N)
    designobj = getdesignobj(this,str)
    minfo = measureinfo(this)
    specs = thisgetspecs(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    flag = ishp(h)
    thisstaticresponse(this,hax)
end  % possibly private or hidden 

end  % classdef

