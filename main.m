close all; clear all; 

%% LOAD AUDIO 
% random audio signal
[sig, Fe] = audioread('audio/full-sentence.wav');
sig = 0.9*sig/max(abs(sig)); % normalize

preemph = [1 0.63];
sigf = filter(1,preemph,sig);

%% GLOBAL VARIABLES
% Various
Te = 1/ Fe;
fmax = Fe / 2;

% ANALYSIS
N = length(sigf);
Nwin = 512;
win = hamming(Nwin, 'periodic');
over = 0.5;
Nover = floor(over *Nwin);
Nframes = floor(N/(Nwin*over)) - 2;
Nfft = 1024;
p = 1 + floor(Fe/1000); % number of LPC poles 

% VECTORS PLOT
t = [0:Nframes] * Te;
f = [-fmax : Fe/Nfft : fmax];

%% Spectrogram

% POLE ANALYSIS
[A, E, K, F, Nframes] = lpcAnalysis(sigf, p, win, Fe);

%% Resynthesis
residual = myFilter(sigf, A, 1, win, over);
plot(residual)

resynthesized = myFilter(residual, 1, A, win, over);

% Using Lowpass filter
Fc = 100; % Cutoff frequency (Hz)
Fc = 2 * Fc / Fe;
[lp.B, lp.A] = butter(5, Fc, 'high');
fvtool(lp.B, lp.A) % visualizing
resynthesized = filter(lp.B, lp.A, resynthesized);

