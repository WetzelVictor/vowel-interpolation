%%% Based on Hyung-Suk Kim script "stackOLA.m"
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
n = length(x);
nw = length(w);
step = floor(nw*R);
count = floor((n-nw)/step) + 1;

%% INIT
X = zeros(nw, count);
offset = 0;

%% LOOP
for i = 1:count,
    % Computes end index ...
    limit = (i-1)*step + nw; 
    % ... and check if it tries to access a non-existing data cell
    if limit > n, 
      fill = zeros(1.5*nw - n + (i-1)*step - 1, 1);
      X(:,i) = w.* [ x(nw + offset:end); fill];
    else % otherwise, computes index. 
      offset = (i-1)*step;
      X(:, i) = w .* x( (1:nw) + offset );
    end
end

end
