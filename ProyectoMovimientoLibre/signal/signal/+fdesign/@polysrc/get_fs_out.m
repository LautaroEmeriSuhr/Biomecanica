function fs_out = get_fs_out(this, fs_out)
%GET_FS_OUT   PreGet function for the 'fs_out' property.

%   Copyright 2005 The MathWorks, Inc.

if this.NormalizedFrequency
    fs = [];
else
    fs_out = this.Fs/this.DecimationFactor;
end

% [EOF]
