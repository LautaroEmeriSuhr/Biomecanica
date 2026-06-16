classdef multibandmagnphase < fspecs.abstractmultiband
%MULTIBANDMAGNPHASE   Construct an MULTIBANDMAGNPHASE object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.multibandmagnphase class
%   fspecs.multibandmagnphase extends fspecs.abstractmultiband.
%
%    fspecs.multibandmagnphase properties:
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
%       B1FreqResponse - Property is of type 'double_vector user-defined'  
%       B2FreqResponse - Property is of type 'double_vector user-defined'  
%       B3FreqResponse - Property is of type 'double_vector user-defined'  
%       B4FreqResponse - Property is of type 'double_vector user-defined'  
%       B5FreqResponse - Property is of type 'double_vector user-defined'  
%       B6FreqResponse - Property is of type 'double_vector user-defined'  
%       B7FreqResponse - Property is of type 'double_vector user-defined'  
%       B8FreqResponse - Property is of type 'double_vector user-defined'  
%       B9FreqResponse - Property is of type 'double_vector user-defined'  
%       B10FreqResponse - Property is of type 'double_vector user-defined'  
%
%    fspecs.multibandmagnphase methods:
%       getdesignobj -   Get the design object.
%       getmask -   Get the mask.
%       getspecs -   Get the specs.
%       propstoadd -   Return the properties to add to the parent object.
%       set_freqresp -   PreSet function for the 'freqresp' property.
%       validatespecs - Validate the specs


properties (AbortSet, SetObservable, GetObservable)
    %FILTERORDER Property is of type 'posint user-defined' 
    FilterOrder = 30;
    %B1FREQRESPONSE Property is of type 'double_vector user-defined' 
    B1FreqResponse = [.5 2.3 1 1 .001 .001 1 1];
    %B2FREQRESPONSE Property is of type 'double_vector user-defined' 
    B2FreqResponse = .2+18*(1-(0.8:0.01:1)).^2;
    %B3FREQRESPONSE Property is of type 'double_vector user-defined' 
    B3FreqResponse = [ 0, 0 ];
    %B4FREQRESPONSE Property is of type 'double_vector user-defined' 
    B4FreqResponse = [ 0, 0 ];
    %B5FREQRESPONSE Property is of type 'double_vector user-defined' 
    B5FreqResponse = [ 0, 0 ];
    %B6FREQRESPONSE Property is of type 'double_vector user-defined' 
    B6FreqResponse = [ 0, 0 ];
    %B7FREQRESPONSE Property is of type 'double_vector user-defined' 
    B7FreqResponse = [ 0, 0 ];
    %B8FREQRESPONSE Property is of type 'double_vector user-defined' 
    B8FreqResponse = [ 0, 0 ];
    %B9FREQRESPONSE Property is of type 'double_vector user-defined' 
    B9FreqResponse = [ 0, 0 ];
    %B10FREQRESPONSE Property is of type 'double_vector user-defined' 
    B10FreqResponse = [ 0, 0 ];
end


    methods  % constructor block
        function this = multibandmagnphase(varargin)
        %MULTIBANDMAGNPHASE   Construct a MULTIBANDMAGNPHASE object.
        
        %   Author(s): V. Pellissier
        
        % this = fspecs.multibandmagnphase;
        
        respstr = 'Multi-Band Arbitrary Magnitude and Phase';
        fstart = 1;
        fstop = 1;
        nargsnoFs = 2;
        fsconstructor(this,respstr,fstart,fstop,nargsnoFs,varargin{:});
        
        end  % multibandmagnphase
        
    end  % constructor block

    methods 
        function set.FilterOrder(obj,value)
        % User-defined DataType = 'posint user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive','integer'},'','FilterOrder');    
        obj.FilterOrder = value;
        end

        function set.B1FreqResponse(obj,value)
        % User-defined DataType = 'double_vector user-defined'
           validateattributes(value,{'double'},...
          {'vector'},'','B1FreqResponse');
        obj.B1FreqResponse = set_freqresp(obj,value);
        end

        function set.B2FreqResponse(obj,value)
        % User-defined DataType = 'double_vector user-defined'
           validateattributes(value,{'double'},...
          {'vector'},'','B2FreqResponse');
        obj.B2FreqResponse = set_freqresp(obj,value);
        end

        function set.B3FreqResponse(obj,value)
        % User-defined DataType = 'double_vector user-defined'
          validateattributes(value,{'double'},...
          {'vector'},'','B3FreqResponse');
        obj.B3FreqResponse = set_freqresp(obj,value);
        end

        function set.B4FreqResponse(obj,value)
        % User-defined DataType = 'double_vector user-defined'
         validateattributes(value,{'double'},...
          {'vector'},'','B4FreqResponse');
        obj.B4FreqResponse = set_freqresp(obj,value);
        end

        function set.B5FreqResponse(obj,value)
        % User-defined DataType = 'double_vector user-defined'
         validateattributes(value,{'double'},...
          {'vector'},'','B5FreqResponse');
        obj.B5FreqResponse = set_freqresp(obj,value);
        end

        function set.B6FreqResponse(obj,value)
        % User-defined DataType = 'double_vector user-defined'
         validateattributes(value,{'double'},...
          {'vector'},'','B6FreqResponse');
        obj.B6FreqResponse = set_freqresp(obj,value);
        end

        function set.B7FreqResponse(obj,value)
        % User-defined DataType = 'double_vector user-defined'
         validateattributes(value,{'double'},...
          {'vector'},'','B7FreqResponse');
        obj.B7FreqResponse = set_freqresp(obj,value);
        end

        function set.B8FreqResponse(obj,value)
        % User-defined DataType = 'double_vector user-defined'
         validateattributes(value,{'double'},...
          {'vector'},'','B8FreqResponse');
        obj.B8FreqResponse = set_freqresp(obj,value);
        end

        function set.B9FreqResponse(obj,value)
        % User-defined DataType = 'double_vector user-defined'
         validateattributes(value,{'double'},...
          {'vector'},'','B9FreqResponse');
        obj.B9FreqResponse = set_freqresp(obj,value);
        end

        function set.B10FreqResponse(obj,value)
        % User-defined DataType = 'double_vector user-defined'
         validateattributes(value,{'double'},...
          {'vector'},'','B10FreqResponse');
        obj.B10FreqResponse = set_freqresp(obj,value);
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(this,str)
    [F,A] = getmask(this)
    specs = getspecs(this)
    p = propstoadd(this)
    freqresp = set_freqresp(this,freqresp)
    [N,F,E,H,nfpts] = validatespecs(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    description = describe(this)
    minfo = measureinfo(this)
    pname = orderprop(this)
end  % possibly private or hidden 

end  % classdef

