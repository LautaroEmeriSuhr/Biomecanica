classdef (Abstract) abstractcombwithord < fspecs.abstractspecwithordnfs
%ABSTRACTCOMBWITHORD   Construct an ABSTRACTCOMBWITHORD object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractcombwithord class
%   fspecs.abstractcombwithord extends fspecs.abstractspecwithordnfs.
%
%    fspecs.abstractcombwithord properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       CombType - Property is of type 'CombTypeType enumeration: {'Peak','Notch'}'  
%       PeakNotchFrequencies - Property is of type 'double_vector user-defined'  
%
%    fspecs.abstractcombwithord methods:
%       get_peaknotchfrequencies - PreGet function for the 'PeakNotchFrequencies'
%       measureinfo -   Return a structure of information for the measurements.
%       setspecs -   Set the specifications


properties (AbortSet, SetObservable, GetObservable)
    %COMBTYPE Property is of type 'CombTypeType enumeration: {'Peak','Notch'}' 
    CombType = 'Notch';
    %PEAKNOTCHFREQUENCIES Property is of type 'double_vector user-defined' 
    PeakNotchFrequencies = [];
end


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

    end   % set and get functions 

    methods  % public methods
    freqs = get_peaknotchfrequencies(this,freqs)
    minfo = measureinfo(this)
    setspecs(this,varargin)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    [p,s] = magprops(this)
end  % possibly private or hidden 

end  % classdef

