classdef parameqflfh < fspecs.abstractparameqflfh
%PARAMEQFLFH   Construct an PARAMEQFLFH object.

%   Copyright 1999-2015 The MathWorks, Inc. 

%fspecs.parameqflfh class
%   fspecs.parameqflfh extends fspecs.abstractparameqflfh.
%
%    fspecs.parameqflfh properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       G0 - Property is of type 'double'  
%       Gref - Property is of type 'double'  
%       GBW - Property is of type 'double'  
%       Flow - Property is of type 'double'  
%       Fhigh - Property is of type 'double'  
%
%    fspecs.parameqflfh methods:
%       getdesignobj -   Get the design object.
%       thisgetspecs -   Get the specs.



    methods  % constructor block
        function this = parameqflfh(varargin)
        %PARAMEQ   Construct a PARAMEQ object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.parameqflfh;
        
        this.ResponseType = 'Parametric Equalizer';
        
        this.setspecs(varargin{:});
        
        
        end  % parameqflfh
        
    end  % constructor block

    methods  % public methods
    designobj = getdesignobj(this,str)
    specs = thisgetspecs(this)
end  % public methods 

end  % classdef

