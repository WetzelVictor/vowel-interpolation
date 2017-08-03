% [A, K, Res] = analysis(sig, Fe, p, win, over)
%   Auto-regressive analysis with Yule-Walkers' method (LPC)
% 
% INPUT:
%   - sig: signal to be analysed 
%   - Fe: samplerate
%   - p : number of pole to perform analysis with (default: 1 + floor(Fe/1000))
%   - win: window (default: 512 hamming window)
%   - over: overlap (default: 50% --> over=0.5)
%
% OUTPUT:
%   - A: poles for each frame
%   - K: reflective coefficients
%   - Res: residual signal
%   - LSF: LSF coefficients


function [A, K, Res, LSF] = analysis(sig, Fe, p, win, over)

%% Default value
if nargin < 3
  % window
  Nwin = 512;
  win = hamming(Nwin, 'periodic');
  %overlapp
  over = 0.5;
  %poles
  p = 1 + floor(Fe/1000); % number of LPC poles 
elseif nargin < 4
  % window
  Nwin = 512;
  win = hamming(Nwin, 'periodic');
  %overlapp
  over = 0.5;
elseif nargin < 5
  %overlapp
  over = 0.5;
  Nwin = length(win);
else
  Nwin = length(win);
end

%% PRE-TREATMENT 
sig = 0.9*sig/max(abs(sig)); % normalize

% Preemphasis filter
preemph = [1 -0.93];
sigf = filter(preemph,1,sig);

%% GLOBAL VARIABLES
N = length(sigf);
Nover = floor(over *Nwin);

%% POLE ANALYSIS
[A, E, K, Nframes] = lpcAnalysis(sigf, p, win);

LSF = zeros(p, Nframes);

for i = 1:Nframes,
  LSF(:,i) = poly2lsf(A(:,i));
end

%% RESIDUAL
Res = myFilter(sigf, A, 1, win);

end
