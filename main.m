close all; clear all; clc;

%% LOAD AUDIO 

% vowel 'a'
[sigA, Fe] = audioread('audio/a.aif');
sigA = 0.9*sigA/max(abs(sigA)); % normalize

% vowel 'i'
[sigI, ~] = audioread('audio/i.aif');
sigI = 0.9*sigI/max(abs(sigI)); % normalize

%% GLOBAL VARIABLES

% Various
Te = 1/ Fe;
fmax = Fe / 2;
Ni = length(sigI);
Na = length(sigA);

% ANALYSIS
Nwin = 256;
win = hann(Nwin, 'periodic');
p = 6; % number of LPC poles 

% interpolation parameters
tInterp = 5; % time of interpolation (s)
nInterp = floor(tInterp * Fe);
Nframes = floor(nInterp / Nwin); % number of frames

% PLOT VECTORS
t = [0 : nInterp] * Te;
f = [-fmax : Fe/nInterp : fmax];

%% === PROGRAM ===


