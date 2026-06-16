classdef parameqflfhapast < fspecs.abstractparameqflfhap
%PARAMEQFLFHAPAST   Construct an PARAMEQFLFHAPAST object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.parameqflfhapast class
%   fspecs.parameqflfhapast extends fspecs.abstractparameqflfhap.
%
%    fspecs.parameqflfhapast properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       G0 - Property is of type 'double'  
%       Gref - Property is of type 'double'  
%       GBW - Property is of type 'double'  
%       Flow - Property is of type 'double'  
%       Fhigh - Property is of type 'double'  
%       Gpass - Property is of type 'double'  
%       Gstop - Property is of type 'double'  
%
%    fspecs.parameqflfhapast methods:
%       getdesignobj -   Get the design object.


properties (AbortSet, SetObservable, GetObservable)
    %GSTOP Property is of type 'double' 
    Gstop = -9;
end


    methods  % constructor block
        function this = parameqflfhapast(varargin)
        %PARAMEQFLFHAPAST   Construct a PARAMEQFLFHAPAST object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.parameqflfhapast;
        
        this.ResponseType = 'Parametric Equalizer';
        
        this.setspecs(varargin{:});
        
        
        end  % parameqflfhapast
        
    end  % constructor block

    methods 
        function set.Gstop(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Gstop')
        value = double(value);
        obj.Gstop = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(this,str)
end  % public methods 

end  % classdef

