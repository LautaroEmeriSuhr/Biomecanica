classdef multibandarbgrpdelay < fspecs.abstractmultiband
%MULTIBANDARBGRPDELAY   Construct an MULTIBANDARBGRPDELAY object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.multibandarbgrpdelay class
%   fspecs.multibandarbgrpdelay extends fspecs.abstractmultiband.
%
%    fspecs.multibandarbgrpdelay properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       NBands - Property is of type 'posint user-defined'  
%       B1Frequencies - Property is of type 'double_vector user-defined'  
%       B2Frequencies - Property is of type 'double_vector user-defined'  
%       B3Frequencies - Property is of type 'double_vector user-defined'  
%       B4Frequencies - Property is of type 'double_vector user-defined'  
%       B5Frequencies - Property is of type 'double_vector user-defined'  
%       B6Frequencies - Property is of type 'double_vector user-defined'  
%       B7Frequencies - Property is of type 'double_vector user-defined'  
%       B8Frequencies - Property is of type 'double_vector user-defined'  
%       B9Frequencies - Property is of type 'double_vector user-defined'  
%       B10Frequencies - Property is of type 'double_vector user-defined'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       B1GroupDelay - Property is of type 'double_vector user-defined'  
%       B2GroupDelay - Property is of type 'double_vector user-defined'  
%       B3GroupDelay - Property is of type 'double_vector user-defined'  
%       B4GroupDelay - Property is of type 'double_vector user-defined'  
%       B5GroupDelay - Property is of type 'double_vector user-defined'  
%       B6GroupDelay - Property is of type 'double_vector user-defined'  
%       B7GroupDelay - Property is of type 'double_vector user-defined'  
%       B8GroupDelay - Property is of type 'double_vector user-defined'  
%       B9GroupDelay - Property is of type 'double_vector user-defined'  
%       B10GroupDelay - Property is of type 'double_vector user-defined'  
%
%    fspecs.multibandarbgrpdelay methods:
%       getdesignobj -   Get the design object.
%       getmask - Get the mask.
%       getspecs - Get the specs.
%       normalizetime - Normalize time specifications.
%       propstoadd - Return the properties to add to the parent object.
%       set_groupdelay - PreSet function for the 'GroupDelay' property.
%       validatespecs -   Validate the specs


properties (AbortSet, SetObservable, GetObservable)
    %FILTERORDER Property is of type 'posint user-defined' 
    FilterOrder = 10;
    %B1GROUPDELAY Property is of type 'double_vector user-defined' 
    B1GroupDelay = [];
    %B2GROUPDELAY Property is of type 'double_vector user-defined' 
    B2GroupDelay = [];
    %B3GROUPDELAY Property is of type 'double_vector user-defined' 
    B3GroupDelay = [ 0, 0 ];
    %B4GROUPDELAY Property is of type 'double_vector user-defined' 
    B4GroupDelay = [ 0, 0 ];
    %B5GROUPDELAY Property is of type 'double_vector user-defined' 
    B5GroupDelay = [ 0, 0 ];
    %B6GROUPDELAY Property is of type 'double_vector user-defined' 
    B6GroupDelay = [ 0, 0 ];
    %B7GROUPDELAY Property is of type 'double_vector user-defined' 
    B7GroupDelay = [ 0, 0 ];
    %B8GROUPDELAY Property is of type 'double_vector user-defined' 
    B8GroupDelay = [ 0, 0 ];
    %B9GROUPDELAY Property is of type 'double_vector user-defined' 
    B9GroupDelay = [ 0, 0 ];
    %B10GROUPDELAY Property is of type 'double_vector user-defined' 
    B10GroupDelay = [ 0, 0 ];
end

properties (AbortSet, SetObservable, GetObservable, Hidden)
    %NOMGRPDELAY Property is of type 'double_vector user-defined' (hidden)
    NomGrpDelay = [];
end


    methods  % constructor block
        function this = multibandarbgrpdelay(varargin)
        %MULTIBANDARBGRPDELAY Construct a MULTIBANDARBGRPDELAY object.
        
        
        % this = fspecs.multibandarbgrpdelay;
        this.B1Frequencies = 0.0:0.01:0.3;
        this.B2Frequencies = 0.8:0.01:1;
        this.B1GroupDelay = 9.41-[...
          0.2682    0.2686    0.2698    0.2718    0.2746    0.2784    0.2831...
          0.2888    0.2957    0.3039    0.3135    0.3247    0.3379    0.3532...
          0.3713    0.3925    0.4177    0.4477    0.4839    0.5279    0.5823...
          0.6505    0.7378    0.8522    1.0063    1.2210    1.5333    2.0117...
          2.7937    4.1766    6.8314];
        
        this.B2GroupDelay = 9.41-[...
          9.4026    4.9336    3.0242    2.0786    1.5488    1.2233    1.0091...
          0.8606    0.7533    0.6734    0.6125    0.5652    0.5281    0.4988...
          0.4757    0.4575    0.4436    0.4332    0.4261    0.4219    0.4206];
        
        respstr = 'Multi-Band Arbitrary Group Delay';
        fstart = 1;
        fstop = 1;
        nargsnoFs = 2;
        fsconstructor(this,respstr,fstart,fstop,nargsnoFs,varargin{:});
        
        end  % multibandarbgrpdelay
        
    end  % constructor block

    methods 
        function set.FilterOrder(obj,value)
        % User-defined DataType = 'posint user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive','integer'},'','FilterOrder');    
        obj.FilterOrder = value;
        end

        function set.B1GroupDelay(obj,value)
        % User-defined DataType = 'double_vector user-defined'
         validateattributes(value,{'double'},...
          {'vector'},'','B1GroupDelay');
        obj.B1GroupDelay = set_groupdelay(obj,value);
        end

        function set.B2GroupDelay(obj,value)
        % User-defined DataType = 'double_vector user-defined'
           validateattributes(value,{'double'},...
          {'vector'},'','B2GroupDelay');
        obj.B2GroupDelay = set_groupdelay(obj,value);
        end

        function set.B3GroupDelay(obj,value)
        % User-defined DataType = 'double_vector user-defined'
           validateattributes(value,{'double'},...
          {'vector'},'','B3GroupDelay');
        obj.B3GroupDelay = set_groupdelay(obj,value);
        end

        function set.B4GroupDelay(obj,value)
        % User-defined DataType = 'double_vector user-defined'
           validateattributes(value,{'double'},...
          {'vector'},'','B4GroupDelay');
        obj.B4GroupDelay = set_groupdelay(obj,value);
        end

        function set.B5GroupDelay(obj,value)
        % User-defined DataType = 'double_vector user-defined'
          validateattributes(value,{'double'},...
          {'vector'},'','B5GroupDelay');
        obj.B5GroupDelay = set_groupdelay(obj,value);
        end

        function set.B6GroupDelay(obj,value)
        % User-defined DataType = 'double_vector user-defined'
           validateattributes(value,{'double'},...
          {'vector'},'','B6GroupDelay');
        obj.B6GroupDelay = set_groupdelay(obj,value);
        end

        function set.B7GroupDelay(obj,value)
        % User-defined DataType = 'double_vector user-defined'
           validateattributes(value,{'double'},...
          {'vector'},'','B7GroupDelay');
        obj.B7GroupDelay = set_groupdelay(obj,value);
        end

        function set.B8GroupDelay(obj,value)
        % User-defined DataType = 'double_vector user-defined'
           validateattributes(value,{'double'},...
          {'vector'},'','B8GroupDelay');
        obj.B8GroupDelay = set_groupdelay(obj,value);
        end

        function set.B9GroupDelay(obj,value)
        % User-defined DataType = 'double_vector user-defined'
           validateattributes(value,{'double'},...
          {'vector'},'','B9GroupDelay');
        obj.B9GroupDelay = set_groupdelay(obj,value);
        end

        function set.B10GroupDelay(obj,value)
        % User-defined DataType = 'double_vector user-defined'
           validateattributes(value,{'double'},...
          {'vector'},'','B10GroupDelay');
        obj.B10GroupDelay = set_groupdelay(obj,value);
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
    [F,Gd] = getmask(~)
    specs = getspecs(~)
    normalizetime(this,oldFs,oldNormFreq)
    p = propstoadd(this)
    groupDelay = set_groupdelay(~,groupDelay)
    [N,F,E,Gd,nfpts] = validatespecs(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    description = describe(~)
    minfo = measureinfo(this)
    pname = orderprop(~)
end  % possibly private or hidden 

end  % classdef

