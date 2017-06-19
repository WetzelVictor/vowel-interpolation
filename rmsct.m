% sig = rmsct(x, Nwin, thresh)
% Returns any signal over RMS threshold
% %
% INPUT:
%   - x: signal
%   - Nwin: windows length
%   - thresh: threshold
%
% OUTPUT:
%   - sig: signal
%
% Original programmer: Pierre Massé
%

function bruit = rmsct(x, Nwin, thresh)

%% BASIC NFO
ref = thresh*rms(x);

N = length(x);
Nslice = floor(N/Nwin);
bruit = [];

%% LOOP

for i = 0:(Nslice-2)

    x_slice = x(i*Nwin+1:(i*Nwin+Nwin));
    R_slice = rms(x_slice);

    if R_slice > ref % if it's above threshold
        bruit = [bruit; x_slice];
    end

end

%% LAST FRAME
x_last = x(((Nslice-1)*Nwin+1):N);
R_last = rms(x_last);

if R_last > ref
        bruit(((Nslice-1)*Nwin+1):N) = x_last;
end

end
