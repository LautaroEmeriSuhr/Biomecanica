classdef sbarbgrpdelay < fspecs.abstractsbarbphase
%SBARBGRPDELAY   Construct an SBARBGRPDELAY object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.sbarbgrpdelay class
%   fspecs.sbarbgrpdelay extends fspecs.abstractsbarbphase.
%
%    fspecs.sbarbgrpdelay properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       Frequencies - Property is of type 'double_vector user-defined'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       GroupDelay - Property is of type 'double_vector user-defined'  
%
%    fspecs.sbarbgrpdelay methods:
%       getdesignobj - Get the design object.
%       getmask - Get the mask.
%       normalizetime - Normalize time specifications.
%       propstoadd - Return the properties to add to the parent object.
%       this_setfrequencies - PreSet function for the 'frequencies' property.
%       thisgetspecs - Get the specs.
%       validatespecs -   Validate the specs


properties (AbortSet, SetObservable, GetObservable)
    %FILTERORDER Property is of type 'posint user-defined' 
    FilterOrder = 10;
    %GROUPDELAY Property is of type 'double_vector user-defined' 
    GroupDelay = [];
end

properties (AbortSet, SetObservable, GetObservable, Hidden)
    %NOMGRPDELAY Property is of type 'double_vector user-defined' (hidden)
    NomGrpDelay = [];
end


    methods  % constructor block
        function this = sbarbgrpdelay(varargin)
        %SBARBGRPDELAY Construct a SBARBGRPDELAY object.
        
        
        % this = fspecs.sbarbgrpdelay;
        % Default response
        F1 = [0 0.1 1];
        Gd = [2 3 1];
        
        this.Frequencies = F1;
        this.GroupDelay = Gd;
        
        respstr = 'Single-Band Arbitrary Group Delay';
        fstart = 1;
        fstop = 1;
        nargsnoFs = 4;
        fsconstructor(this,respstr,fstart,fstop,nargsnoFs,varargin{:});
        
        end  % sbarbgrpdelay
        
    end  % constructor block

    methods 
        function set.FilterOrder(obj,value)
        % User-defined DataType = 'posint user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive','integer'},'','FilterOrder');    
        obj.FilterOrder = value;
        end

        function set.GroupDelay(obj,value)
        % User-defined DataType = 'double_vector user-defined'
         validateattributes(value,{'double'},...
          {'vector'},'','GroupDelay');
        obj.GroupDelay = value;
        end

        function set.NomGrpDelay(obj,value)
        % User-defined DataType = 'double_vector user-defined'
         validateattributes(value,{'double'},...
          {'vector'},'','NomGrpDelay');
        obj.NomGrpDelay = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(~,str)
    [F,A] = getmask(~)
    normalizetime(this,oldFs,oldNormFreq)
    p = propstoadd(~)
    frequencies = this_setfrequencies(this,frequencies)
    specs = thisgetspecs(this)
    [N,F,Gd,nfpts] = validatespecs(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    description = describe(~)
end  % possibly private or hidden 

end  % classdef

