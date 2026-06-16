function y = centerest(y)
n = size(y,1);
if n/2==round(n/2)
  %even (nyquist is at end of spectrum)
  y = circshift(y,n/2-1);
else
  % odd
  y = fftshift(y,1);
end