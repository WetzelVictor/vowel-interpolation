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
% if B or A is equal to one, then we create an empty array that is only filled with ones
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

%% INIT
Sig = zeros(N, 1); % output signal
flagA = 0; % top index for the given frame
flagB = 0; % bottom index ...............


%% LOOP
% first step: stores initial status for the filter

% computing indexes for each frame
flagA = 1;
flagB = flagA + Nwin;

% filtering first frame
[Sig(1:Nwin,1), zf] = filter(B(:,1), A(:,1), sig(1:Nwin, 1) );

% other steps
for i = 2: Nframes,
  % computing frame's indexes
  flagA = flagB + 1;
  flagB = flagA + Nwin ;
  
  % If we are at the end of the signal
  if flagB > N,
    flagB = N;
    break 
  end

  % filters the given frame
  [Sig(flagA:flagB,1), zf]= filter(B(:,i),A(:,i), sig(flagA:flagB,1), zf);

  %%% END OF THE LOOP %%%
end


%%% THE END %%%
end
