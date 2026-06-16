function tocspectral
% ---------------------------------------------------------------
% Spectral Analysis
% Power spectrum, coherence, time-frequency analysis, windows   
% ---------------------------------------------------------------
% Nonparametric Methods
%   <a href="matlab:help cpsd">cpsd</a>           - Cross Power Spectral Density
%   <a href="matlab:help fsst">fsst</a>           - Fourier Synchrosqueezed Transform 
%   <a href="matlab:help ifsst">ifsst</a>          - Inverse Fourier Synchrosqueezed Transform
%   <a href="matlab:help mscohere">mscohere</a>       - Magnitude squared coherence estimate
%   <a href="matlab:help periodogram">periodogram</a>    - Periodogram PSD estimation method
%   <a href="matlab:help plomb">plomb</a>          - Lomb-Scargle periodogram
%   <a href="matlab:help pmtm">pmtm</a>           - Thomson multitaper PSD estimation method
%   <a href="matlab:help pwelch">pwelch</a>         - Welch's PSD estimation method
%   <a href="matlab:help spectrogram">spectrogram</a>    - Spectrogram using a Short-Time Fourier Transform (STFT)
%   <a href="matlab:help tfridge">tfridge</a>        - Extract time-frequency ridges 
%
% Order Analysis Methods
%   <a href="matlab:help rpmfreqmap">rpmfreqmap</a>     - Frequency analysis with frequency-rpm map   
%   <a href="matlab:help rpmordermap">rpmordermap</a>    - Order analysis with order-rpm map
%   <a href="matlab:help ordertrack">ordertrack</a>     - Track and extract orders in a vibration signal   
%   <a href="matlab:help orderwaveform">orderwaveform</a>  - Extract time-domain order waveforms from a vibration signal
%   <a href="matlab:help orderspectrum">orderspectrum</a>  - Average spectrum versus order for a vibration signal 
%   <a href="matlab:help tachorpm">tachorpm</a>       - Extract an RPM signal from tachometer pulses
%
% Parametric Methods
%   <a href="matlab:help pburg">pburg</a>          - Burg's PSD estimation method
%   <a href="matlab:help pcov">pcov</a>           - Covariance PSD estimation method
%   <a href="matlab:help pmcov">pmcov</a>          - Modified Covariance PSD estimation method
%   <a href="matlab:help pyulear">pyulear</a>        - Yule-Walker AR PSD estimation method
%
% Subspace Methods
%   <a href="matlab:help peig">peig</a>           - Eigenvector PSD estimation method
%   <a href="matlab:help pmusic">pmusic</a>         - Multiple Signal Classification PSD estimation method
%   <a href="matlab:help rooteig">rooteig</a>        - Sinusoid frequency and power estimation via the eigenvector algorithm
%   <a href="matlab:help rootmusic">rootmusic</a>      - Sinusoid frequency and power estimation via the MUSIC algorithm
%
% Windows
%   <a href="matlab:help barthannwin">barthannwin</a>    - Modified Bartlett-Hanning window
%   <a href="matlab:help bartlett">bartlett</a>       - Bartlett window
%   <a href="matlab:help blackman">blackman</a>       - Blackman window
%   <a href="matlab:help blackmanharris">blackmanharris</a> - Minimum 4-term Blackman-Harris window
%   <a href="matlab:help bohmanwin">bohmanwin</a>      - Bohman window
%   <a href="matlab:help chebwin">chebwin</a>        - Chebyshev window
%   <a href="matlab:help flattopwin">flattopwin</a>     - Flat Top window
%   <a href="matlab:help gausswin">gausswin</a>       - Gaussian window
%   <a href="matlab:help hamming">hamming</a>        - Hamming window
%   <a href="matlab:help hann">hann</a>           - Hann window
%   <a href="matlab:help hanning">hanning</a>        - Hanning window
%   <a href="matlab:help kaiser">kaiser</a>         - Kaiser window
%   <a href="matlab:help nuttallwin">nuttallwin</a>     - Nuttall defined minimum 4-term Blackman-Harris window
%   <a href="matlab:help parzenwin">parzenwin</a>      - Parzen (de la Valle-Poussin) window
%   <a href="matlab:help rectwin">rectwin</a>        - Rectangular window
%   <a href="matlab:help taylorwin">taylorwin</a>      - Taylor window
%   <a href="matlab:help triang">triang</a>         - Triangular window
%   <a href="matlab:help tukeywin">tukeywin</a>       - Tukey window
%
%   <a href="matlab:help wintool">wintool</a>        - Open Window Design and Analysis Tool
%   <a href="matlab:help wvtool">wvtool</a>         - Open Window Visualization Tool
%
%   <a href="matlab:help dpss">dpss</a>           - Discrete prolate spheroidal sequences (Slepian sequences) 
%   <a href="matlab:help dpssclear">dpssclear</a>      - Remove discrete prolate spheroidal sequences from database
%   <a href="matlab:help dpssdir">dpssdir</a>        - Discrete prolate spheroidal sequence database directory
%   <a href="matlab:help dpssload">dpssload</a>       - Load discrete prolate spheroidal sequences from database
%   <a href="matlab:help dpsssave">dpsssave</a>       - Save discrete prolate spheroidal sequences in database
%
% Spectral Measurements
%   <a href="matlab:help bandpower">bandpower</a>      - Band power
%   <a href="matlab:help enbw">enbw</a>           - Equivalent noise bandwidth
%   <a href="matlab:help meanfreq">meanfreq</a>       - Mean frequency
%   <a href="matlab:help medfreq">medfreq</a>        - Median frequency
%   <a href="matlab:help obw">obw</a>            - Occupied bandwidth
%   <a href="matlab:help powerbw">powerbw</a>        - Power bandwidth
%   <a href="matlab:help tfestimate">tfestimate</a>     - Transfer function estimate
%
%   <a href="matlab:help sfdr">sfdr</a>           - Spurious-Free Dynamic Range
%   <a href="matlab:help sinad">sinad</a>          - Signal to Noise and Distortion ratio
%   <a href="matlab:help snr">snr</a>            - Signal to Noise Ratio
%   <a href="matlab:help thd">thd</a>            - Total Harmonic Distortion
%   <a href="matlab:help toi">toi</a>            - Third Order Intercept point
%
%   <a href="matlab:help db">db</a>             - Convert energy or power measurements to decibels
%   <a href="db2mag">db2mag</a>         - Convert decibels to magnitude
%   <a href="db2pow">db2pow</a>         - Convert decibels to power
%   <a href="findpeaks">findpeaks</a>      - Find local maxima
%   <a href="mag2db">mag2db</a>         - Convert magnitude to decibels
%   <a href="pow2db">pow2db</a>         - Convert power to decibels
%
%   <a href="matlab:help sptool">sptool</a>         - Open interactive digital signal processing tool
%
% <a href="matlab:help signal">Signal Processing Toolbox TOC</a>

%   Copyright 2015 The MathWorks, Inc.


