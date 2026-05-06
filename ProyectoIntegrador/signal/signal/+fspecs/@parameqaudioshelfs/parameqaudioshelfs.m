classdef parameqaudioshelfs < fspecs.abstractparameqaudioshelf
%PARAMEQAUDIOSHELFS   Construct an PARAMEQAUDIOSHELFS object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.parameqaudioshelfs class
%   fspecs.parameqaudioshelfs extends fspecs.abstractparameqaudioshelf.
%
%    fspecs.parameqaudioshelfs properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       G0 - Property is of type 'double'  
%       F0 - Property is of type 'double'  
%       Fc - Property is of type 'double'  
%       S - Property is of type 'double'  
%
%    fspecs.parameqaudioshelfs methods:
%       getdesignobj -   Get the design object.


properties (AbortSet, SetObservable, GetObservable)
    %S Property is of type 'double' 
    S = 1;
end


    methods  % constructor block
        function this = parameqaudioshelfs(varargin)
        %PARAMEQ   Construct a PARAMEQAUDIOSHELFS object.
        
        
        % this = fspecs.parameqaudioshelfs;
        
        this.ResponseType = 'Parametric Equalizer';
        
        this.setspecs(varargin{:});
        
        
        end  % parameqaudioshelfs
        
    end  % constructor block

    methods 
        function set.S(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','S')
        value = double(value);
        obj.S = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(this,str)
end  % public methods 

end  % classdef

