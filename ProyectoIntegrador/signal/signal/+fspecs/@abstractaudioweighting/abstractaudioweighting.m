classdef (Abstract) abstractaudioweighting < fspecs.abstractspecwithfs
%ABSTRACTAUDIOWEIGHTING   Construct an ABSTRACTAUDIOWEIGHTING object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractaudioweighting class
%   fspecs.abstractaudioweighting extends fspecs.abstractspecwithfs.
%
%    fspecs.abstractaudioweighting properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%
%    fspecs.abstractaudioweighting methods:
%       props2normalize -   Return the property name to normalize.
%       thisvalidate -   Validate the specs


properties (SetAccess=protected, AbortSet, SetObservable, GetObservable, Hidden)
    %ACTUALDESIGNFS Property is of type 'mxArray' (hidden)
    ActualDesignFs = [];
    %DEFAULTFS Property is of type 'mxArray' (hidden)
    DefaultFs = 48e3;
    %FMASK Property is of type 'mxArray' (hidden)
    Fmask = [];
    %AMASK Property is of type 'mxArray' (hidden)
    Amask = [];
    %FMASKINTERP Property is of type 'mxArray' (hidden)
    FmaskInterp = [];
    %AMASKINTERP Property is of type 'mxArray' (hidden)
    AmaskInterp = [];
end


    methods 
        function set.ActualDesignFs(obj,value)
        obj.ActualDesignFs = value;
        end

        function set.DefaultFs(obj,value)
        obj.DefaultFs = value;
        end

        function set.Fmask(obj,value)
        obj.Fmask = value;
        end

        function set.Amask(obj,value)
        obj.Amask = value;
        end

        function set.FmaskInterp(obj,value)
        obj.FmaskInterp = value;
        end

        function set.AmaskInterp(obj,value)
        obj.AmaskInterp = value;
        end

    end   % set and get functions 

    methods  % public methods
    p = props2normalize(this)
    [isvalid,errmsg,msgid] = thisvalidate(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    p = propstoadd(this,varargin)
    p = thispropstosync(this,p)
end  % possibly private or hidden 

end  % classdef

