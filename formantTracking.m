% formantTracking(A,Fe)
% Outputs frequencies corresponding to a given set of pole inputs
%
% A - set of poles
% Fe - sampling frequency (Hz)

function [ F ] = formantTracking( A, Fe )

% find roots
rts = roots(A);
rts = rts(imag(rts) >= 0);

% converts in angles
angz = atan2(imag(rts),real(rts));

% converts to frequencues
[frqs, indices] = sort(angz.*(Fe/(2*pi)));

% computes bandwidth
bw = -1/2 * (Fe/(2*pi))*log(abs(rts(indices)));

% initialize formants storing array
formants = zeros(size(A));

% loop through formants
nn = 1;
for kk = 1:length(frqs)
    if (frqs(kk) > 90 && frqs(kk) < 5000 && bw(kk)< 1200)
        formants(nn) = frqs(kk);
        nn = nn+1;
    end
end

% output results in a correct format
F = [formants' ; zeros(length(A) - length(formants), 1)];
end

