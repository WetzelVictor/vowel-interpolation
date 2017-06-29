%%% VICTOR WETZEL
% LAM, 2017
% This program takes a bunch of file with a specific format, on build a database
% gathering informations about the signal, and LPC analysis
%
% FORMAT:
% <vowel>-flat.wav
%

clear all; close all;

%% BUILDING DATABASE
folder = 'audio/HOMME/';
fileList = ls(folder);
data = struct();
numberOfFile = 0;

for i = 1: length(fileList),
  importData = false; 

  if fileList(i) == '-',
    numberOfFile = numberOfFile + 1;
    data(numberOfFile).vowel = fileList(i-1);
  end

  if fileList(i) == 'v'
    flagB = i;
    flagA = flagB - 7;
     
    for j = flagA:-1:1,
      if fileList(j) == data(numberOfFile).vowel,
        break
      end
      flagA = flagA-1;
    end
    
    data(numberOfFile).fileName = fileList(flagA:flagB);
    importData = true;  
  end

  % Importing data
  if importData,  
    [data(numberOfFile).sig, Fs] = audioread(strcat(folder,data(numberOfFile).fileName));
    data(numberOfFile).sig = mean(data(numberOfFile).sig,2);
    data(numberOfFile).f0 = floor( ADMF(data(numberOfFile).sig, Fs) );
    data(numberOfFile).t0 = 1 / data(numberOfFile).f0;
    data(numberOfFile).N = length(data(numberOfFile).sig);
  end

end
% uncomment to check if the alogithm works well (playback)
% for i = 1:numberOfFile,
%   clc
%   disp(data(i).vowel);
%   soundsc(data(i).sig, Fs);
%   pause
% end


%% COMPUTING GCI
for i=1:numberOfFile,
  win = ones(1,floor(data(i).t0 * Fs)); 
  tempStack = stackOLA(abs( data(i).sig  ), win, 0);
  [maxStack, maxInd] = max(tempStack,[], 1);
  [Nwin, Ntrames] = size(tempStack);

  for j = 1:Ntrames,
    maxInd(:,j) = maxInd(:,j) + (j-1)*Nwin;
  end

  maxInd = reshape(maxInd, 1,[]);
  data(i).gci = maxInd;
end

%% COMPUTING LPC
% Number of pole
bdwthPerFormant = 1000; % (Hz) 1200 for female voice
p = 1 + floor(Fs / bdwthPerFormant);

for i=1:numberOfFile
  NdoubleCycle = floor(2 * data(i).t0 * Fs);
  win = hamming(NdoubleCycle,'periodic');
  over = 0.5;

  %% ANALYSIS
  [Atemp, Ktemp, ResTemp] = analysis(data(i).sig, Fs, p, win, over); 

  % store results
  data(i).A = Atemp;
  data(i).res = ResTemp;
end

%% WINDOWING DOUBLE-PERIODS
for i = 1:numberOfFile,
  NumberOfDoubleCycles = length(data(i).gci) - 2;

  for j = 1:NumberOfDoubleCycles,
    flagA = data(i).gci(j);
    flagB = data(i).gci(j + 2);

    if flagB > length(data(i).res),
      break;
    end

    Nwin = flagB - flagA + 1;
    win = hamming(Nwin, 'periodic');


    % Extracting data
    data(i).residualCycle(j).residual = data(i).res(flagA:flagB);
    data(i).residualCycle(j).windowedResidual = data(i).res(flagA:flagB) .* win ;
  end
end
