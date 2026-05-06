function Wdt = dtwin(w,Fs)
% differentiate window in time domain via cubic spline interpolation

% compute the piecewise polynomial representation of the window
% and fetch the coefficients
n = numel(w);
pp = spline(1:n,w);
[breaks,coefs,npieces,order,dim] = unmkpp(pp);

% take the derivative of each polynomial and evaluate it over the same
% samples as the original window
ppd = mkpp(breaks,repmat(order-1:-1:1,dim*npieces,1).*coefs(:,1:order-1),dim);
Wdt = ppval(ppd,(1:n)').*(Fs/(2*pi));