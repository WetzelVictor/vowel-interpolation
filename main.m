clear all; close all;

%% BASIC NFO
Nwin = 960;
win = hamming(Nwin, 'periodic');
over = 0.5;
p = 1 + floor( 44100/1000 );

%% LOAD AUDIO 
% vowel i
[i.sig, Fe] = audioread('audio/i.wav');
i.sig = rmsct(i.sig, Nwin, 0.05);

% vowel a
[a.sig, ~] = audioread('audio/a.wav');
a.sig = rmsct(a.sig, Nwin, 0.05);

%% BASIC INFOS
a.N = length(a.sig);
a.t = [0:a.N-1] / Fe;
a.rms = rms(a.sig);

i.N = length(i.sig);
i.t = [0:i.N-1] / Fe;
i.rms = rms(i.sig);

%% ANALYSIS
[i.A, i.K, i.res] = analysis(i.sig, Fe, p, win);
[a.A, a.K, a.res] = analysis(a.sig, Fe, p, win);

[~, Nframes] = size(a.K);

%% PLOT
% figure
%
% % vowel a
% subplot 221
% plot(a.t, a.sig)
% title('vowel a')
% xlabel('Time(s)')
% ylabel('Amplitude')
%
% subplot 223
% plot(a.t, a.res)
% title('Residual')
% xlabel('Time(s)')
% ylabel('Amplitude')
%
% % vowel i
% subplot 222
% plot(i.t, i.sig)
% title('vowel i')
% xlabel('Time(s)')
% ylabel('Amplitude')
%
% subplot 224
% plot(i.t, i.res)
% title('Residual')
% xlabel('Time(s)')
% ylabel('Amplitude')
%

%% INTERPOLATION:
% Source (residual)
iRes = interpSource(a.res, i.res);

% Filter
Kc1 = a.K(:, 200);
Kc2 = i.K(:, 200);
[A, K, P] = interpolateTubeSize( [Kc1 Kc2], Nframes, true);

%% RESYNTHESIS
resynthesized = myFilter(a.res, 1, A, win, over);

% Using Lowpass filter
Fc = 300; % Cutoff frequency (Hz)
Fc = 2 * Fc / Fe;
[lp.B, lp.A] = butter(5, Fc, 'high');
resynthesized = filter(lp.B, lp.A, resynthesized);

