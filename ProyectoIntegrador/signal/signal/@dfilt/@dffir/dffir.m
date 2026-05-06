function Hd = dffir(num)
%DFFIR Direct-Form FIR.
%   Hd = DFILT.DFFIR(NUM) constructs a discrete-time, direct-form FIR filter
%   object Hd, with numerator coefficients NUM. 
%  
%   Note that one usually does not construct DFILT filters explicitly.
%   Instead, one obtains these filters as a result from a design using <a
%   href="matlab:help fdesign">FDESIGN</a>. 
%
%   Also, the DSP System Toolbox, along with the Fixed-Point Designer,
%   enables fixed-point support.  
%
%   % EXAMPLE #1: Direct instantiation
%   b = [0.05 0.9 0.05];
%   Hd = dfilt.dffir(b)
%   realizemdl(Hd)    % Requires Simulink
%   
%   % EXAMPLE #2: Design an equiripple lowpass filter with default specifications
%   Hd = design(fdesign.lowpass, 'equiripple', 'Filterstructure', 'dffir');
%   fvtool(Hd)        % Analyze filter
%   x = randn(100,1); % Input signal
%   y = filter(Hd,x); % Apply filter to input signal
%
%   See also DFILT/STRUCTURES
  
%   Copyright 1988-2012 The MathWorks, Inc.

Hd = dfilt.dffir;
Hd.ncoeffs = 1;
Hd.HiddenStates = 0;
Hd.TapIndex = 0;

Hd.FilterStructure = 'Direct-Form FIR';

if nargin>=1
  Hd.Numerator = num;
end

