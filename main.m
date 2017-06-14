close all; clear all; 

%% LOAD AUDIO 
% random audio signal
[sig, Fe] = audioread('audio/i.aif');
sig = 0.9*sig/max(abs(sig)); % normalize

% preemph = [1 0.63];
% sig = filter(1,preemph,sig);

%% GLOBAL VARIABLES
% Various
Te = 1/ Fe;
fmax = Fe / 2;

% ANALYSIS
N = length(sig);
Nwin = 256;
win = hamming(Nwin, 'periodic');
over = 0.5;
Nover = floor(over *Nwin);
Nframes = floor(N/(Nwin*over)) - 2;
Nfft = 1024;
p = 25; % number of LPC poles 

% VECTORS PLOT
t = [0:Nframes] * Te;
f = [-fmax : Fe/Nfft : fmax];

% Spectrogram
[A, E, K, F] = spectroFormant(sig, p, Fe, win, Nover, Nfft);

figure;
plot(t, F')
