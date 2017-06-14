close all; clear all; 

%% LOAD AUDIO 

% vowel 'a'
[sigA, Fe] = audioread('audio/a.aif');
sigA = 0.9*sigA/max(abs(sigA)); % normalize

% vowel 'i'
[sigI, ~] = audioread('audio/i.aif');
sigI = 0.9*sigI/max(abs(sigI)); % normalize

% random audio signal
[sig, ~] = audioread('audio/full-sentence.wav');
sig = 0.9*sig/max(abs(sig)); % normalize

%% GLOBAL VARIABLES

% Various
Te = 1/ Fe;
fmax = Fe / 2;
Ni = length(sigI);
Na = length(sigA);
Nfft = 1024;

% ANALYSIS
Nwin = 2048;
win = hann(Nwin, 'periodic');
Nover = floor(0.5 *Nwin);
p = 6; % number of LPC poles 

% interpolation parameters
tInterp = 5; % time of interpolation (s)
nInterp = floor(tInterp * Fe);
Nframes = floor(nInterp / Nwin); % number of frames

% PLOT VECTORS
t = [0 : nInterp] * Te;
f = [-fmax : Fe/nInterp : fmax];

% Spectrogram
[a.A, a.E, a.K, a.F] = spectroFormant(sigA, p, Fe, win, Nover, Nfft);
[i.A, i.E, i.K, i.F] = spectroFormant(sigI, p, Fe, win, Nover, Nfft);

[A, E, K, F] = spectroFormant(sig, p, Fe, win, Nover, Nfft);
