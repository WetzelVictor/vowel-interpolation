% function out = interpSource(s1, s2)
%   Interpolate two residual signal (LPC) from s1 to s2
%   Output's length is the shortest of the two original signals
%   Method: weighted sum
%
% INPUT:
%   - s1, s2: signal to interpolate;
%
% OUTPUT:
%   - out: inteprolated signal
%

function out = interpSource(s1, s2)
[N1, ~] = size(s1);
[N2, ~] = size(s2);

% determines the shortest signal, and crop the other to fit
if N1 <= N2
  s2 = s2(1:N1,1);
  N = N1;
elseif N1 >= N2
  s1 = s1(1:N2,1);
  N = N2;
end

% interpolation coefficient
iCoef1 = [0:N-1]/N;

% init
out = [];

%% LOOP
for i = 1: N;
  temp = s1(i,1)*iCoef1(i) + s2(i,1)*(1 - iCoef1(i));
  out = [out; temp];
end

end
