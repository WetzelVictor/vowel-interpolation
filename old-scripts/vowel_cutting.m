clear all; close all; 

nfo = importdata('nfo.txt');

vowels.head = char(nfo.textdata(:,1));
vowels.filename = string(nfo.textdata(:,2)); 
vowels.filename = char(vowels.filename);

for i = 1:numel(vowels.head),
  if vowels.filename(i,end) == 'v'
    filepath = vowels.filename(i,1:end);
    [temp, Fs] = audioread(filepath);
  else  
    filepath = vowels.filename(i,1:end-1);
    [temp, Fs] = audioread(filepath);
  end 

  % retrieving indexes
  flagA = nfo.data(i,1);
  flagB = nfo.data(i,2);
 
  % storing data into structure
  data(i).head = vowels.head(i,:);
  data(i).sig = temp(flagA : flagB);
  data(i).filename = filepath;
  data(i).N = length(temp); 
end

save('voy-homme-cut.mat','data','Fs');
