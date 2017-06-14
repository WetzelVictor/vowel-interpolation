% [A, E, K, F] = lpcAnalysis(x, p, win, Fe)
%
% Returns poles A, E prediction error, K the PARCORS
% x : signal vector
% p : number of poles
% win : window (default: 128 point Hann window)
%

function [A, E, K, F] = lpcAnalysis(x, p, win,Fe)

%% OVERLOADING
if nargin < 3,
  win = hann(128, 'periodic');
  Fe = 0;
end

if nargin < 4,
  Fe = 0;
end

%% BASIC INFO
Nw = length(win);
N = length(x);
x = stackOLA(x, win, 0.5);
[~ , Nframes] = size(x);

%% INSTANCIATION
A = zeros(p+1, Nframes);
E = zeros(p, Nframes);
K = zeros(p, Nframes);
F = zeros(p, Nframes);

%% COMPUTING
for i = 1 : Nframes,
  % Yule-Walker method: computes poles, residual and reflective coefficients
  [A(:,i), E(:,i)] = lpc(x(:,i), p);
  if Fe > 0
    F(:,i) = formantTracking(A(2:end, i), Fe);
  end

end
