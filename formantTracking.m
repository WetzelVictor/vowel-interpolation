% formantTracking(A,Fe)
% Outputs frequencies corresponding to a given set of pole inputs
%
% A - set of poles
% Fe - sampling frequency (Hz)

function [ F ] = formantTracking( A, Fe )
rts = roots(A);
rts = rts(imag(rts) >= 0);
angz = atan2(imag(rts),real(rts));
[frqs, indices] = sort(angz.*(Fe/(2*pi)));
bw = -1/2 * (Fe/(2*pi))*log(abs(rts(indices)));

nn = 1;
for kk = 1:length(frqs)
    if (frqs(kk) > 90 && bw(kk) <400)
        formants(nn) = frqs(kk);
        nn = nn+1;
    end
end

F = [frqs ; zeros(length(A) - length(frqs), 1)];
end

