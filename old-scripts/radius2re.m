% K = radius2re(Ra)
%
% Converts a set of crosssections into an array of reflection coefficients
% K - reflection coefficients
%
% Ra - Cross sections

function K = radius2re(Ra),

%% INIT
[Nt, Ntrames] = size(Ra);
Nc = Nt -1; % number of coefficients

K = zeros(Nc, Ntrames);

% Converting radius to surface
S = pi * Ra.^2;

%% LOOP
for i = 1:Ntrames,
  % Computing reflection coefficients 
  for j = 1:Nc,
    K(j,i) = (S(j+1,i) - S(j, i))/(S(j+1,i) + S(j,i));
  end
end

end
