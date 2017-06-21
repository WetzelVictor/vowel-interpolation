%%% VICTOR WETZEL
% vowel-interpolation
% GitHub: https://github.com/WetzelVictor/vowel-interpolation

clear all; close all;

%% BASIC NFO
Nwin = 2048;
win = hamming(Nwin, 'periodic');
over = 0.5;
% p = 1 + floor( 44100/1200 );
p = 15;
F0 = 440; % pitch of the note (Hz)

%% LOAD AUDIO 
% vowel i
[v1.sig, Fe] = audioread('audio/a-flat.wav');
v1.sig = v1.sig(:,1); % to mono
v1.sig = v1.sig / (max(abs(v1.sig)));


% vowel a
[v2.sig, ~] = audioread('audio/u-flat.wav');
v2.sig = v2.sig(:,1); % to mono
v2.sig = v2.sig / (max(abs(v2.sig)));


%% BASIC INFOS
v1.N = length(v1.sig);
v2.N = length(v2.sig);

if v1.N <= v2.N
  v2.sig = v2.sig(1:v1.N);
else
  v1.sig = v1.sig(1:v2.N);
end

%% PHASE ALIGNEMENT
lp.cutoff = 340;
[lp.b, lp.a] = butter(10, 2*lp.cutoff/Fe, 'low');
v1.filtered = filter(lp.b, lp.a, v1.sig);
v2.filtered = filter(lp.b, lp.a, v2.sig);

[acor, lag] = xcorr(v1.filtered, v2.filtered, 'biased');
[~,I] = max(abs(acor));
timeDiff = lag(I);

if timeDiff < 0
  v2.sig = v2.sig(abs(timeDiff):end);
else
  v1.sig = v1.sig(timeDiff:end);
end

v1.N = length(v1.sig);
v2.N = length(v2.sig);

if v1.N <= v2.N
  v2.sig = v2.sig(1:v1.N);
else
  v1.sig = v1.sig(1:v2.N);
end

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
iRes = interpSource(v1.res, v2.res);
[~, Nframes] = size(stackOLA(iRes, win, over));

% Filter
Kc2 = v1.K(:, 110);
Kc1 = v2.K(:, 100);
[A, K, P] = interpolateTubeSize( [Kc1 Kc2], Nframes);

%% RESYNTHESIS
synth = myFilter(iRes, 1, A, win, over);

% soundsc(synth, Fe);
% audiowrite('output/interp3.wav',synth,Fe')
