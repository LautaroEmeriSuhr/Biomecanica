function f = centerfreq(f)
n = numel(f);
if n/2==round(n/2)
  %even (nyquist is at end of spectrum)
  f = f - f(n/2);
else
  % odd
  f = f - f((n+1)/2);
end