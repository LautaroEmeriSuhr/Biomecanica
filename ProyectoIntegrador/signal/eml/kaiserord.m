function [N, Wn, bta, filtype] = kaiserord(varargin)
%MATLAB Code Generation Library Function

% Copyright 2008-2010 The MathWorks, Inc.
%#codegen    
myfun = 'kaiserord';
coder.extrinsic('eml_try_catch');
eml_assert_all_constant(varargin{:});
if nargout == 1 && nargin == 5
   [errid, errmsg, N] = eml_try_catch(myfun,varargin{:});
   errid = coder.internal.const(errid);
   errmsg = coder.internal.const(errmsg);
   N = coder.internal.const(N);
else
   [errid, errmsg, N, Wn, bta, filtype] = eml_try_catch(myfun,varargin{:});
   errid = coder.internal.const(errid);
   errmsg = coder.internal.const(errmsg);
   N = coder.internal.const(N);
   Wn = coder.internal.const(Wn);
   bta = coder.internal.const(bta);
   filtype = coder.internal.const(filtype);
end
eml_lib_assert(isempty(errmsg),errid,errmsg);
