classdef parameqbwgbwast < fspecs.abstractminparameq
%PARAMEQBWGBWAST   Construct an PARAMEQBWGBWAST object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.parameqbwgbwast class
%   fspecs.parameqbwgbwast extends fspecs.abstractminparameq.
%
%    fspecs.parameqbwgbwast properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       Gref - Property is of type 'double'  
%       G0 - Property is of type 'double'  
%       F0 - Property is of type 'double'  
%       BW - Property is of type 'double'  
%       GBW - Property is of type 'double'  
%       Gstop - Property is of type 'double'  
%       BWstop - Property is of type 'double'  
%
%    fspecs.parameqbwgbwast methods:
%       getdesignobj -   Get the design object.
%       props2normalize -   Return the property name to normalize.


properties (AbortSet, SetObservable, GetObservable)
    %GSTOP Property is of type 'double' 
    Gstop = -9;
    %BWSTOP Property is of type 'double' 
    BWstop = 0.4;
end


    methods  % constructor block
        function this = parameqbwgbwast(varargin)
        %PARAMEQBWGBWAST   Construct a PARAMEQBWGBWAST object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.parameqbwgbwast;
        
        this.ResponseType = 'Parametric Equalizer';
        
        this.setspecs(varargin{:});
        
        
        end  % parameqbwgbwast
        
    end  % constructor block

    methods 
        function set.Gstop(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Gstop')
        value = double(value);
        obj.Gstop = value;
        end

        function set.BWstop(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','BWstop')
        value = double(value);
        obj.BWstop = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(this,str)
    p = props2normalize(this)
end  % public methods 

end  % classdef

