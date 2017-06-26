% function LSFinterpLPC
% This function takes to sets of Linear prediction coefficients, and interpolates them
% linearly. As interpolating LPCs doesn't provide enough stability, this method converts
% Ais in LSF (Line Spectral Frequencies) to perform the linear interpolation.
% Finally, the LSF coefficients are converted back to LPC coefficients
%
% INPUT:
% - A (size: [p, 2] with p beging the order of analysis): LPC coefficients to be
% interpolated
% - Nframes: number of frames to interpolates coefficients on
% - graph (boolean): if true, displays a figure with the interpolated coefficients
% OUTPUT: 
% - Aout (size: [p, Nframes]): interpolated LPC coefficients
%

function Aout = LSFinterpLPC(A, Nframes, graph),


if nargin < 3
  graph = false;
end

[p, ~] = size(A);
inLSF = zeros(p-1, 2);
outLSF = zeros(p-1, Nframes);

inLSF(:,1) = poly2lsf(A(:,1));
inLSF(:,2) = poly2lsf(A(:,2));
outLSF = interpVectors(inLSF, Nframes);
Aout = lsf2poly(outLSF)';



%% GRAPH
if graph
  figure;
  plot(Aout');
  xlabel('Number of frame')
  ylabel('Prediction filter coefficients')
  title('Prediction filter coefficients depending on the frame')
end

%%% THE END %%%
end
