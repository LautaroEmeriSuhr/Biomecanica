classdef peakq < fspecs.abstractpeaknotchq
%PEAKQ   Construct an PEAKQ object.

%   Copyright 1999-2015 The MathWorks, Inc.

%fspecs.peakq class
%   fspecs.peakq extends fspecs.abstractpeaknotchq.
%
%    fspecs.peakq properties:
%       ResponseType - Property is of type 'ustring' (read only) 
%       NormalizedFrequency - Property is of type 'bool'  
%       Fs - Property is of type 'mxArray'  
%       FilterOrder - Property is of type 'posint user-defined'  
%       F0 - Property is of type 'double'  
%       Q - Property is of type 'double'  
%
%    fspecs.peakq methods:
%       getdesignobj -   Get the design object.



    methods  % constructor block
        function this = peakq(varargin)
        %PEAKQ   Construct a PEAKQ object.
        
        %   Author(s): R. Losada
        
        % this = fspecs.peakq;
        
        this.ResponseType = 'Peaking Filter';
        
        this.setspecs(varargin{:});
        
        
        end  % peakq
        
    end  % constructor block

    methods  % public methods
    designobj = getdesignobj(this,str)
end  % public methods 

end  % classdef

