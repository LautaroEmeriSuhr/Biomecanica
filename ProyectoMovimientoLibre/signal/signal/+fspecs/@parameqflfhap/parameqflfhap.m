classdef parameqflfhap < fspecs.abstractparameqflfhap
%PARAMEQFLFHAP   Construct an PARAMEQFLFHAP object.

%   Copyright 1999-2015 The MathWorks, Inc.  
  
%fspecs.parameqflfhap class
%   fspecs.parameqflfhap extends fspecs.abstractparameqflfhap.
%
%    fspecs.parameqflfhap properties:
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
%
%    fspecs.parameqflfhap methods:
%       getdesignobj -   Get the design object.



    methods  % constructor block
        function this = parameqflfhap(varargin)
        %PARAMEQFLFHAP   Construct a PARAMEQFLFHAP object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.parameqflfhap;
        
        this.ResponseType = 'Parametric Equalizer';
        
        this.setspecs(varargin{:});
        
        
        end  % parameqflfhap
        
    end  % constructor block

    methods  % public methods
    designobj = getdesignobj(this,str)
end  % public methods 

end  % classdef

