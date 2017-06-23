% Stacks a signal into overlap-add chunks.
%
% x - a single channel signal
% w - the window function
% R - (optional) step size (%)
% X - the overlap-add stack
%
function X = stackOLA(x, w, R)

%% Default configuration

if nargin < 2
  w = ones(512,1);
  R = 1;
elseif nargin < 3
  R = 1;
end

%% BASIC NFO
N = length(x);
Nw = length(w);

Nframes = floor(N/Nover);

