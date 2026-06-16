function s = saveobj(this)
%SAVEOBJ   Save this object.

%   Author(s): J. Schickler
%   Copyright 1988-2015 The MathWorks, Inc.

s = savemetadata(this);

s.class = class(this);
s.version = this.version;

s.PersistentMemory    = this.PersistentMemory;
s.NumSamplesProcessed = this.NumSamplesProcessed;
if isprop(this, 'SysObjParams')
    s.SysObjParams = this.SysObjParams;
end

for indx = 1:nstages(this)
    s.Stage(indx) = this.Stage(indx);
end

% [EOF]
