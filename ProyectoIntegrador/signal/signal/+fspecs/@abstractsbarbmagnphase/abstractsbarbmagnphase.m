classdef (Abstract) abstractsbarbmagnphase < fspecs.abstractsbarbphase
%ABSTRACTSBARABMAGNPHASE   Construct an ABSTRACTSBARBMAGNPHASE object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.abstractsbarbmagnphase class
%   fspecs.abstractsbarbmagnphase extends fspecs.abstractsbarbphase.
%
%    fspecs.abstractsbarbmagnphase properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       Frequencies - Property is of type 'double_vector user-defined'  
%       FreqResponse - Property is of type 'double_vector user-defined'  
%
%    fspecs.abstractsbarbmagnphase methods:
%       get_phases - PreGet function for the 'phases' property.
%       getmask - Get the mask.
%       set_defaultresponse - Set default response
%       super_validatespecs -   Validate the specs
%       this_setfrequencies - PreSet function for the 'frequencies' property.
%       thisgetspecs -   Get the specs.


properties (AbortSet, SetObservable, GetObservable)
    %FREQRESPONSE Property is of type 'double_vector user-defined' 
    FreqResponse = [];
end


    methods 
        function set.FreqResponse(obj,value)
        % User-defined DataType = 'double_vector user-defined'
         validateattributes(value,{'double'},...
          {'vector'},'','FreqResponse');
        obj.FreqResponse = value;
        end

    end   % set and get functions 

    methods  % public methods
    phases = get_phases(this,~)
    [F,A] = getmask(this)
    set_defaultresponse(this)
    [F,A,P,nfpts] = super_validatespecs(this)
    frequencies = this_setfrequencies(this,frequencies)
    specs = thisgetspecs(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    minfo = measureinfo(this)
end  % possibly private or hidden 

end  % classdef

