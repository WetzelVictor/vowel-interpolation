% [A, E, K, F] = spectroFormant(x, p, Fe, win)
%
% Output spectrogram with formant detection
%
% x   : signal
% p   : number of poles to detect
% Fe  : sampling frequency
% win : window
% Nfft: number of points where fft is computed (default: Nwin )
% Nover: number of samples overlapping (default: 0.5*Nwin)
%
% OUTPUT
% A : poles
% E : noise variance
% K : reflection coefficients
% F : frequencies of formants

function [A, E, K, F] = spectroFormant(x, p, Fe, win, Nover, Nfft)

%% DEFAULT PARAMETER
if nargin < 5
  Nover = floor(0.5* length(win));
  Nfft  = length(win);
elseif nargin < 6
  Nfft = length(win);
end


%% INITIALISATION
% Basic variables
N = length(x);
Nw = length(win) ;
Nf = floor(N/Nw);
fmax = Fe/2;
Te = 1 / Fe;

%% Spectrogram
f = [ -fmax : Fe/Nfft : fmax];
[S, f, t] = spectrogram(x, win, Nover, f, Fe);

%graph
figure
imagesc(t,flip(f),20*db(abs(S)))
xlabel('Temps(s)')
ylabel('Frequence (Hz)')
colorbar
ylim([ -15000 0])

% Instanciation
A = zeros(p, Nf);
E = zeros(Nw, Nf);
K = zeros(p, Nf);
F = zeros(p, Nf);

% POLE ANALYSIS
[A, E, K, F] = lpcAnalysis(x, p, win, Fe);

end
