classdef fdsrcword < fspecs.abstractspecwithfs
%FDSRCWORD   Construct an FDSRCWORD object.

%   Copyright 1999-2015 The MathWorks, Inc.

%FDSRCWORD   Construct an FDSRCWORD object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.fdsrcword class
%   fspecs.fdsrcword extends fspecs.abstractspecwithfs.
%
%    fspecs.fdsrcword properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       PolynomialOrder - Property is of type 'posint user-defined'  
%       privInterpolationFactor - Property is of type 'double'  
%       privDecimationFactor - Property is of type 'double'  
%
%    fspecs.fdsrcword methods:
%       getdesignobj -   Get the design object.
%       getorder - Get the order.
%       props2normalize -   Properties to normalize frequency.


properties (AbortSet, SetObservable, GetObservable)
    %POLYNOMIALORDER Property is of type 'posint user-defined' 
    PolynomialOrder = 3;
    %PRIVINTERPOLATIONFACTOR Property is of type 'double' 
    privInterpolationFactor = 3;
    %PRIVDECIMATIONFACTOR Property is of type 'double' 
    privDecimationFactor = 2;
end


    methods  % constructor block
        function this = fdsrcword(varargin)
        %FDSRCWORD Construct a FDSRCWORD object
        
        
        % this = fspecs.fdsrcword;
        this.ResponseType = 'Farrow SRC with Polynomial Order';
        this.PolynomialOrder = 3;
        if nargin>0,
            this.PolynomialOrder = varargin{1};
        end
        
        
        end  % fdsrcword
        
    end  % constructor block

    methods 
        function set.PolynomialOrder(obj,value)
        % User-defined DataType = 'posint user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive','integer'},'','PolynomialOrder');    
        obj.PolynomialOrder = value;
        end

        function set.privInterpolationFactor(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','privInterpolationFactor')
        value = double(value);    
        obj.privInterpolationFactor = value;
        end

        function set.privDecimationFactor(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','privDecimationFactor')
        value = double(value);
        obj.privDecimationFactor = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(this,str)
    order = getorder(this)
    p = props2normalize(h)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    Hd = lagrange(this,varargin)
    p = propstoadd(this)
end  % possibly private or hidden 

end  % classdef

