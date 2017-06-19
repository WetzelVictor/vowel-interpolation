% Goes into main.m

%% K to Radius
% interpolating tube sizes
Kt = [K(:, 56) K(:, 125)];
Ra = re2radius(Kt);
Ra = interpVectors(Ra, Nframes);
K1 = radius2re(Ra);

%% Rc to LPC
% initializing dsp object: reflection coefficient to LPC
rc2lpc = dsp.RCToLPC;

% convert K to LPC coefficient
[A1, P] = rc2lpc(K1);

%% GRAPH
figure;
plot(A1');
xlabel('Nombre de sample d''interpolation')
ylabel('Valeur des poles')
title('Valeur des poles en fonction du temps d''interpolation')
saveas(gcf, 'figs/interpolated-poles.png')


