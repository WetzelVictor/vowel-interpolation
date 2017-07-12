% structToMax(data, projectName, Fe)
%
% Puts a particular structure into a MaxMSP suitable format (text files, .wav, etc...)
%
% INPUT:
%   - data: data structure
%

function structToMax(data, projectName, Fe)

%% BASIC NFO
numberOfVowels = length(data);
[~, Nvow] = size(data);
%% LOOP THROUGH EVERY VOWEL
mkdir(projectName)
cd(projectName);



for i = 1:Nvow,

  [p, Nframes] = size(data(i).LSF);
  % Create the folder for the vowel
  % folderName = data(i).vowel;
  % mkdir(folderName)
  % cd(folderName)
  fileName = strcat(data(i).vowel,'.lsf');
  fileID = fopen(fileName,'w');
  
  % Looping through each set of LSF
  for j = 1:Nframes,
    % LSF
    lsf = round(data(i).LSF(:,j) ,4)';
    fprintf(fileID, '%i,', j);
    fprintf(fileID, '%6.5f ', lsf);
    fprintf(fileID,';\n');
  end
  
  fclose(fileID);

  % GCI
  fileName = sprintf('%s.gci', data(i).vowel);
  fileID = fopen(fileName,'w');
  fprintf(fileID,'%i',i,data(i).gci);
  fclose(fileID);

  % RESIDUAL
  fileName = sprintf('%s.wav', data(i).vowel);
  data(i).res = data(i).res/max(abs(data(i).res))*0.9;
  audiowrite(fileName, data(i).res, Fe);
end

cd ..
