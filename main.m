clear all; close all;

%% BASIC NFO
Nwin = 2048;
win = hamming(Nwin, 'periodic');
over = 0.5;
% p = 1 + floor( 44100/1200 );
% p = 6;
p = 15;

%% LOAD AUDIO 
% vowel i
[i.sig, Fe] = audioread('audio/i-flat.wav');
i.sig = i.sig(:,1); % to mono
i.sig = i.sig / (max(abs(i.sig)));


% vowel a
[a.sig, ~] = audioread('audio/a-flat.wav');
a.sig = a.sig(:,1); % to mono
a.sig = a.sig / (max(abs(a.sig)));

% phase alignement
[acor,lag] = xcorr(a.sig,i.sig);
[~,I] = max(abs(acor));
timeDiff = lag(I)-8;
a.sig = a.sig(timeDiff:end);

% % % FIGURE visualizing phase alignement % % %
% figure
% firstSamples = floor( Fe/220 );
% plot(a.sig(1:firstSamples));
% hold on
% plot(i.sig(1:firstSamples));
% grid on
% title('Visualizing phase alignement')
% xlabel('Samples')
% ylabel('Amplitude')
% legend('vowel a','vowel i')

%% BASIC INFOS
a.N = length(a.sig);
a.t = [0:a.N-1] / Fe;

i.N = length(i.sig);
i.t = [0:i.N-1] / Fe;

%% ANALYSIS
[i.A, i.K, i.res] = analysis(i.sig, Fe, p, win, over);
[a.A, a.K, a.res] = analysis(a.sig, Fe, p, win, over);


%% INTERPOLATION:
% Source (residual)
iRes = interpSource(i.res, a.res);
[~, Nframes] = size(stackOLA(iRes, win, over));

% Filter
Kc1 = i.K(:, 100);
Kc2 = a.K(:, 100);
[A, K, P] = interpolateTubeSize( [Kc1 Kc2], Nframes);

%% RESYNTHESIS
synth = myFilter(iRes, 1, A, win, over);

soundsc(synth, Fe);
audiowrite('output/interp3.wav',synth,Fe')
