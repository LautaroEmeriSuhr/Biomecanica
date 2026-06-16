classdef (Abstract) abstractcicspecs < fspecs.abstractspecwithfs
%ABSTRACTCICSPECS   Construct an ABSTRACTCICSPECS object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractcicspecs class
%   fspecs.abstractcicspecs extends fspecs.abstractspecwithfs.
%
%    fspecs.abstractcicspecs properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       Fpass - Property is of type 'posdouble user-defined'  
%       Astop - Property is of type 'posdouble user-defined'  
%
%    fspecs.abstractcicspecs methods:
%       designmethods -   Return the design methods for this specification object.
%       multisection - CICDESIGN   Shared design gateway for CICDECIM/CICINTERP.
%       props2normalize -   Properties to normalize frequency.
%       thisgetspecs -   Get specifications.


properties (AbortSet, SetObservable, GetObservable)
    %FPASS Property is of type 'posdouble user-defined' 
    Fpass = 0.5;
    %ASTOP Property is of type 'posdouble user-defined' 
    Astop = 60;
end


    methods 
        function set.Fpass(obj,value)
        % User-defined DataType = 'posdouble user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive'},'','Fpass');
        value = double(value);
        obj.Fpass = value;
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
    [d,isfull,type] = designmethods(this,varargin)
    [Hm,meas] = multisection(this,M,R)
    p = props2normalize(h)
    specs = thisgetspecs(this)
end  % public methods 

end  % classdef

