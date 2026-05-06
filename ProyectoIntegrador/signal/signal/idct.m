function a = idct(b,n)
%IDCT Inverse discrete cosine transform.
%
%   X = IDCT(Y) inverts the DCT transform, returning the
%   original vector if Y was obtained using Y = DCT(X).
%
%   X = IDCT(Y,N) pads or truncates the vector Y to length N 
%   before transforming.
%
%   If Y is a matrix, the IDCT operation is applied to
%   each column.
%
%   % Example:
%   %   Generate a noisy 25 Hz sinusoidal sequence sampled at 1000 Hz and
%   %   compute the DCT of this sequence and reconstruct the signal using 
%   %   only those components with magnitude greater than 0.9
%   
%   t = (0:999)/1000;           % Time vector
%   x = sin(2*pi*25*t);         % Sinusoid
%   x = x + 0.1*randn(1,1000);  % Add noise
%   y = dct(x);                 % Compute DCT
%   y(abs(y) < 0.9) = 0;        % remove small components
%   z = idct(y);                % Reconstruct signal w/inverse DCT
%   subplot(2,1,1) 
%   plot(t,x)
%   title('Original Signal')
%   subplot(2,1,2)
%   plot(t,z)
%   title('Reconstructed Signal')
%
%   See also FFT, IFFT, DCT.

%   Author(s): C. Thompson, 2-12-93
%              S. Eddins, 10-26-94, revised
%   Copyright 1988-2016 The MathWorks, Inc.

%   References: 
%   1) A. K. Jain, "Fundamentals of Digital Image
%      Processing", pp. 150-153.
%   2) Wallace, "The JPEG Still Picture Compression Standard",
%      Communications of the ACM, April 1991.

if nargin == 0
	error(message('signal:idct:Nargchk'));
end

if isempty(b)
   a = zeros(0,0,'like',b);
   return
end

% If input is a vector, make it a column:
do_trans = (size(b,1) == 1);
if do_trans, b = b(:); end
   
if nargin==1
  n = size(b,1);
end
m = size(b,2);

% Cast to enforce precision rules. 
n = signal.internal.sigcasttofloat(n,'double','fwht','N','allownumeric');
signal.internal.sigcheckfloattype(b,'','fwht','Y');

% Pad or truncate b if necessary
if size(b,1)<n
  bb = zeros(n,m,'like',b);
  bb(1:size(b,1),:) = b;
else
  bb = b(1:n,:);
end

% Compute wieghts
ww = sqrt(2*n) * exp(1i*cast(0:n-1,'like',b)*pi/(2*n)).';

if rem(n,2)==1 || ~isreal(b) % odd case
  % Form intermediate even-symmetric matrix.
  ww(1) = ww(1) * sqrt(2);
  W = ww(:,ones(1,m));
  yy = zeros(2*n,m,'like',b);
  yy(1:n,:) = W.*bb;
  yy(n+2:2*n,:) = -1i*W(2:n,:).*flipud(bb(2:n,:));
  
  y = ifft(yy);

  % Extract inverse DCT
  a = y(1:n,:);

else % even case
  % Compute precorrection factor
  ww(1) = ww(1)/sqrt(2);
  W = ww(:,ones(1,m));
  yy = W.*bb;

  % Compute x tilde using equation (5.93) in Jain
  y = ifft(yy);
  
  % Re-order elements of each column according to equations (5.93) and
  % (5.94) in Jain
  a = zeros(n,m,'like',y);
  a(1:2:n,:) = y(1:n/2,:);
  a(2:2:n,:) = y(n:-1:n/2+1,:);
end

if isreal(b)
  a = real(a); 
end
if do_trans
  a = a.';
end
