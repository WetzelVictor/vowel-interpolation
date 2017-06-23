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
  R = 0;
elseif nargin < 3
  R = 0;
end

%% INPUT ERROR VERIFICATION
if R < 0 || R >= 1
  error('Bad Value: Overlap must be greater than 0 and less than one.');
end


%% BASIC NFO
% Computing signal, window and step length
N = length(x);
Nw = length(w);
Nover = floor(Nw*R);

% Compute step size
Nstep = Nw - Nover;

% Number of frames
Nframe = ceil((N-Nw)/Nstep)+1;

%% INIT
X = zeros(Nw, Nframe);
offset = 0;


%% Stacking: LOOP

for i = 1:Nframe,
    % Computes end index ...
    limit = (i-1)*Nstep + Nw; 

    % ... and check if it tries to access a non-existing data cell
    if limit > N, 
      disp( 'Zero-padding' )
      % Creates a vector filled with zero
      fill = zeros(1.5*Nw - N + (i-1)*Nstep - 1, 1);
      disp( length(fill) )

      % and zero pad the signal
      X(:,i) = w.* [ x(Nw + offset:end); fill];

    else % otherwise, computes index. 
      offset = (i-1)*Nstep;

      % ... and inputs the signal multiplied by the window in the right frame
      X(:, i) = w .* x( (1:Nw) + offset );
    end


%% END OF FUNCTION
end


