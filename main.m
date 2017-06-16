close all; clear all; 

%% LOAD AUDIO 
% random audio signal
[sig, Fe] = audioread('audio/full-sentence.wav');
sig = 0.9*sig/max(abs(sig)); % normalize

% preemph = [1 0.63];
% sig = filter(1,preemph,sig);

%% GLOBAL VARIABLES
% Various
Te = 1/ Fe;
fmax = Fe / 2;

% ANALYSIS
N = length(sig);
Nwin = 512;
win = hamming(Nwin, 'periodic');
over = 0.5;
Nover = floor(over *Nwin);
Nframes = floor(N/(Nwin*over)) - 2;
Nfft = 1024;
p = 25; % number of LPC poles 

% VECTORS PLOT
t = [0:Nframes] * Te;
f = [-fmax : Fe/Nfft : fmax];

%% Spectrogram
[A, E, K, F] = spectroFormant(sig, p, Fe, win, Nover, Nfft);

figure;
plot(t, F')

% interpolating tube sizes
% Kt = [ K(:,24) K(:,94)];
Kt = [K(:, 56) K(:, 125)];
Ra = re2radius(Kt);
Ra = interpVectors(Ra, Nframes);
K1 = radius2re(Ra);

%% Rc to LPC
% initializing dsp object: reflection coefficient to LPC
rc2lpc = dsp.RCToLPC;

% convert K to LPC coefficient
[A1, P] = rc2lpc(K1);

%% GRAPH
figure;
plot(A1');
xlabel('Nombre de sample d''interpolation')
ylabel('Valeur des poles')
title('Valeur des poles en fonction du temps d''interpolation')
saveas(gcf, 'figs/interpolated-poles.png')


