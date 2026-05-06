classdef parameq < fspecs.abstractparameqbw
%PARAMEQ   Construct an PARAMEQ object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.parameq class
%   fspecs.parameq extends fspecs.abstractparameqbw.
%
%    fspecs.parameq properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       G0 - Property is of type 'double'  
%       Gref - Property is of type 'double'  
%       GBW - Property is of type 'double'  
%       F0 - Property is of type 'double'  
%       BW - Property is of type 'double'  
%
%    fspecs.parameq methods:
%       getdesignobj -   Get the design object.



    methods  % constructor block
        function this = parameq(varargin)
        %PARAMEQ   Construct a PARAMEQ object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.parameq;
        
        this.ResponseType = 'Parametric Equalizer';
        
        this.setspecs(varargin{:});
        
        
        end  % parameq
        
    end  % constructor block

    methods  % public methods
    designobj = getdesignobj(this,str)
end  % public methods 

end  % classdef

