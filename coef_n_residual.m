%%% VICTOR WETZEL
% LAM, 2017
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
  win = ones(1,data(i).t0 * Fs); 
  tempStack = stackOLA(abs( data(i).sig ), win, 0);
  
  % Pour chaque fenêtre, repérer le max, et lui mettre un tag 'GCI'. Ensuite on remet 
  % le stack en signal et on le store dans la BDD
end
