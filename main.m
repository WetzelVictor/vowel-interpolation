clear all; close all;

%% BASIC NFO
Nwin = 2048;
win = hamming(Nwin, 'periodic');
over = 0.5;
p = 1 + floor( 44100/1200 );

%% LOAD AUDIO 
% vowel i
[i.sig, Fe] = audioread('audio/i-flat.wav');
i.sig = i.sig(:,1); % to mono
i.sig = rmsct(i.sig, Nwin, 0.02);
i.sig = i.sig(2.347e04:2.132e05);

% vowel a
[a.sig, ~] = audioread('audio/a-flat.wav');
a.sig = a.sig(:,1); % to mono
a.sig = rmsct(a.sig, Nwin, 1);
% a.sig = a.sig(1.578e04:2.227e05);

% phase alignement
[acor,lag] = xcorr(a.sig,i.sig);
[~,I] = max(abs(acor));
timeDiff = lag(I)-8;
a.sig = a.sig(timeDiff:end);

% visualizing phase alignement
firstSamples = floor( Fe/220 );
figure
plot(a.sig(1:firstSamples));
hold on
plot(i.sig(1:firstSamples));
grid on

% temp = a.sig;
% a.sig = i.sig;
% i.sig = temp;
%
%% BASIC INFOS
a.N = length(a.sig);
a.t = [0:a.N-1] / Fe;

i.N = length(i.sig);
i.t = [0:i.N-1] / Fe;

%% ANALYSIS
[i.A, i.K, i.res] = analysis(i.sig, Fe, p, win, over);
[a.A, a.K, a.res] = analysis(a.sig, Fe, p, win, over);

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
Kc1 = a.K(:, 100);
Kc2 = i.K(:, 100);
[A, K, P] = interpolateTubeSize( [Kc1 Kc2], Nframes, true);

%% RESYNTHESIS
synth = myFilter(a.res, 1, A, win, over);

% Using Lowpass filter
Fc = 300; % Cutoff frequency (Hz)
Fc = 2 * Fc / Fe;
[lp.B, lp.A] = butter(5, Fc, 'high');
synth = filter(lp.B, lp.A, synth);

