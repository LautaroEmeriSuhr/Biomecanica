classdef comblbwgbwnsh < fspecs.abstractspecwithfs
%COMBLBWGBWNSH   Construct an COMBLBWGBWNSH object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.comblbwgbwnsh class
%   fspecs.comblbwgbwnsh extends fspecs.abstractspecwithfs.
%
%    fspecs.comblbwgbwnsh properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       CombType - Property is of type 'CombTypeType enumeration: {'Peak','Notch'}'  
%       PeakNotchFrequencies - Property is of type 'double_vector user-defined'  
%       NumPeaksOrNotches - Property is of type 'posint user-defined'  
%       ShelvingFilterOrder - Property is of type 'posint user-defined'  
%       BW - Property is of type 'double'  
%       GBW - Property is of type 'double'  
%
%    fspecs.comblbwgbwnsh methods:
%       describe -   Describe the object.
%       get_peaknotchfrequencies - PreGet function for the 'PeakNotchFrequencies'
%       getdesignobj -   Get the design object.
%       measureinfo -   Return a structure of information for the measurements.
%       props2normalize -   Return the property name to normalize.
%       propstoadd -   Return the properties to add to the parent object.
%       setspecs -   Set the specifications


properties (AbortSet, SetObservable, GetObservable)
    %COMBTYPE Property is of type 'CombTypeType enumeration: {'Peak','Notch'}' 
    CombType = 'Notch';
    %PEAKNOTCHFREQUENCIES Property is of type 'double_vector user-defined' 
    PeakNotchFrequencies = [];
    %NUMPEAKSORNOTCHES Property is of type 'posint user-defined' 
    NumPeaksOrNotches = 10;
    %SHELVINGFILTERORDER Property is of type 'posint user-defined' 
    ShelvingFilterOrder = 1;
    %BW Property is of type 'double' 
    BW = 0.0125;
    %GBW Property is of type 'double' 
    GBW = 10*log10( .5 );
end


    methods  % constructor block
        function this = comblbwgbwnsh(varargin)
        %COMBLBWGBWNSH   Construct a COMBLBWGBWNSH object.
        
        
        % this = fspecs.comblbwgbwnsh;
        
        this.CombType = 'Notch';
        
        this.ResponseType = 'Comb Filter';
        
        this.setspecs(varargin{:});
        
        
        end  % comblbwgbwnsh
        
    end  % constructor block

    methods 
        function set.CombType(obj,value)
        % Enumerated DataType = 'CombTypeType enumeration: {'Peak','Notch'}'
        value = validatestring(value,{'Peak','Notch'},'','CombType');
        obj.CombType = value;
        end

        function value = get.PeakNotchFrequencies(obj)
        value = get_peaknotchfrequencies(obj,obj.PeakNotchFrequencies);
        end
        function set.PeakNotchFrequencies(obj,value)
        % User-defined DataType = 'double_vector user-defined'
         validateattributes(value,{'double'},...
          {'vector'},'','PeakNotchFrequencies');
        obj.PeakNotchFrequencies = value;
        end

        function set.NumPeaksOrNotches(obj,value)
        % User-defined DataType = 'posint user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive','integer'},'','NumPeaksOrNotches');    
        obj.NumPeaksOrNotches = value;
        end

        function set.ShelvingFilterOrder(obj,value)
        % User-defined DataType = 'posint user-defined'
        validateattributes(value,{'numeric'},...
          {'scalar','positive','integer'},'','ShelvingFilterOrder');    
        obj.ShelvingFilterOrder = value;
        end

        function set.BW(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','BW')
        value = double(value);
        obj.BW = value;
        end

        function set.GBW(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','GBW')
        value = double(value);
        obj.GBW = value;
        end

    end   % set and get functions 

    methods  % public methods
    p = describe(this)
    freqs = get_peaknotchfrequencies(this,freqs)
    designobj = getdesignobj(this,str)
    minfo = measureinfo(this)
    p = props2normalize(this)
    p = propstoadd(this)
    setspecs(this,varargin)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    [p,s] = magprops(this)
    specs = thisgetspecs(this)
end  % possibly private or hidden 

end  % classdef

