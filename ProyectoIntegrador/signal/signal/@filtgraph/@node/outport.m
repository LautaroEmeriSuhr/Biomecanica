function outp = outport(Node,index)

%   Author(s): Roshan R Rammohan
%   Copyright 1988-2004 The MathWorks, Inc.

narginchk(1,2);

N = Node;

if nargin > 1
    outp = N.block.outport(index);
else
    if length(N.block.outport) > 0
        outp = N.block.outport;
    else
        error(message('signal:filtgraph:node:outport:InternalError'));
    end
end
