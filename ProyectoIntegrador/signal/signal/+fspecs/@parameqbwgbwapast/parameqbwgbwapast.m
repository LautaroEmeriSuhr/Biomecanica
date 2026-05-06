classdef parameqbwgbwapast < fspecs.abstractparameqbwgbwap
%PARAMEQBWGBWAPAST   Construct an PARAMEQBWGBWAPAST object.

%   Copyright 1999-2015 The MathWorks, Inc.  

%fspecs.parameqbwgbwapast class
%   fspecs.parameqbwgbwapast extends fspecs.abstractparameqbwgbwap.
%
%    fspecs.parameqbwgbwapast properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       Gref - Property is of type 'double'  
%       G0 - Property is of type 'double'  
%       F0 - Property is of type 'double'  
%       BW - Property is of type 'double'  
%       GBW - Property is of type 'double'  
%       Gpass - Property is of type 'double'  
%       BWpass - Property is of type 'double'  
%       Gstop - Property is of type 'double'  
%
%    fspecs.parameqbwgbwapast methods:
%       getdesignobj -   Get the design object.


properties (AbortSet, SetObservable, GetObservable)
    %GSTOP Property is of type 'double' 
    Gstop = -9;
end


    methods  % constructor block
        function this = parameqbwgbwapast(varargin)
        %PARAMEQBWGBWAPAST   Construct a PARAMEQBWGBWAPAST object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.parameqbwgbwapast;
        
        this.ResponseType = 'Parametric Equalizer';
        
        this.setspecs(varargin{:});
        
        
        end  % parameqbwgbwapast
        
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

