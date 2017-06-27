% S = re2radius(K)
%
% Converts a set of reflection coefficients into an array of tube cross-section
% K - reflection coefficients
%
% Ra - radius 

function Ra = re2radius(K),

%% INIT
[Nc, Ntrames] = size(K);
S = zeros(Nc + 1, Ntrames);

%% LOOP
for i = 1:Ntrames,
  % Default value of the first tube
  S(1,i) = 1;
  
  % Computing surface
  for j = 1: Nc,
    S(j+1,i) = S(j,i) * (1 + K(j,i)) / (1 - K(j,i));
  end
end

%% Converting to radius
Ra = sqrt(S/pi);

end
