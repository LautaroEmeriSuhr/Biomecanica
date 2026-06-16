classdef parameqaudioshelfqa < fspecs.abstractparameqaudioshelf
%PARAMEQAUDIOSHELFQA   Construct an PARAMEQAUDIOSHELFQA object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.parameqaudioshelfqa class
%   fspecs.parameqaudioshelfqa extends fspecs.abstractparameqaudioshelf.
%
%    fspecs.parameqaudioshelfqa properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       G0 - Property is of type 'double'  
%       F0 - Property is of type 'double'  
%       Fc - Property is of type 'double'  
%       Qa - Property is of type 'double'  
%
%    fspecs.parameqaudioshelfqa methods:
%       getdesignobj -   Get the design object.


properties (AbortSet, SetObservable, GetObservable)
    %QA Property is of type 'double' 
    Qa = 1/sqrt( 2 );
end


    methods  % constructor block
        function this = parameqaudioshelfqa(varargin)
        %PARAMEQ   Construct a PARAMEQAUDIOSHELFQA object.
        
        
        % this = fspecs.parameqaudioshelfqa;
        
        this.ResponseType = 'Parametric Equalizer';
        
        this.setspecs(varargin{:});
        
        
        end  % parameqaudioshelfqa
        
    end  % constructor block

    methods 
        function set.Qa(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Qa')
        value = double(value);
        obj.Qa = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(this,str)
end  % public methods 

end  % classdef

