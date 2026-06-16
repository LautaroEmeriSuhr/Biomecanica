function p = propstoadd(this,varargin)
%PROPSTOADD   

%   Copyright 2009 The MathWorks, Inc.

% Create correct field name order
if isa(this,'fspecs.audioweightingwt')
  p = {'NormalizedFrequency','Fs','WeightingType'}';
else
  p = {'NormalizedFrequency','Fs','WeightingType','Class'}';
end
% [EOF]
