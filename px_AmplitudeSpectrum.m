function [AS,f] = px_AmplitudeSpectrum (TR,N,S)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   [AS,f] = px_AmplitudeSpectrum (TR,N)
%
%   TR   Sampling frequency, e.g. TR = 2.5 
%   N    Time points or Length of signal, e.g. N = 144
%   S    Signal file
%
%   Pengfei Xu, QC, CUNY, 2/15/2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs = 1/TR;                     % Sample time
NFFT = 2^nextpow2(N);          % Next power of 2 from length of y
freq_vector = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(S,NFFT)/N;
yy = 2*abs(Y(1:NFFT/2+1));

% set up output parameters
if (nargout == 2),
   AS = yy;
   f = freq_vector;
elseif (nargout == 1),
   AS = yy;
elseif (nargout == 0),          % do a plot
   newplot;
   plot(freq_vector,AS), grid on
   xlabel('Frequency (Hz)');ylabel('|Y(f)|');
end