function [B,G] = sgolay(varargin)
%MATLAB Code Generation Library Function

% Copyright 2008-2010 The MathWorks, Inc.
%#codegen    
myfun = 'sgolay';
coder.extrinsic('eml_try_catch');
eml_assert_all_constant(varargin{:});
[errid,errmsg,B,G] = eml_try_catch(myfun,varargin{:});
errid = coder.internal.const(errid);
errmsg = coder.internal.const(errmsg);
B = coder.internal.const(B);
G = coder.internal.const(G);
eml_lib_assert(isempty(errmsg),errid,errmsg);
