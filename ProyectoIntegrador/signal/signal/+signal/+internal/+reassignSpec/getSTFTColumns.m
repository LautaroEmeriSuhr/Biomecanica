function [xin,t] = getSTFTColumns(x,nx,nwin,noverlap,Fs)
% Determine the number of columns of the STFT output (i.e., the S output)
ncol = fix((nx-noverlap)/(nwin-noverlap));

colindex = 1 + (0:(ncol-1))*(nwin-noverlap);
rowindex = (1:nwin)';
% 'xin' should be of the same datatype as 'x'
xin = zeros(nwin,ncol,class(x)); %#ok<*ZEROLIKE>

% Put x into columns of xin with the proper offset
xin(:) = x(rowindex(:,ones(1,ncol))+colindex(ones(nwin,1),:)-1);

% colindex already takes into account the noverlap factor; Return a T
% vector whose elements are centered in the segment.
t = ((colindex-1)+((nwin)/2)')/Fs;