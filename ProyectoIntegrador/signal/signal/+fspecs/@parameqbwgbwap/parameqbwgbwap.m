classdef parameqbwgbwap < fspecs.abstractparameqbwgbwap
%PARAMEQBWGBWAP   Construct an PARAMEQBWGBWAP object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.parameqbwgbwap class
%   fspecs.parameqbwgbwap extends fspecs.abstractparameqbwgbwap.
%
%    fspecs.parameqbwgbwap properties:
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
%
%    fspecs.parameqbwgbwap methods:
%       getdesignobj -   Get the design object.



    methods  % constructor block
        function this = parameqbwgbwap(varargin)
        %PARAMEQBWGBWAP   Construct a PARAMEQBWGBWAP object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.parameqbwgbwap;
        
        this.ResponseType = 'Parametric Equalizer';
        
        this.setspecs(varargin{:});
        
        
        end  % parameqbwgbwap
        
    end  % constructor block

    methods  % public methods
    designobj = getdesignobj(this,str)
end  % public methods 

end  % classdef

