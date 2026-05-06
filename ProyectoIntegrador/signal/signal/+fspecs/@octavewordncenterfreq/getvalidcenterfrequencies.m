function validcenterfrequencies = getvalidcenterfrequencies(this)
%GETVALIDCENTERFREQUENCIES   Get the validcenterfrequencies.

%   Author(s): V. Pellissier
%   Copyright 2006-2016 The MathWorks, Inc.

b = this.privBandsPerOctave; % BandsPerOctave
G = 10^(3/10);
x = -1000:1350;
if rem(b,2)
    % b odd
    validcenterfrequencies = 1000*(G.^((x-30)/b));
else
    validcenterfrequencies = 1000*(G.^((2*x-59)/(2*b)));
end

validcenterfrequencies(validcenterfrequencies>20000)=[]; % Upper limit 20 kHz
validcenterfrequencies(validcenterfrequencies<20)=[];    % Lower limit 20 Hz

% Compute upper frequency of bandpass filter
F2 = validcenterfrequencies .*(G^(1/(2*b))); 
if ischar(this.Fs) && strcmp(this.Fs,'Normalized')
    FS = 48000;
else
    FS = this.Fs;
end

% If none of the F2 frequencies are less than Fs/2, then the selected
% sample rate does not allow any useful design. In that case, 
% do not change validcenterfrequencies. The error will be thrown at design
% time
if (F2(1) < FS/2)
    validcenterfrequencies(F2 >= FS/2)=[];    % Remove center frequencies where design breaks Nyquist
end

% [EOF]
