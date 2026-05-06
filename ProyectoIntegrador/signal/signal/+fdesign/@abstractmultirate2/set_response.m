function response = set_response(this, response)
%SET_RESPONSE   PreSet function for the 'Response' property.

%   Copyright 2005 The MathWorks, Inc.

this.privResponse = response;

% Update the currently stored FDESIGN object.
updatecurrentfdesign(this);

% [EOF]
