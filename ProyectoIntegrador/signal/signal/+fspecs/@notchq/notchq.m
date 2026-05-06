classdef notchq < fspecs.abstractpeaknotchq
%NOTCHQ   Construct an NOTCHQ object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.notchq class
%   fspecs.notchq extends fspecs.abstractpeaknotchq.
%
%    fspecs.notchq properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       F0 - Property is of type 'double'  
%       Q - Property is of type 'double'  
%
%    fspecs.notchq methods:
%       getdesignobj -   Get the design object.



    methods  % constructor block
        function this = notchq(varargin)
        %NOTCHQ   Construct a NOTCHQ object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.notchq;
        
        this.ResponseType = 'Notching Filter';
        
        this.setspecs(varargin{:});
        
        
        end  % notchq
        
    end  % constructor block

    methods  % public methods
    designobj = getdesignobj(this,str)
end  % public methods 

end  % classdef

