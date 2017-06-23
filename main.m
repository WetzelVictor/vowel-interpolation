%%% VICTOR WETZEL
% vowel-interpolation
% GitHub: https://github.com/WetzelVictor/vowel-interpolation

clear all; close all;

%% BASIC NFO
Nwin = 2048;
win = hamming(Nwin, 'periodic');
over = 0.5;
% p = 1 + floor( 44100/1200 );
p = 25;

%% LOAD AUDIO 

% vowel 1
[v1.sig, Fe] = audioread('audio/i-flat.wav');
v1.sig = v1.sig(:,1); % to mono
v1.sig = v1.sig / (max(abs(v1.sig)));

% vowel 2
[v2.sig, ~] = audioread('audio/a-flat.wav');
v2.sig = v2.sig(:,1); % to mono
v2.sig = v2.sig / (max(abs(v2.sig)));


%% BASIC INFOS
v1.N = length(v1.sig);
v2.N = length(v2.sig);

% % % FIGURE visualizing phase alignement % % %
figure
firstSamples = floor( Fe/110 );
plot(v2.sig([ 1:firstSamples ] + 20000));
hold on
plot(v1.sig([1:firstSamples] + 20000));
grid on
title('Visualizing phase alignement')
xlabel('Samples')
ylabel('Amplitude')
legend('vowel a','vowel i')

%% ANALYSIS
[v1.A, v1.K, v1.res] = analysis(v1.sig, Fe, p, win, over);
[v2.A, v2.K, v2.res] = analysis(v2.sig, Fe, p, win, over);


%% INTERPOLATION:

% Source (residual)
iRes = interpSource(v2.res, v2.res);
[~, Nframes] = size(stackOLA(iRes, win, over));

% Filter
Kc1 = v1.K(:, 110);
Kc2 = v2.K(:, 100);
[A, K, P] = interpolateTubeSize( [Kc1 Kc2], Nframes, true);

%% RESYNTHESIS
synth = myFilter(iRes, 1, A, win, over);

soundsc(synth, Fe);
% audiowrite(output,synth,Fe)
