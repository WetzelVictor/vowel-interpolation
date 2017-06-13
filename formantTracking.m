% formantTracking(A,Fe)
% Outputs frequencies corresponding to a given set of pole inputs
%
% A - set of poles
% Fe - sampling frequency (Hz)

function [ F ] = formantTracking( A, Fe )

F = zeros(size(A));
F = Fe * acos(A) / ( 2 * pi );

end

