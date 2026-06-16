classdef parameqap < fspecs.abstractparameqap
%PARAMEQAP   Construct an PARAMEQAP object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.parameqap class
%   fspecs.parameqap extends fspecs.abstractparameqap.
%
%    fspecs.parameqap properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       G0 - Property is of type 'double'  
%       Gref - Property is of type 'double'  
%       GBW - Property is of type 'double'  
%       F0 - Property is of type 'double'  
%       BW - Property is of type 'double'  
%       Gpass - Property is of type 'double'  
%
%    fspecs.parameqap methods:
%       getdesignobj -   Get the design object.



    methods  % constructor block
        function this = parameqap(varargin)
        %PARAMEQAP   Construct a PARAMEQAP object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.parameqap;
        
        this.ResponseType = 'Parametric Equalizer';
        
        this.setspecs(varargin{:});
        
        
        
        end  % parameqap
        
    end  % constructor block

    methods  % public methods
    designobj = getdesignobj(this,str)
end  % public methods 

end  % classdef

