classdef peakbw < fspecs.abstractpeaknotchbw
%PEAKBW   Construct an PEAKBW object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.peakbw class
%   fspecs.peakbw extends fspecs.abstractpeaknotchbw.
%
%    fspecs.peakbw properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       F0 - Property is of type 'double'  
%       BW - Property is of type 'double'  
%
%    fspecs.peakbw methods:
%       getdesignobj -   Get the design object.



    methods  % constructor block
        function this = peakbw(varargin)
        %PEAKBW   Construct a PEAKBW object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.peakbw;
        
        this.ResponseType = 'Peaking Filter';
        
        this.setspecs(varargin{:});
        
        
        end  % peakbw
        
    end  % constructor block

    methods  % public methods
    designobj = getdesignobj(this,str)
end  % public methods 

end  % classdef

