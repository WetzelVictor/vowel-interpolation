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

function Sig = myFilter(sig, B, A, win)

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

%% LOOP
% first step: stores initial status for the filter
[Sig(1:Nwin,1), zf] = filter(B(:,1),A(:,1), sig(1:Nwin, 1) );
Sig = zeros(N, 1);

% other steps
for i = 2: Nframes,
  flagA = Nwin * i + 1;
  flagB = flagA + Nwin;

  if flagB > N,
    flagB = N;
  end

  [Sig(flagA:flagB,1), zf]= filter(B(:,i),A(:,i), sig(flagA:flagB,1), zf);
end

end
