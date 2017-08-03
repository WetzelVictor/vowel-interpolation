clear all; close all;

% Import des données
load data/formant-syn-v2.txt
s.t = formant_syn_v2(:,1);
s.F1 = formant_syn_v2(:,2);
s.F2 = formant_syn_v2(:,3);
s.F3 = formant_syn_v2(:,4);
s.F4 = formant_syn_v2(:,5);

load data/formants-vocal-v3.txt
a.t = formants_vocal_v3(:,1);
a.F1 = formants_vocal_v3(:,2);
a.F2 = formants_vocal_v3(:,3);
a.F3 = formants_vocal_v3(:,4);
a.F4 = formants_vocal_v3(:,5);

% Constants
fmax = 2000; % fréquence maximale affichée(Hz)
fmin = 250; % fréquence minimale affichée(Hz)

Nf = 3; % Nombre de formants à observer
threshold = 100; % seuil (Hz)

%% ANALYSIS
%% GRAPH
figure
semilogy(s.t, [s.F1 s.F2 ],'r-+');
hold on
semilogy(a.t, [a.F1 a.F2 ],'b-+');
xlabel('Time (s)')
ylabel('Frequency (Hz)');
ylim([fmin fmax])
legend('Synthesis','Synthesis','Acoustic signal')
title('/i,y,u,o,c,a,3,e,i/')
grid on
