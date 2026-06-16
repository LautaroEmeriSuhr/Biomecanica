classdef parameqaudioqa < fspecs.abstractparameqaudio
%PARAMEQAUDIOQA   Construct an PARAMEQAUDIOQA object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.parameqaudioqa class
%   fspecs.parameqaudioqa extends fspecs.abstractparameqaudio.
%
%    fspecs.parameqaudioqa properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       G0 - Property is of type 'double'  
%       F0 - Property is of type 'double'  
%       Gref - Property is of type 'double'  
%       Qa - Property is of type 'double'  
%
%    fspecs.parameqaudioqa methods:
%       getdesignobj -   Get the design object.
%       measureinfo -   Return a structure of information for the measurements.
%       propstoadd -   Return the properties to add to the parent object.
%       set_F0 - PreSet function for the 'F0' property
%       setspecs -   Set the specifications


properties (AbortSet, SetObservable, GetObservable)
    %GREF Property is of type 'double' 
    Gref = 0;
    %QA Property is of type 'double' 
    Qa = 10;
end


    methods  % constructor block
        function this = parameqaudioqa(varargin)
        %PARAMEQ   Construct a PARAMEQAUDIOQA object.
        
        
        % this = fspecs.parameqaudioqa;
        
        set(this, 'ResponseType', 'Parametric Equalizer');
        
        this.setspecs(varargin{:});
        
        
        end  % parameqaudioqa
        
    end  % constructor block

    methods 
        function set.Gref(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Gref')
        value = double(value);
        obj.Gref = value;
        end

        function set.Qa(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','Qa')
        value = double(value);
        obj.Qa = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(this,str)
    minfo = measureinfo(this)
    p = propstoadd(this)
    F0 = set_F0(this,F0)
    setspecs(this,varargin)
end  % public methods 

end  % classdef

