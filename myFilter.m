% out = myFilter(Sig, B, A, win, over)
%      filters signal with a certain set of changing filters
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

%% LOOP
% first step: stores initial status for the filter
[outStack(:,11), zf] = filter(B(:,1),A(:,1), sigStack(:,1) );

% other steps
for i = 2: Nframes,
  [outStack(:,i), zf]= filter(B(:,i),A(:,i), sigStack(:,i), zf);
end

out = pressStack(outStack, over);
out = 0.9 * out/max(abs(out));

end
