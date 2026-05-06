classdef notchbw < fspecs.abstractpeaknotchbw
%NOTCHBW   Construct an NOTCHBW object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.notchbw class
%   fspecs.notchbw extends fspecs.abstractpeaknotchbw.
%
%    fspecs.notchbw properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       F0 - Property is of type 'double'  
%       BW - Property is of type 'double'  
%
%    fspecs.notchbw methods:
%       getdesignobj -   Get the design object.



    methods  % constructor block
        function this = notchbw(varargin)
        %NOTCHBW   Construct a NOTCHBW object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.notchbw;
        
        this.ResponseType = 'Notching Filter';
        
        this.setspecs(varargin{:});
        
        
        end  % notchbw
        
    end  % constructor block

    methods  % public methods
    designobj = getdesignobj(this,str)
end  % public methods 

end  % classdef

