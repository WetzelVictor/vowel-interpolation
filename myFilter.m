% out = myFilter(Sig, A, win, over)
%
% sig - signal
% B - Numerator
% A - Denominator
% win - window
% over - overlap
%
% out - filtered signal

function out = myFilter(sig, B, A, win, over)

%% DEFAULT
if B == 1,
  [~, Nframes] = size(A);
  B = ones(1, Nframes);
elseif A == 1,
  [~, Nframes] = size(B);
  A = ones(1, Nframes);
end

%% NFO
N = length(sig);
Nwin = length(win);
sigStack = stackOLA(sig, win, over);

outStack = zeros(size(sigStack));
out = zeros(1, N);

for i = 1: Nframes,
  outStack(:,i) = filter(B(:,i),A(:,i), sigStack(:,i) );
end

out = pressStack(outStack, over);
out = 0.9 * out/max(abs(out));

end
