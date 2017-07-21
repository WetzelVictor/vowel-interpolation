%% Experiment analysis
close all; clear all;
% Recording has to be cut in a certain way:
%     first sample should be the first beat of the first measure

%% CONSTANTS
% Recording
[sig, Fs] = audioread('audio/experiments/40bpm.wav');

% Analysis variables
N = length(sig);
P = 1 + Fs / 1000;
Twin = 0.020; % window's length (s)
Nwin = floor(0.020 *Fs); % window's length (samples)
over = 0.5; % overlapp
win = hamming(Nwin, 'periodic');

% Timing
bpm = 40; % tempo in bpm
interval = 60/bpm; % interval between each note (s)
Nvow = round( Fs *interval );
marge = 512; % margin within each steady vowel (samples)

% Data structure
numberOfVowels = 8;
data = struct();
data.date = datetime('today');

vowels = ['/i/';...
          '/y/';...
          '/u/';...
          '/o/';...
          '/c/';...
          '/a/';...
          '/3/';...
          '/e/'];

for i = 1:numberOfVowels
   data(i).vowel = vowels(i,:);
end

%% slicing n analyzing recording
j = 1;
for i = (0:numberOfVowels) *2,
  % Punch-in n out
  flagA = i *Fs *interval + marge;
  flagB = (i + 1) *Fs *interval - marge;

  if flagB > N
    break;
  end
  % Slicing
  data(j).sig = sig(flagA:flagB);

  % Extracting LSF
  [~, ~, ~, data(j).LSF] = analysis(data(j).sig, Fs, P, win, over); 
  j = j + 1;
end

%% Extracting recording's residual
[~, ~, residual, ~] = analysis(sig, Fs, P, win, over); 

for i = 1:numberOfVowels
  soundsc(data(i).sig, Fs);
  pause
end
