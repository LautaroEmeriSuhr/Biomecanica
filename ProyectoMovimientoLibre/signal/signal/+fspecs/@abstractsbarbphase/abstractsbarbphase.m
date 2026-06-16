classdef (Abstract) abstractsbarbphase < fspecs.abstractspecwithfs
%ABSTRACTSBARBPHASE   Construct an ABSTRACTSBARBPHASE object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractsbarbphase class
%   fspecs.abstractsbarbphase extends fspecs.abstractspecwithfs.
%
%    fspecs.abstractsbarbphase properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       Frequencies - Property is of type 'double_vector user-defined'  
%
%    fspecs.abstractsbarbphase methods:
%       measureinfo - Return a structure of information for the measurements.
%       props2normalize - Return the property name to normalize.
%       set_frequencies - PreSet function for the 'frequencies' property.


properties (AbortSet, SetObservable, GetObservable)
    %FREQUENCIES Property is of type 'double_vector user-defined' 
    Frequencies = [];
end


    methods 
        function set.Frequencies(obj,value)
        % User-defined DataType = 'double_vector user-defined'
         validateattributes(value,{'double'},...
          {'vector'},'','Frequencies');
        obj.Frequencies = set_frequencies(obj,value);
        end

    end   % set and get functions 

    methods  % public methods
    minfo = measureinfo(this)
    p = props2normalize(~)
    frequencies = set_frequencies(this,frequencies)
end  % public methods 

end  % classdef

