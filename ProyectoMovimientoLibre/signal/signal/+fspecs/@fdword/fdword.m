classdef fdword < fspecs.abstractspecwithordnfs
%fspecs.fdword class
%   fspecs.fdword extends fspecs.abstractspecwithordnfs.
%
%    fspecs.fdword properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       privFracDelay - Property is of type 'double'  
%
%    fspecs.fdword methods:
%       getdesignobj -   Get the design object.
%       getfracdelay -   Get the fracdelay.
%       getorder - Get the order.
%       props2normalize -   Properties to normalize frequency.
%       thisgetspecs -   Get the specs.


properties (AbortSet, SetObservable, GetObservable)
    %PRIVFRACDELAY Property is of type 'double' 
    privFracDelay = 0;
end


    methods  % constructor block
        function this = fdword(varargin)
        %FDWORDER   Construct a FDWORDER object.
        
        %   Author(s): V. Pellissier
        
        % this = fspecs.fdword;
        this.ResponseType = 'Fractional Delay with Filter Order';
        this.FilterOrder = 3;
        if nargin>0,
            this.FilterOrder = varargin{1};
        end
        
        
        end  % fdword
        
    end  % constructor block

    methods 
        function set.privFracDelay(obj,value)
            % DataType = 'double'
        validateattributes(value,{'numeric'}, {'scalar'},'','privFracDelay')
        value = double(value);  
        obj.privFracDelay = value;
        end

    end   % set and get functions 

    methods  % public methods
    designobj = getdesignobj(this,str)
    fracdelay = getfracdelay(this)
    order = getorder(this)
    p = props2normalize(h)
    specs = thisgetspecs(this)
end  % public methods 


    methods (Hidden) % possibly private or hidden
    minfo = measureinfo(this)
    p = propstoadd(this)
    p = thisprops2add(this,varargin)
end  % possibly private or hidden 

end  % classdef

