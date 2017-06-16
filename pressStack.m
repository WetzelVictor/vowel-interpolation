%
% Renders an overlap-add stack into the original signal.
% It assumes the stacked signals are already windowed.
%
% X - a stacked overlap-add
% R - Overlap percentage (0<R<1) (default: 0.5)
%
% x - the rendered signal
%
function x = pressStack(X, R)

if nargin < 2
  R = 0.5;
end


[nw, count] = size(X);
step = floor(nw*R);
n = (count-1)*step+nw;

x = zeros(n, 1);

for i = 1:count
   x( (1:nw) + step*(i-1) ) = x( (1:nw) + step*(i-1) ) + X(:, i);
end

end
