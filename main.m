close all; clear all; 

%% LOAD AUDIO 

% vowel 'a'
[sigA, Fe] = audioread('audio/a.aif');
sigA = 0.9*sigA/max(abs(sigA)); % normalize
preemph = [1 0.63];
sigA = filter(1,preemph,sigA);

% vowel 'i'
[sigI, ~] = audioread('audio/i.aif');
sigI = 0.9*sigI/max(abs(sigI)); % normalize
sigI = filter(1,preemph,sigI);

% random audio signal
[sig, ~] = audioread('audio/full-sentence.wav');
sig = 0.9*sig/max(abs(sig)); % normalize
sig = filter(1,preemph,sig);

%% GLOBAL VARIABLES

% Various
Te = 1/ Fe;
fmax = Fe / 2;
Ni = length(sigI);
Na = length(sigA);
Nfft = 1024;

% ANALYSIS
Nwin = 256;
win = hamming(Nwin, 'periodic');
Nover = floor(0.5 *Nwin);
p = 10; % number of LPC poles 

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
