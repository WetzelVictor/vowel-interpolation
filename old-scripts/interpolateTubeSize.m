%  [A, K, P] = interpolateTubeSize(Kt, Nframes, graph)
%       Interpolate reflection coefficient by interpolating tube size equivalent system
%
% INPUT:
%   - Kt: two column sized matrix containing to sets of reflective coefficient (PARCOR)
%   - Nframes: number of frames to interpolate the coefficients on (number of steps)
%   - graph (default: false (0)): if true, display the graph of interpolated tube sizes
%
% OUTPUT:
%   - A: Inteprolated poles
%   - K: Interpolated PARCOR
%   - P:

function [A, K, P] = interpolateTubeSize(Kt, Nframes, graph)

if nargin < 3
  graph = false;
end

%% K to Radius
% interpolating tube sizes
Ra = re2radius(Kt);
Ra = interpVectors(Ra, Nframes);
K = radius2re(Ra);

%% Rc to LPC
% initializing dsp object: reflection coefficient to LPC
rc2lpc = dsp.RCToLPC;

% convert K to LPC coefficient
[A, P] = rc2lpc(K);

%% GRAPH
if graph
  figure;
  plot(A');
  xlabel('Nombre de sample d''interpolation')
  ylabel('Valeur des poles')
  title('Valeur des poles en fonction du temps d''interpolation')
end

end
