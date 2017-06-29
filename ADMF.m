% f = ADMF(sig, Fs);
%
% ADMF returns the fundamental frequency of a stationary signal, with autocorrelation
% method
%
% INPUT: 
%  - sig: vector signal
%  - Fs: samplerate
%
% OUTPUT:
%  - f: frequency

function f = ADMF(sig, Fs),

Ts = 1 / Fs;

% Autocorrelation
[acor, lag] = xcorr(sig);

maxAcor = acor >= rms(acor);
indexes = lag .*maxAcor';
j = 1;
for i = 1:length(indexes)
  if indexes(i) > 0,
    temp(j) = indexes(i);
    j = j+ 1;
  end
end
temp= diff(temp);
t0 = max(temp)*Ts;
f=1./t0;
end
