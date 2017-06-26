% [A, E, K, F] = lpcAnalysis(x, p, win, Fe)
%
% Returns poles A, E prediction error, K the PARCORS
% x : signal vector
% p : number of poles
% win : window (default: 128 point Hann window)
%

function [A, E, K, Nframes] = lpcAnalysis(x, p, win)

%% OVERLOADING
if nargin < 3,
  win = hann(128, 'periodic');
end

%% BASIC INFO
Nw = length(win);
N = length(x);
x = stackOLA(x, win, 0.5);
[~ , Nframes] = size(x);

%% INSTANCIATION
A = zeros(p+1, Nframes); % filters' Ai
E = zeros(1, Nframes); % Estimation error
K = zeros(p, Nframes); % Reflective coefficient

%% COMPUTING
for i = 1 : Nframes,
  % Yule-Walker method: computes poles, residual and reflective coefficients
  % [A(:,i), E(i), K(:,i)] = aryule(x(:,i), p);

  % Burg's method
  [A(:,i), E(i), K(:,i)] = arburg(x(:,i), p);
end


end
