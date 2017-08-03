%%% VICTOR WETZEL
% vowel-interpolation
% GitHub: https://github.com/WetzelVictor/vowel-interpolation
clear all; close all;


%% BASIC NFO
Nwin = 1024;
win = hamming(Nwin, 'periodic');
over = 0.5;

%% LOAD AUDIO 
% vowel 1
[v1.sig, Fe] = audioread('audio/HOMME/a-flat.wav');
v1.sig = v1.sig(:,1); % to mono
v1.sig = v1.sig / (max(abs(v1.sig)));

% vowel 2
[v2.sig, ~] = audioread('audio/HOMME/i-flat.wav');
v2.sig = v2.sig(:,1); % to mono
v2.sig = v2.sig / (max(abs(v2.sig)));

%% BASIC INFOS
v1.N = length(v1.sig);
v2.N = length(v2.sig);

%% ANALYSIS
% Defining the order of the analysis
p = 1 + floor(Fe/1000); % replace denominator by 1kHz for a male voice

% Analysis for both vowel signals
[v1.A, v1.K, v1.res] = analysis(v1.sig, Fe, p, win, over);
[v2.A, v2.K, v2.res] = analysis(v2.sig, Fe, p, win, over);


%% INTERPOLATION
% Source/residual 
%   - Shortest signal determines interpolated residual (iRes)
iRes = interpSource(v1.res, v2.res);
[~, Nframes] = size(stackOLA(iRes, win, over));

% Interpolating LSF coefficients
Ac1 = v1.A(:, 110);
Ac2 = v2.A(:, 100);
A = LSFinterpLPC([Ac1 Ac2], Nframes, true);


%% RESYNTHESIS
synth = myFilter(iRes, 1, A, win);

%% PLAYBACK
% Uncomment to play resynthesized samples
% soundsc(synth, Fe);

% Uncomment to save sound
% audiowrite('output/synth.wav',synth,Fe)
