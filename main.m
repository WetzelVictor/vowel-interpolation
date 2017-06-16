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
p = 40; % number of LPC poles 

% VECTORS PLOT
t = [0:Nframes] * Te;
f = [-fmax : Fe/Nfft : fmax];

%% Spectrogram

% POLE ANALYSIS
[A, E, K, F, Nframes] = lpcAnalysis(sigf, p, win, Fe);
sigStack = stackOLA(sigf, win, over);

% spectroFormant(sigf, p, Fe, win, Nover, Nfft);

%% Resynthesis

% ex = randn(Nwin, Nframes);
residualStack = zeros(size(sigStack));
residual = zeros(1, N);

% computing residual
for i = 1: Nframes,
  residualStack(:,i) = filter(A(:,i), 1, sigStack(:,i) );
end

residual = pressStack(residualStack, over);
plot(residual)





% interpolateTubeSize.m
